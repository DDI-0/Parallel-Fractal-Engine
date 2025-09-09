library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.vga_controller.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

library work;
use work.util_pkg.all;
use work.color_data.all;

entity fractal_engine is
    generic (
        ITER_MAX   : positive   := 32;
        VGA_RES    : vga_timing := vga_res_640x480;
        THRESHOLD  : ads_fixed  := to_ads_fixed(4.0)
    );
    port (
        clk         : in  std_logic;
        rst_n       : in  std_logic;
        mode        : in  std_logic;
        julia_c     : in  ads_complex;
        palette_sel : in  std_logic_vector(1 downto 0);
        pixel_coord : in  coordinate;
        point_valid : in  boolean;
        rgb_out_r   : out unsigned(7 downto 0);
        rgb_out_g   : out unsigned(7 downto 0);
        rgb_out_b   : out unsigned(7 downto 0)
    );
end entity fractal_engine;

architecture rtl of fractal_engine is
    constant NUM_UNITS       : positive := ITER_MAX;
    constant CU_SEL_WIDTH    : positive := num_bits(NUM_UNITS);
    constant MAX_ITER_CONST  : unsigned(num_bits(ITER_MAX) - 1 downto 0) := to_unsigned(ITER_MAX - 1, num_bits(ITER_MAX));
    signal iter_dummy        : unsigned(num_bits(ITER_MAX) - 1 downto 0);
    type iter_array_type is array (0 to NUM_UNITS - 1) of unsigned(iter_dummy'range);
    signal mapped_c          : ads_complex;
    signal final_rgb         : rgb_color;
    signal iter_from_cu      : unsigned(iter_dummy'range);
    signal cu_selector       : unsigned(CU_SEL_WIDTH - 1 downto 0);
    signal c_to_cu           : ads_complex;
    signal z_to_cu           : ads_complex;
    signal c_to_cu_reg       : ads_complex;
    signal z_to_cu_reg       : ads_complex;
    signal cu_iter_array     : iter_array_type;
begin
    coord_mapper_inst : entity work.coord_mapper
        generic map (
            vga_res => VGA_RES
        )
        port map (
            coord_clk    => clk,
            rst_n        => rst_n,
            pixel_coord  => pixel_coord,
            c_out        => mapped_c
        );

    with mode select
        c_to_cu <= mapped_c when '0',
                   julia_c   when others;

    with mode select
        z_to_cu <= complex_zero when '0',
                   mapped_c     when others;

    control_process : process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                cu_selector <= (others => '0');
            else
                if point_valid then
                    cu_selector <= cu_selector + 1;
                end if;
            end if;
        end if;
    end process control_process;

    cu_input_reg_process : process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                c_to_cu_reg <= complex_zero;
                z_to_cu_reg <= complex_zero;
            else
                if point_valid then
                    c_to_cu_reg <= c_to_cu;
                    z_to_cu_reg <= z_to_cu;
                end if;
            end if;
        end if;
    end process cu_input_reg_process;

    cu_generate : for i in 0 to NUM_UNITS - 1 generate
        signal cu_enable : std_logic;
    begin
        cu_enable <= '1' when (to_integer(cu_selector) = i and point_valid) else '0';

        cu_inst : entity work.computational_unit
            generic map (
                ITER_MAX  => ITER_MAX,
                THRESHOLD => THRESHOLD
            )
            port map (
                clk    => clk,
                rst_n  => rst_n,
                mode   => mode,
                c_in   => c_to_cu_reg,
                z_in   => z_to_cu_reg,
                enable => cu_enable,
                iter   => cu_iter_array(i)
            );
    end generate cu_generate;

    iter_from_cu <= cu_iter_array(to_integer(cu_selector));

    color_mapper_inst : entity work.color_mapper
        generic map (
            MAX_ITER_VALUE => ITER_MAX
        )
        port map (
            color_clk   => clk,
            rst_n       => rst_n,
            iter_count  => iter_from_cu,
            palette_sel => palette_sel,
            rgb_out     => final_rgb
        );

    output_register_process : process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                rgb_out_r <= (others => '0');
                rgb_out_g <= (others => '0');
                rgb_out_b <= (others => '0');
            else
                if point_valid then
                    rgb_out_r <= to_unsigned(final_rgb.red, 8);
                    rgb_out_g <= to_unsigned(final_rgb.green, 8);
                    rgb_out_b <= to_unsigned(final_rgb.blue, 8);
                else
                    rgb_out_r <= (others => '0');
                    rgb_out_g <= (others => '0');
                    rgb_out_b <= (others => '0');
                end if;
            end if;
        end if;
    end process output_register_process;
end architecture rtl;
