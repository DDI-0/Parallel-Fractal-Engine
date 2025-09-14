library ieee;
use ieee.std_logic_1164.all;

entity vga_delay_shift is
    generic (
        DELAY : positive := 32  
    );
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        -- Input VGA signals
        in_h_sync : in std_logic;
        in_v_sync : in std_logic;
        in_blank_n : in std_logic;
        in_sync_n : in std_logic;
        in_point_valid : in boolean;  
        -- Output delayed VGA signals
        out_h_sync : out std_logic;
        out_v_sync : out std_logic;
        out_blank_n : out std_logic;
        out_sync_n : out std_logic;
        out_point_valid : out boolean  
    );
end entity vga_delay_shift;

architecture rtl of vga_delay_shift is
    -- Shift register type for std_logic signals
    type shift_reg_std_logic is array (0 to DELAY - 1) of std_logic;
    -- Shift register type for boolean signal
    type shift_reg_boolean is array (0 to DELAY - 1) of boolean;
    -- Shift registers for each input signal
    signal shift_hs : shift_reg_std_logic;
    signal shift_vs : shift_reg_std_logic;
    signal shift_blank : shift_reg_std_logic;
    signal shift_sync : shift_reg_std_logic;
    signal shift_valid : shift_reg_boolean;  
begin
    -- Process to shift the signals on each clock cycle
    process (clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                shift_hs <= (others => '0');
                shift_vs <= (others => '0');
                shift_blank <= (others => '1');
                shift_sync <= (others => '1');
                shift_valid <= (others => true);  
            else
                -- Shift and insert new input for h_sync
                shift_hs(0) <= in_h_sync;
                for i in 1 to DELAY - 1 loop
                    shift_hs(i) <= shift_hs(i - 1);
                end loop;
                
                -- Shift and insert new input for v_sync
                shift_vs(0) <= in_v_sync;
                for i in 1 to DELAY - 1 loop
                    shift_vs(i) <= shift_vs(i - 1);
                end loop;
                
                -- Shift and insert new input for blank_n
                shift_blank(0) <= in_blank_n;
                for i in 1 to DELAY - 1 loop
                    shift_blank(i) <= shift_blank(i - 1);
                end loop;
                
                -- Shift and insert new input for sync_n
                shift_sync(0) <= in_sync_n;
                for i in 1 to DELAY - 1 loop
                    shift_sync(i) <= shift_sync(i - 1);
                end loop;
                
                -- Shift and insert new input for point_valid
                shift_valid(0) <= in_point_valid;
                for i in 1 to DELAY - 1 loop
                    shift_valid(i) <= shift_valid(i - 1);
                end loop;
            end if;
        end if;
    end process;

    -- Assign outputs from the end of the shift registers
    out_h_sync <= shift_hs(DELAY - 1);
    out_v_sync <= shift_vs(DELAY - 1);
    out_blank_n <= shift_blank(DELAY - 1);
    out_sync_n <= shift_sync(DELAY - 1);
    out_point_valid <= shift_valid(DELAY - 1);
end architecture rtl;