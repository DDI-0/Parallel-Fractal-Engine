library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.color_data.all;

entity color_mapper is
    port (
        clk            	: in  std_logic;
        rst_n          	: in  std_logic;              
        iteration_count	: in  natural;                -- iteration result from fractal core
        max_iteration  	: in  natural;                
        palette       	: in  palette_index_type;     -- which palette to use
        pixel_color    	: out rgb_color
    );
end entity color_mapper;

architecture rtl of color_mapper is

    constant color_count 	: natural := color_table_ocean'length; -- range of color(0-7)
    signal pixel_color_reg : rgb_color;  -- store the computed pixel color 
	 
begin

    process(clk)
        variable index : natural; 
        variable local_palette : color_table_type;
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                pixel_color_reg <= color_black;
            else
                local_palette := get_palette(palette);

                if iteration_count >= max_iteration then
                    pixel_color_reg <= color_black;
                else
                    index := (iteration_count mod (color_count - 1)) + 1;  -- map iteration count to a color index within the palette
                    pixel_color_reg <= get_color(index, local_palette);
                end if;
            end if;
        end if;
    end process;

    pixel_color <= pixel_color_reg;

end architecture rtl;
