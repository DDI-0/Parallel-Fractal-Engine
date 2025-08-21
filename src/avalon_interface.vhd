library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_interface is 
	port (
		clk				: in  std_logic;
		rst_n				: in  std_logic;
		
		avs_address 	: in  std_logic_vector(1 downto 0);
		avs_write		: in  std_logic;
		avs_read			: in  std_logic;
		avs_writedata  : in  std_logic_vector(31 downto 0);
		avs_readdata	: out std_logic_vector(31 downto 0);
		
		frame_complete : in	std_logic;
		
		start_fractal	: out std_logic;
		fractal_mode	: out std_logic;
		seed_real_out	: out std_logic;
		seed_imag_out	: out std_logic
	);
end entity avalon_interface;

architecture behavior of avalon_interface is
	
	constant ADDR_CONTROL		: std_logic_vector(1 downto 0) := "00";
	constant ADDR_SEED_REAL		: std_logic_vector(1 downto 0) := "01";
	constant ADDR_SEED_IMAG		: std_logic_vector(1 downto 0) := "10";
	constant	ADDR_STATUS			: std_logic_vector(1 downto 0) := "11";
	
	signal control_reg			: std_logic_vector(31 downto 0) := (others => '0');
	signal seed_real_reg			: std_logic_vector(31 downto 0) := (others => '0');
	signal seed_imag_reg			: std_logic_vector(31 downto 0) := (others => '0');
	signal status_reg				: std_logic_vector(31 downto 0) := (others => '0');
	
	-- drive the outputs ports from the interal registers
begin

	fractal_mode 	<= control_reg(0);
	start_fractal	<= control_reg(1);
	seed_real_out  <= seed_real_reg;
	seed_imag_out  <= seed_imag_reg;
	
	avalon_process: process(clk)
	begin
		if rst_n = '0' then 
			control_reg 	<= (others => '0');
			seed_real_reg  <= (others => '0');	
			seed_imag_reg  <= (others => '0');
			status_reg     <= (others => '0');
			avs_readdata   <= (others => '0');
			
		elsif rising_edge(clk) then
			status_reg(1)	<= frame_complete;
			
			if avs_write = '1' then
					case avs_address is
						when ADDR_CONTROL => 
							control_reg 	 <= avs_writedata;
							control_reg(1)	 <= '0';
						when ADDR_SEED_REAL =>
							seed_real_reg 	 <= avs_writedata;
						when ADDR_SEED_IMAG =>
							seed_imag_reg   <= avs_writedata;
						when others =>
							null;
					end case;
			end if;
			
		if avs_read = '1' then 
				case avs_address is 
					when ADDR_STATUS =>
						avs_readdata <= status_reg;
					when others =>
						avs_readdata <= (others => '0');
				end case;
		end if;
	 end if;
 end process;

end architecture behavior;
			
				