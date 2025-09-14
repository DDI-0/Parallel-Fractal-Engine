library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.color_data.all;
use work.util_pkg.all;

entity color_mapper is
    generic (
        MAX_ITER_VALUE : positive := 32
    );
    port (
        color_clk : in std_logic;
        rst_n : in std_logic;
        iter_count : in unsigned(num_bits(MAX_ITER_VALUE)-1 downto 0);
        palette_sel : in std_logic_vector(1 downto 0);
        rgb_out : out rgb_color
    );
end entity color_mapper;

architecture rtl of color_mapper is
    signal color_table 		 : color_table_type;
    signal color_index 		 : color_index_type;
    constant MAX_ITER_CONST : unsigned(iter_count'range) := to_unsigned(MAX_ITER_VALUE - 1, iter_count'length);

begin
    -- Select the color palette based on palette_sel
    process(palette_sel)
    begin
        case palette_sel is
            when "00" =>
                color_table <= get_palette(0); -- Ocean palette
            when "01" =>
                color_table <= get_palette(1); -- Sunset palette
            when "10" =>
                color_table <= get_palette(2); -- Purple/Blue palette
            when others =>
                color_table <= get_palette(0); -- Default to ocean palette
        end case;
    end process;

    -- Map iteration count to color and register the output
    process(color_clk)
        variable index_unsigned : unsigned(2 downto 0);
    begin
        if rising_edge(color_clk) then
            if rst_n = '0' then
                rgb_out <= color_black; -- On reset, output black
            else
                -- Determine the color index based on the iteration count
                if iter_count = MAX_ITER_CONST then
                    -- If inside the set, use index 0 (black)
                    color_index <= 0;
                else
                    -- Map iteration count to color index [1..7] for smooth color bands
                    index_unsigned := iter_count(2 downto 0);
                    if index_unsigned = "000" then
                        -- Avoid index 0 (reserved for inside the set)
                        color_index <= color_table_ocean'high;
                    else
                        color_index <= to_integer(index_unsigned);
                    end if;
                end if;
                -- Look up the RGB color from the selected palette
                rgb_out <= get_color(color_index, color_table);
            end if;
        end if;
    end process;
end architecture rtl;