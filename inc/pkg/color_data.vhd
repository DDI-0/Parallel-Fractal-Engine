-- Final version


package color_data is

    subtype color_channel_type is natural range 0 to 255;

    type rgb_color is record
        red   : color_channel_type;
        green : color_channel_type;
        blue  : color_channel_type;
    end record rgb_color;

    -- Basic colors updated to the 8-bit range
    constant color_black : rgb_color := ( red => 0,   green => 0,   blue => 0 );
    constant color_red   : rgb_color := ( red => 255, green => 0,   blue => 0 );
    constant color_green : rgb_color := ( red => 0,   green => 255, blue => 0 );
    constant color_blue  : rgb_color := ( red => 0,   green => 0,   blue => 255 );

    type color_table_type is array(0 to 7) of rgb_color;

    -- Ocean palette, scaled to the 0-255 range
    constant color_table_ocean : color_table_type := (
        0 => ( red => 0,   green => 0,   blue => 0 ),    -- black
        1 => ( red => 0,   green => 0,   blue => 136 ),
        2 => ( red => 0,   green => 68,  blue => 204 ),
        3 => ( red => 0,   green => 136, blue => 255 ),
        4 => ( red => 68,  green => 204, blue => 255 ),
        5 => ( red => 136, green => 255, blue => 255 ),
        6 => ( red => 204, green => 255, blue => 204 ),
        7 => ( red => 255, green => 255, blue => 136 )
    );

    -- Sunset palette, scaled to the 0-255 range
    constant color_table_sunset : color_table_type := (
        0 => ( red => 0,   green => 0,   blue => 0 ),
        1 => ( red => 68,  green => 0,   blue => 0 ),
        2 => ( red => 136, green => 34,  blue => 0 ),
        3 => ( red => 204, green => 102, blue => 0 ),
        4 => ( red => 255, green => 170, blue => 0 ),
        5 => ( red => 255, green => 255, blue => 68 ),
        6 => ( red => 255, green => 255, blue => 136 ),
        7 => ( red => 255, green => 255, blue => 255 )   -- white
    );

    -- Mysterious palette, scaled to the 0-255 range
    constant color_table_mysterious : color_table_type := (
        0 => ( red => 0,   green => 0,   blue => 0 ),
        1 => ( red => 34,  green => 0,   blue => 68 ),
        2 => ( red => 68,  green => 0,   blue => 136 ),
        3 => ( red => 102, green => 0,   blue => 204 ),
        4 => ( red => 68,  green => 68,  blue => 255 ),
        5 => ( red => 0,   green => 102, blue => 204 ),
        6 => ( red => 0,   green => 170, blue => 136 ),
        7 => ( red => 68,  green => 255, blue => 204 )
    );

    -- Palette table: collection of color tables
    type color_palette_type is array(natural range <>) of color_table_type;

    constant color_palette_table : color_palette_type := (
        0 => color_table_ocean,
        1 => color_table_sunset,
        2 => color_table_mysterious
    );

    subtype palette_index_type is natural range color_palette_table'range;
    subtype color_index_type   is natural range color_table_ocean'range;

    function get_color (
        color_index   : in color_index_type;
        color_palette : in color_table_type
    ) return rgb_color;

    function get_palette (
        palette_index : in palette_index_type
    ) return color_table_type;

end package color_data;


package body color_data is

    -- No changes are needed in the package body, as the functions
    -- automatically adapt to the updated types defined in the header.

    function get_color (
        color_index   : in color_index_type;
        color_palette : in color_table_type
    ) return rgb_color is
    begin
        return color_palette(color_index);
    end function get_color;

     function get_palette (
        palette_index : in palette_index_type
    ) return color_table_type is
    begin
        return color_palette_table(palette_index);
    end function get_palette;

end package body color_data;