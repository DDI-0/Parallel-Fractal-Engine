libary ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_controller.all;

entity vga_fsm is
    generic (
        vga_res:    vga_timing := vga_res_default;
    );
    port (
        clk : in std_logic;
