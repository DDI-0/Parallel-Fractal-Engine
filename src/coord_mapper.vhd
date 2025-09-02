library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.vga_controller.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

entity coord_mapper is
    generic (
        vga_res : vga_timing := vga_res_default
    );
    port (
        coord_clk   : in  std_logic;
        rst_n       : in  std_logic;
        pixel_coord : in  coordinate;
        c_out       : out ads_complex
    );
end entity coord_mapper;

architecture behavior of coord_mapper is
    constant re_range   : ads_fixed := to_ads_fixed(4.0);
    constant im_range   : ads_fixed := to_ads_fixed(3.0);  
    constant re_offset : ads_fixed := to_ads_fixed(-2.0); 
    constant im_offset : ads_fixed := to_ads_fixed(240.0); 
    constant x_range   : ads_fixed := to_ads_fixed(1.0 / real(vga_res.horizontal.active_pixel)); -- 1/640
    constant y_range   : ads_fixed := to_ads_fixed(1.0 / real(vga_res.vertical.active_pixel));  -- 1/480
begin
    conversion: process(coord_clk)
        variable p_scaled   : ads_fixed;
        variable l_scaled   : ads_fixed;
        variable l_adjusted : ads_fixed;
        variable c_temp     : ads_complex;
    begin
        if rising_edge(coord_clk) then
            if rst_n = '0' then
                c_out <= complex_zero; 
            else
                p_scaled   := to_ads_fixed(pixel_coord.x) * re_range;
                l_adjusted := im_offset - to_ads_fixed(pixel_coord.y);
                l_scaled   := l_adjusted * im_range;
                c_temp.re  := (p_scaled * x_range) + re_offset;
                c_temp.im  := l_scaled * y_range;
                c_out      <= c_temp;
            end if;
        end if;
    end process;
end architecture behavior;