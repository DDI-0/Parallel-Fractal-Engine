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
        vga_res : vga_timing := vga_res_640x480
    );
    port (
        coord_clk : in std_logic;
        rst_n : in std_logic;
        pixel_coord : in coordinate;
        c_out : out ads_complex
    );
end entity coord_mapper;

architecture behavior of coord_mapper is
    -- Constants for Mandelbrot set mapping: Re{c} in [-2.2, 1], Im{c} in [-1.2, 1.2]
    constant re_range : ads_fixed := to_ads_fixed(3.2); -- Real axis span
    constant im_range : ads_fixed := to_ads_fixed(2.4); -- Imaginary axis span
    constant re_offset : ads_fixed := to_ads_fixed(-2.35); -- Real axis offset
    constant im_offset : ads_fixed := to_ads_fixed(240.0); -- Imaginary axis offset
    constant x_range : ads_fixed := to_ads_fixed(1.0 / real(vga_res.horizontal.active_pixel)); -- 1/640
    constant y_range : ads_fixed := to_ads_fixed(1.0 / real(vga_res.vertical.active_pixel)); -- 1/480

    subtype valid_x is natural range 0 to vga_res.horizontal.active_pixel - 1;
    subtype valid_y is natural range 0 to vga_res.vertical.active_pixel - 1;
begin
    conversion: process(coord_clk)
        variable x_coord : valid_x;
        variable y_coord : valid_y;
    begin
        if rising_edge(coord_clk) then
            if rst_n = '0' then
                c_out <= complex_zero;
            else
                -- Constrain coordinates to valid range
                if pixel_coord.x < vga_res.horizontal.active_pixel then
                    x_coord := pixel_coord.x;
                else
                    x_coord := 0;
                end if;
                if pixel_coord.y < vga_res.vertical.active_pixel then
                    y_coord := pixel_coord.y;
                else
                    y_coord := 0;
                end if;

                c_out.re <= (to_ads_fixed(x_coord) * re_range * x_range) + re_offset; -- 3.2 * p / 640 - 2.2
                c_out.im <= (im_offset - to_ads_fixed(y_coord)) * im_range * y_range; -- 2.4 * (240 - l) / 480
            end if;
        end if;
    end process;
end architecture behavior;