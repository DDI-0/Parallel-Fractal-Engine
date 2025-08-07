library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

entity computational_unit is
    generic (
        ITER_WIDTH : positive := 0;
        THRESHOLD  : ads_fixed := to_ads_sfixed(4)
    );
    port (
        clk        : in std_logic;
        rst_n      : in std_logic;
        start      : in std_logic;
        c_re       : in ads_complex;
        c_im       : in ads_complex;
        z_im       : in ads_complex;
        z_re       : in ads_complex;
        max_iter   : in unsigned(ITER_WIDTH-1 downto 0);

        done       : out std_logic;
        iter_count : out unsigned(ITER_WIDTH-1 downto 0)
    );
end entity computational_unit;

architecture rtl of computational_unit
    
    type state_t is (IDLE, RUN);
    signal state  : state_t := IDLE;

    signal c      : ads_complex;
    signal z      : ads_complex;
    signal z_next : ads_complex;
    signal iter   : unsigned(ITER_WIDTH-1 downto 0) := (others => '0');
    signal done_i : std_loigc := 0;
begin 

    z_next      <= (z * z ) + c;
    done        <= done_i;
    iter_count  <= iter;

    process(clk)
    begin 
        if rising_edge(clk) then
            if rst_n = '0' then 
            c       <= complex_zero;
            z       <= complex_zero;
            state   <= IDLE;
            iter    <= (others => '0');
            done_i  <= '0';
        else 
            done_i <= '0';

            case state is
                when IDLE =>
                    if start = '1' then 
                        c.re  <= c_re;
                        c.im  <= c_im;
                        z.re  <= z_re;
                        z.im  <= z_im;
                        iter  <= (others => '0');
                        state <= RUN;
                    end if;
                when RUN =>
                    if (abs2(z) > THRESHOLD) or (iter = max_iter) then
                        done_i <= '1';
                        state  <= IDLE;
                    else 
                        z      <= z_next;
                        iter   <= iter + 1;
                    end if;
            end case;
        end if;
    end if;
end process;

end architecture rtl;
        
        
