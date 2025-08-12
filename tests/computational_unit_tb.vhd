library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex.all;

entity computational_unit_tb is
end entity;

architecture sim of computational_unit_tb is

    constant ITER_WIDTH : positive := 8;
    constant THRESHOLD  : ads_fixed := to_ads_fixed(4);

    signal clk        : std_logic := '0';
    signal rst_n      : std_logic := '0';
    signal start      : std_logic := '0';
    signal done       : std_logic;
    signal c_re, c_im : ads_fixed := to_ads_fixed(0);
    signal z_re, z_im : ads_fixed := to_ads_fixed(0);
    signal max_iter   : unsigned(ITER_WIDTH-1 downto 0) := (others => '0');
    signal iter_count : unsigned(ITER_WIDTH-1 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin
    -- DUT
    dut: entity work.computational_unit
        generic map (
            ITER_WIDTH => ITER_WIDTH,
            THRESHOLD  => THRESHOLD
        )
        port map (
            clk        => clk,
            rst_n      => rst_n,
            start      => start,
            done       => done,
            c_re       => c_re,
            c_im       => c_im,
            z_re       => z_re,
            z_im       => z_im,
            max_iter   => max_iter,
            iter_count => iter_count
        );

    clk <= not clk after CLK_PERIOD/2;

    stim_proc: process
    begin
        -- Reset
        rst_n <= '0';
        wait for 2*CLK_PERIOD;
        rst_n <= '1';
        wait for CLK_PERIOD;

        report "Test 1: c=0+0i, z=0+0i, expect max iterations";
        c_re <= to_ads_fixed(0.0);
        c_im <= to_ads_fixed(0.0);
        z_re <= to_ads_fixed(0.0);
        z_im <= to_ads_fixed(0.0);
        max_iter <= to_unsigned(20, ITER_WIDTH);
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        report "Iterations: " & integer'image(to_integer(iter_count));

        report "Test 2: c=2+0i, z=0+0i, expect early escape";
        c_re <= to_ads_fixed(2.0);
        c_im <= to_ads_fixed(0.0);
        z_re <= to_ads_fixed(0.0);
        z_im <= to_ads_fixed(0.0);
        max_iter <= to_unsigned(20, ITER_WIDTH);
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        report "Iterations: " & integer'image(to_integer(iter_count));

        -- Finish
        wait for 5*CLK_PERIOD;
        report "Simulation finished";
        wait;
    end process;
end architecture;