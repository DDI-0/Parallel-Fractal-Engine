library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;
use ads.seed_table.all; 

library vga;
use vga.vga_controller.all;

entity fpga_top is
    port (
        CLK_50MHZ : in std_logic;
        KEY : in std_logic_vector(0 downto 0);
        SW : in std_logic_vector(2 downto 0);
        -- VGA Outputs
        VGA_HS : out std_logic;
        VGA_VS : out std_logic;
        VGA_BLANK_N : out std_logic;
        VGA_CLK : out std_logic;
        VGA_SYNC_N : out std_logic;
        VGA_R : out std_logic_vector(7 downto 0);
        VGA_G : out std_logic_vector(7 downto 0);
        VGA_B : out std_logic_vector(7 downto 0)
    );
end entity fpga_top;

architecture rtl of fpga_top is
    component pll is
        port (
            refclk : in std_logic;
            rst : in std_logic;
            outclk_0 : out std_logic
        );
    end component pll;

    component fractal_engine is
        generic (
            ITER_MAX : positive := 32;
            VGA_RES : vga_timing := vga_res_640x480;
            THRESHOLD : ads_fixed := to_ads_fixed(4.0)
        );
        port (
            clk : in std_logic;
            rst_n : in std_logic;
            mode : in std_logic;
            julia_c : in ads_complex;
            palette_sel : in std_logic_vector(1 downto 0);
            pixel_coord : in coordinate;
            point_valid : in boolean;
            rgb_out_r : out unsigned(7 downto 0);
            rgb_out_g : out unsigned(7 downto 0);
            rgb_out_b : out unsigned(7 downto 0)
        );
    end component fractal_engine;

    component vga_fsm is
        generic (
            vga_res : vga_timing := vga_res_640x480
        );
        port (
            vga_clk : in std_logic;
            rst_n : in std_logic;
            h_sync : out std_logic;
            v_sync : out std_logic;
            point_valid : out boolean;
            pixel_coord : out coordinate;
            VGA_BLANK_N : out std_logic;
            VGA_SYNC_N : out std_logic
        );
    end component vga_fsm;

    component vga_delay_shift is
        generic (
            DELAY : positive := 32
        );
        port (
            clk : in std_logic;
            rst_n : in std_logic;
            in_h_sync : in std_logic;
            in_v_sync : in std_logic;
            in_blank_n : in std_logic;
            in_sync_n : in std_logic;
            in_point_valid : in boolean;
            out_h_sync : out std_logic;
            out_v_sync : out std_logic;
            out_blank_n : out std_logic;
            out_sync_n : out std_logic;
            out_point_valid : out boolean
        );
    end component vga_delay_shift;

    signal rst_n : std_logic;
    signal reset : std_logic;
    signal pixel_clk : std_logic;
    signal pixel_coord : coordinate;
    signal point_valid : boolean;
    signal rgb_r_s : unsigned(7 downto 0);
    signal rgb_g_s : unsigned(7 downto 0);
    signal rgb_b_s : unsigned(7 downto 0);
    -- Signals for VGA FSM outputs
    signal fsm_h_sync : std_logic;
    signal fsm_v_sync : std_logic;
    signal fsm_blank_n : std_logic;
    signal fsm_sync_n : std_logic;
    -- Signals for delayed outputs
    signal delayed_h_sync : std_logic;
    signal delayed_v_sync : std_logic;
    signal delayed_blank_n : std_logic;
    signal delayed_sync_n : std_logic;
    signal delayed_point_valid : boolean;
    -- Signals for Julia seed animation
    signal julia_c : ads_complex;
    signal seed_index : seed_index_type := 0;
    signal prev_v_sync : std_logic;
    signal frame_count : unsigned(1 downto 0) := "00";  -- Count 0 to 2 for 3 frames
begin
    rst_n <= KEY(0);
    reset <= not rst_n;

    pll_inst : component pll
        port map (
            refclk => CLK_50MHZ,
            rst => reset,
            outclk_0 => pixel_clk
        );

    vga_fsm_inst : component vga_fsm
        generic map (
            vga_res => vga_res_640x480
        )
        port map (
            vga_clk => pixel_clk,
            rst_n => rst_n,
            h_sync => fsm_h_sync,
            v_sync => fsm_v_sync,
            point_valid => point_valid,
            pixel_coord => pixel_coord,
            VGA_BLANK_N => fsm_blank_n,
            VGA_SYNC_N => fsm_sync_n
        );

    vga_delay_inst : component vga_delay_shift
        generic map (
            DELAY => 32
        )
        port map (
            clk => pixel_clk,
            rst_n => rst_n,
            in_h_sync => fsm_h_sync,
            in_v_sync => fsm_v_sync,
            in_blank_n => fsm_blank_n,
            in_sync_n => fsm_sync_n,
            in_point_valid => point_valid,
            out_h_sync => delayed_h_sync,
            out_v_sync => delayed_v_sync,
            out_blank_n => delayed_blank_n,
            out_sync_n => delayed_sync_n,
            out_point_valid => delayed_point_valid
        );

    fractal_engine_inst : component fractal_engine
        generic map (
            ITER_MAX => 32,
            VGA_RES => vga_res_640x480,
            THRESHOLD => to_ads_fixed(4.0)
        )
        port map (
            clk => pixel_clk,
            rst_n => rst_n,
            mode => SW(0),
            palette_sel => SW(2 downto 1),
            julia_c => julia_c,
            pixel_coord => pixel_coord,
            point_valid => delayed_point_valid,
            rgb_out_r => rgb_r_s,
            rgb_out_g => rgb_g_s,
            rgb_out_b => rgb_b_s
        );

    -- Julia seed animation process
    seed_selection: process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if rst_n = '0' then
                seed_index <= 0;
                julia_c <= seed_rom(0);
                prev_v_sync <= '1';
                frame_count <= "00";
            else
                prev_v_sync <= fsm_v_sync;
                if prev_v_sync = '1' and fsm_v_sync = '0' then  -- Falling edge of v_sync (new frame)
                    if frame_count = "10" then  -- Every 3rd frame
                        frame_count <= "00";
                        if SW(0) = '1' then  -- Julia mode
                            seed_index <= get_next_seed_index(seed_index);
                            julia_c <= seed_rom(seed_index);
                        else  -- Mandelbrot mode
                            julia_c <= seed_rom(0);  -- Use origin for consistency
                        end if;
                    else
                        frame_count <= frame_count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Connect delayed signals to VGA outputs
    VGA_HS <= delayed_h_sync;
    VGA_VS <= delayed_v_sync;
    VGA_BLANK_N <= delayed_blank_n;
    VGA_SYNC_N <= delayed_sync_n;
    VGA_CLK <= pixel_clk;
    VGA_R <= std_logic_vector(rgb_r_s);
    VGA_G <= std_logic_vector(rgb_g_s);
    VGA_B <= std_logic_vector(rgb_b_s);
end architecture rtl;