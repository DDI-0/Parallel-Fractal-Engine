library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_controller.all;

entity vga_fsm is
    generic (
        vga_res:    vga_timing := vga_res_default
    );
    port (
        vga_clk             : in  std_logic;
        rst_n               : in  std_logic;
        point               : out coordinate;
        point_valid         : out boolean;
        h_sync              : out std_logic;
        v_sync              : out std_logic
    );
end entity vga_fsm;

architecture fsm of vga_fsm is 
    
    signal current_point : coordinate := make_coordinate(0,0);

begin
    
    timing : process(vga_clk, rst_n)
    begin
        if rst_n = '0' then 
            current_point <= make_coordinate(0,0);
            point_valid   <= false;
            h_sync        <= '0';
            v_sync        <= '0';
        elsif rising_edge(vga_clk) then
            current_point <= next_coordinate(current_point, vga_res);
            point         <= current_point;
            point_valid   <= point_visible(current_point, vga_res);
            h_sync        <= horizontal_sync(current_point, vga_res);
            v_sync        <= vertical_sync(current_point, vga_res);
        end if;
    end process;
end architecture fsm;


