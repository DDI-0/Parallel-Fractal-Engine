library ieee;
use ieee.std_logic_1164.all;

package vga_controller is 
    type timing_data is record
        active_pixel:   natural;
        front_porch:    natural;
        sync_width:     natural;
        back_porch:     natural;
    end record timing_data;

    type polarity is ( active_low, active_high);

    type vga_timing is record
        horizontal:     timing_data;
        vertical:       timing_data;
        sync_polarity:  polarity;
    end record vga_timing;

    type coordinate is record
        x:  natural;
        y:  natural;
    end record coordinate;

    type vga_data_rom_type is array (natural range<>) of vga_timing;

    constant vga_res_data: vga_data_rom_type := (
      (
        -- 1920x1080 @ 60 Hz
        -- Pixel clock @ 148.5 MHz
        horizontal => (
            back_porch    => 148,
            active_pixel  => 1920,
            front_porch   => 88,
            sync_width    => 44
        ),
        vertical   => (
            back_porch    => 36,
            active_pixel  => 1080,
            front_porch   => 4,
            sync_width    => 5
        ),
        sync_polarity     => active_high
    ),
    (
        -- 640x480 @ 60 Hz
        -- Pixel clock @ 25.175 MHz
        horizontal => (
            back_porch    => 48,
             active_pixel => 640,
            front_porch   => 16,
            sync_width    => 96
        ),
        vertical   => (
            back_porch    => 33, 
            active_pixel  => 480,
            front_porch   => 19,
            sync_width    => 2
        ),
        sync_polarity     => active_low
      )
    );


