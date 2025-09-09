library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_controller.all;

entity vga_fsm is
    generic (
        vga_res: vga_timing := vga_res_640x480
    );
    port (
        vga_clk      : in std_logic;   
        rst_n        : in std_logic;
        h_sync       : out std_logic;
        v_sync       : out std_logic;
        point_valid  : out boolean; 
        pixel_coord  : out coordinate;
        VGA_BLANK_N  : out std_logic;
        VGA_SYNC_N   : out std_logic
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

    h_sync <= horizontal_sync(current_point, vga_res);
    v_sync <= vertical_sync(current_point, vga_res);

    point_valid <= point_visible(current_point, vga_res);

    pixel_coord <= current_point;

    VGA_BLANK_N <= '1' when point_visible(current_point, vga_res) else '0';
    VGA_SYNC_N <= '1';
end architecture behavioral;