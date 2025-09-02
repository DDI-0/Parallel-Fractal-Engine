library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_controller.all;

entity vga_fsm is
    generic (
        vga_res: vga_timing := vga_res_640x480
    );
    port (
        vga_clk    : in std_logic;   
        rst_n      : in std_logic;
        h_sync     : out std_logic;
        v_sync      : out std_logic;
        point_valid : out boolean; 
        pixel_coord  : out coordinate
    );
end entity vga_fsm;

architecture behavioral of vga_fsm is
    signal current_point: coordinate;
begin
    process (vga_clk)
    begin
        if rising_edge(vga_clk) then
            if rst_n = '0' then
                current_point <= make_coordinate(0, 0);
            else
                current_point <= next_coordinate(current_point, vga_res);
            end if;
        end if;
    end process;

    -- Drive sync signals
    h_sync <= horizontal_sync(current_point, vga_res);
    v_sync <= vertical_sync(current_point, vga_res);

    -- Boolean instead of std_logic
    point_valid <= point_visible(current_point, vga_res);

    -- Pixel coordinate output
    pixel_coord <= current_point;
end architecture behavioral;
