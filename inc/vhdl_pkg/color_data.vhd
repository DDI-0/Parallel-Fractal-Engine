package color_data is

    subtype color_channel_type is natural range 0 to 15;

    type rgb_color is record
        red   : color_channel_type;
        green : color_channel_type;
        blue  : color_channel_type;
    end record rgb_color;

    constant color_black : rgb_color := ( red => 0,  green => 0,  blue => 0 );
    constant color_red   : rgb_color := ( red => 15, green => 0,  blue => 0 );
    constant color_green : rgb_color := ( red => 0,  green => 15, blue => 0 );
    constant color_blue  : rgb_color := ( red => 0,  green => 0, blue => 15 );

    type color_table_type is array(0 to 7) of rgb_color;

    -- Ocean palette
    constant color_table_ocean : color_table_type := (
        0 => ( red => 0,  green => 0,  blue => 0 ),    -- inside (black)
        1 => ( red => 0,  green => 0,  blue => 8 ),
        2 => ( red => 0,  green => 4,  blue => 12 ),
        3 => ( red => 0,  green => 8,  blue => 15 ),
        4 => ( red => 4,  green => 12, blue => 15 ),
        5 => ( red => 8,  green => 15, blue => 15 ),
        6 => ( red => 12, green => 15, blue => 12 ),
        7 => ( red => 15, green => 15, blue => 8 )
    );

    -- Sunset palette
    constant color_table_sunset : color_table_type := (
        0 => ( red => 0,  green => 0,  blue => 0 ),
        1 => ( red => 4,  green => 0,  blue => 0 ),
        2 => ( red => 8,  green => 2,  blue => 0 ),
        3 => ( red => 12, green => 6,  blue => 0 ),
        4 => ( red => 15, green => 10, blue => 0 ),
        5 => ( red => 15, green => 15, blue => 4 ),
        6 => ( red => 15, green => 15, blue => 8 ),
        7 => ( red => 15, green => 15, blue => 15 )
    );

    -- Mysterious palette
    constant color_table_mysterious : color_table_type := (
        0 => ( red => 0,  green => 0,  blue => 0 ),    
        1 => ( red => 2,  green => 0,  blue => 4 ),    
        2 => ( red => 4,  green => 0,  blue => 8 ),    
        3 => ( red => 6,  green => 0,  blue => 12 ),   
        4 => ( red => 4,  green => 4,  blue => 15 ),   
        5 => ( red => 0,  green => 6,  blue => 12 ),   
        6 => ( red => 0,  green => 10, blue => 8 ),    
        7 => ( red => 4,  green => 15, blue => 12 )    
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
