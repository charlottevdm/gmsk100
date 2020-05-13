----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:17 05/04/2020 
-- Design Name: 
-- Module Name:    AGC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AGC is
	generic(	bits_cycles : integer := 5;
				bits_output : integer := 6);
	
	Port(input : 			in  	unsigned(3 downto 0);
		  clk: 				in 	std_logic;
		  clipped_high:	in 	std_logic;
		  clipped_low:		in 	std_logic;
		  output: 			out 	unsigned(bits_output-1 downto 0));
end AGC;

architecture Behavioral of AGC is
	signal amount_cycles : unsigned(bits_cycles-1 downto 0) := to_unsigned(20,bits_cycles);
	signal current_cycle : unsigned(bits_cycles-1 downto 0) := to_unsigned(0,bits_cycles);
	signal enhance : std_logic;
	signal gain_level : unsigned(bits_output-1 downto 0) := to_unsigned(0,bits_output);
	
begin
	-- sense if gain needs to be larger
	process(clk) begin
		if clk'event and clk = '1' then
			if input = to_unsigned(15,4) or input = to_unsigned(0,4) then
				current_cycle <= to_unsigned(0,bits_cycles);
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
	output <= gain_level;
	process(clk) begin
		if clk'event and clk = '1' then
			if clipped_high = '1' or clipped_low = '1' then 
				gain_level <= gain_level - to_unsigned(1,bits_output);
			elsif enhance = '1' then
				gain_level <= gain_level + to_unsigned(1,bits_output);
			end if;
		end if;
	end process;
	
end Behavioral;

