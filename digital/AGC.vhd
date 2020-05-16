----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Logic to decide the gain level of the VGA, the gain level increases if
--				no maximal values are sensed within 'amount_cycles' and decreases if 
--				clipping is sensed
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity AGC is
	generic(	bits_cycles : integer := 5;
				bits_output : integer := 6);
	
	Port(input : 			in  	unsigned(3 downto 0);
		  clk: 				in 	std_logic; --100kHz 
		  clipped_high:	in 	std_logic;
		  clipped_low:		in 	std_logic;
		  output: 			out 	unsigned(bits_output-1 downto 0));
end AGC;

architecture Behavioral of AGC is
	signal amount_cycles : unsigned(bits_cycles-1 downto 0) := to_unsigned(20,bits_cycles);
	signal current_cycle : unsigned(bits_cycles-1 downto 0) := to_unsigned(0,bits_cycles);
	signal enhance : std_logic;
	
	signal gain_level: unsigned(bits_output-1 downto 0) := to_unsigned(0,bits_output);
	signal gain_del1: unsigned(bits_output-1 downto 0) := to_unsigned(0,bits_output);
	signal gain_del2: unsigned(bits_output-1 downto 0) := to_unsigned(0,bits_output);
	
begin
	-- sense if gain needs to be larger
	process(clk) begin
		if clk'event and clk = '1' then
			if input = to_unsigned(15,4) or input = to_unsigned(0,4) then --these are unsigned maximals values, can also be signed maximal values
				current_cycle <= to_unsigned(0,bits_cycles);					  --not tested due ot FPGA difficulities
				enhance <= '0';
			else
				if current_cycle = amount_cycles then
					current_cycle <= to_unsigned(0,bits_cycles);
					enhance <= '1';
				else
					current_cycle <= current_cycle + to_unsigned(1,bits_cycles);
					enhance <= '0';
				end if;
			end if;
		end if;
	end process;

	-- gain adjustment
	process(clk) begin
		if clk'event and clk = '1' then
			if clipped_high = '1' or clipped_low = '1' then 
				gain_level <= gain_level - to_unsigned(1,bits_output);
			elsif enhance = '1' then
				gain_level <= gain_level + to_unsigned(1,bits_output);
			end if;
		end if;
	end process;
	
	--filtering to reduce oscillations
	process(clk) begin
		if clk'event and clk = '1' then
			--delay signals
			gain_del1 <= gain_level;
			gain_del2 <= gain_del1;
			--FIR
			output <= shift_right(unsigned(gain_level),1) + shift_right(unsigned(gain_del1),2) + shift_right(unsigned(gain_del2),2);
		end if;
	end process;
end Behavioral;

