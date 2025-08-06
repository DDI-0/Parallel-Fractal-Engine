library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ads_fixed_pkg.all;
use work.ads_complex_pkg.all;

entity computational_unit is
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        start   : in  std_logic;
        
        done    : out std_logic;
        inside  : out std_logic;
        escaped : out std_logic
    );
end entity computational_unit;

architecture behvorial of compuational_unit is
    function mandelbrot_math (
        c        :  in ads_complex;
        max_iter :  in  natural; 
        z        :  in ads_complex := complex_zero;
    ) return natural 
        variable  i         : natural :=0;
        constant threshold  : ads_sfxied := to_ads_sfixed(4.0);
    begin 
        while i < max_iter
            z := () ** 2 + (c.re + c.im);
