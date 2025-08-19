library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.vga_controller.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex.all;

entity coord_mapper is
	generic (
		vga_res	: vga_timing := vga_res_default
	);
	port (
		clk				: in  std_logic;
		rst_n 			: in  std_logic;
		pixel_coord		: in  coordinate;
		point_valid		: in  boolean;
		c_re				: out ads_fixed;
		c_im  			: out ads_fixed;
		valid_out 		: out std_logic 
	);
	
end entity coord_mapper;

architecture behavior of coord_mapper is

	constant re_range	 : ads_fixed  := to_ads_fixed(3.2);
	constant im_range	 : ads_fixed  := to_ads_fixed(2.2);
	constant	re_offset : ads_fixed  := to_ads_fixed(-2.2);
	constant im_offset : ads_fixed  := to_ads_fixed(240);
	constant x_range 	 : ads_fixed  := to_ads_fixed((vga_res.horizontal.active_pixel)); -- 1920 
	constant y_range   : ads_fixed  := to_ads_fixed((vga_res.vertical.active_pixel)) ; --1080
	
begin
 
		conversion: process(clk, rst_n)
			 variable p_scaled    : ads_fixed;
			 variable l_scaled    : ads_fixed;
			 variable l_adjusted  : ads_fixed;
		begin
			 if rst_n = '0' then
				  c_re <= (others => '0');
				  c_im <= (others => '0');
				  valid_out <= '0';
			 elsif rising_edge(clk) then
				  if point_valid and point_visible(pixel_coord, vga_res) then
						p_scaled   := to_ads_fixed(pixel_coord.x) * re_range;
						l_adjusted := im_offset - to_ads_fixed(pixel_coord.y);
						l_scaled   := l_adjusted * im_range;
						
						c_re <= (p_scaled / x_range) + re_offset;
						c_im <= l_scaled / y_range;
						valid_out <= '1';
				  else
						c_re <= (others => '0');
						c_im <= (others => '0');
						valid_out <= '0';
				  end if;
			 end if;
		end process;
end architecture behavior;