library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

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

    constant JULIA_C_CONST : ads_complex := ads_cmplx(to_ads_fixed(-0.7269), to_ads_fixed(0.1889));
    signal rst_n : std_logic;
    signal reset : std_logic;
    signal pixel_clk : std_logic;
    signal pixel_coord : coordinate;
    signal point_valid : boolean;
    signal rgb_r_s : unsigned(7 downto 0);
    signal rgb_g_s : unsigned(7 downto 0);
    signal rgb_b_s : unsigned(7 downto 0);
begin
    rst_n <= KEY(0);
    reset <= not rst_n;

    pll_inst : component pll
        port map (
            refclk => CLK_50MHZ, -- refclk.clk
            rst => reset, -- reset.reset
            outclk_0 => pixel_clk -- outclk0.clk
        );

    vga_fsm_inst : component vga_fsm
        generic map (
            vga_res => vga_res_640x480
        )
        port map (
            vga_clk => pixel_clk,
            rst_n => rst_n,
            h_sync => VGA_HS,
            v_sync => VGA_VS,
            point_valid => point_valid,
            pixel_coord => pixel_coord,
            VGA_BLANK_N => VGA_BLANK_N,
            VGA_SYNC_N => VGA_SYNC_N
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
            julia_c => JULIA_C_CONST,
            pixel_coord => pixel_coord,
            point_valid => point_valid,
            rgb_out_r => rgb_r_s,
            rgb_out_g => rgb_g_s,
            rgb_out_b => rgb_b_s
        );

    VGA_CLK <= pixel_clk;
    VGA_R <= std_logic_vector(rgb_r_s);
    VGA_G <= std_logic_vector(rgb_g_s);
    VGA_B <= std_logic_vector(rgb_b_s);
end architecture rtl;