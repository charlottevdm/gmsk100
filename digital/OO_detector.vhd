----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:31 04/22/2020 
-- Design Name: 
-- Module Name:    OO_detector - Behavioral 
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

entity OO_detector is
	Port(	input: 		in 	std_logic;
			clk: 			in 	std_logic;
			reset:	 	in		std_logic;
			detect: 		out 	std_logic;
			error: 		out 	std_logic);
end OO_detector;

architecture Behavioral of OO_detector is
	signal 	prev_input : 		std_logic;
	constant	max_word_length:	unsigned(3 downto 0) := to_unsigned(10,4);
	signal	cycles_since:		unsigned(3 downto 0) := to_unsigned(0,4);
	signal	detect_buffer:		std_logic;
	
begin
	--detection
	detect <= detect_buffer;
	process(clk) begin
		if clk'event and clk = '1' then
			if input = '0' and prev_input = '1' then
				detect_buffer <= '1';
			else 
				detect_buffer <= '0';
			end if;
		end if;
	end process;
	
	--error detection
	process(clk) begin
		if clk'event and clk = '1' then
			if cycles_since > max_word_length then
				cycles_since <= to_unsigned(0,4);
				error <= '1';
			else
				error <= '0';
				if detect_buffer = '1' or reset = '1' then
					cycles_since <= to_unsigned(0,4);
				else
					cycles_since <= cycles_since + to_unsigned(1,4);
				end if;
			end if;
		end if;
	end process;
	
	--delay input
	process(clk) begin
		if clk'event and clk = '1' then
		prev_input <= input;
		end if;
	end process;

end Behavioral;

