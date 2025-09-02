library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

library work;
use work.util_pkg.all;

entity computational_unit is
    generic (
        ITER_MAX : positive := 16;
        THRESHOLD : ads_fixed := to_ads_fixed(4)
    );
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        mode : in std_logic; -- '0' for Mandelbrot, '1' for Julia
        c_in : in ads_complex; -- For Mandelbrot: coordinate; For Julia: fixed parameter
        z_in : in ads_complex; -- For Julia: coordinate; Ignored for Mandelbrot
        enable : in std_logic; -- Enable signal to latch inputs
        iter : out unsigned(num_bits(ITER_MAX) - 1 downto 0)
    );
end entity computational_unit;

architecture rtl of computational_unit is
    constant ITER_MAX_CONST : unsigned(iter'range) := to_unsigned(ITER_MAX - 1, iter'length);
    signal Iter_counter : unsigned(iter'range) := (others => '0');
    signal c : ads_complex := complex_zero;
    signal z : ads_complex := complex_zero;
    signal z_next : ads_complex;
    signal done_i : boolean;
begin
    z_next.re <= (z.re * z.re) - (z.im * z.im) + c.re;
    z_next.im <= (z.re * z.im) + (z.im * z.re) + c.im;
    iter <= Iter_counter;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                Iter_counter <= (others => '0');
                done_i <= true;
                z <= complex_zero;
                c <= complex_zero;
            elsif enable = '1' then
                if done_i then
                    -- Start a new computation
                    c <= c_in;
                    Iter_counter <= (others => '0');
                    done_i <= false;
                    -- Set initial z based on mode
                    if mode = '0' then -- Mandelbrot
                        z <= complex_zero;
                    else -- Julia
                        z <= z_in;
                    end if;
                else
                    -- Continue computation
                    if (abs2(z) > THRESHOLD) or (Iter_counter = ITER_MAX_CONST) then
                        done_i <= true;
                    else
                        z <= z_next;
                        Iter_counter <= Iter_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture rtl;