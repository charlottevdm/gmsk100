----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:59 04/29/2020 
-- Design Name: 
-- Module Name:    varicode_decoder - Behavioral 
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

entity varicode_decoder is
	Port(input : 			in  	std_logic;
		  clk: 				in 	std_logic;
		  detected: 		in 	std_logic;
		  output: 			out 	unsigned(6 downto 0));
end varicode_decoder;

architecture Behavioral of varicode_decoder is
signal reg_var : unsigned(11 downto 0) := to_unsigned(0,12);
signal counter_reg : unsigned(3 downto 0) := to_unsigned(0,4);
signal ascii_val: unsigned(6 downto 0);

begin
	
	--reading register, serial to parallel conversion
	process(clk) begin
		if clk'event and clk = '1' then
			if detected = '1' then
				reg_var <= to_unsigned(0,11) & input;
			else
				reg_var <= reg_var( 10 downto 0) & input;
			end if;
		end if;
	end process;
	
	--LUT
	output <= ascii_val;
	process(clk) begin
		if clk'event and clk = '1' then
			if detected = '1'then
				case reg_var is
					when "000000000100" => ascii_val <="0100000";
					when "011111111100" => ascii_val <="0100001";
					when "010101111100" => ascii_val <="0100010";
					when "011111010100" => ascii_val <="0100011";
					when "011101101100" => ascii_val <="0100100";
					when "101101010100" => ascii_val <="0100101";
					when "101011101100" => ascii_val <="0100110";
					when "010111111100" => ascii_val <="0100111";
					when "001111101100" => ascii_val <="0101000";
					when "001111011100" => ascii_val <="0101001";
					when "010110111100" => ascii_val <="0101010";
					when "011101111100" => ascii_val <="0101011";
					when "000111010100" => ascii_val <="0101100";
					when "000011010100" => ascii_val <="0101101";
					when "000101011100" => ascii_val <="0101110";
					when "011010111100" => ascii_val <="0101111";
					when "001011011100" => ascii_val <="0110000";
					when "001011110100" => ascii_val <="0110001";
					when "001110110100" => ascii_val <="0110010";
					when "001111111100" => ascii_val <="0110011";
					when "010111011100" => ascii_val <="0110100";
					when "010101101100" => ascii_val <="0110101";
					when "010110101100" => ascii_val <="0110110";
					when "011010110100" => ascii_val <="0110111";
					when "011010101100" => ascii_val <="0111000";
					when "011011011100" => ascii_val <="0111001";
					when "001111010100" => ascii_val <="0111010";
					when "011011110100" => ascii_val <="0111011";
					when "011110110100" => ascii_val <="0111100";
					when "000101010100" => ascii_val <="0111101";
					when "011101011100" => ascii_val <="0111110";
					when "101010111100" => ascii_val <="0111111";
					when "101011110100" => ascii_val <="1000000";
					when "000111110100" => ascii_val <="1000001";
					when "001110101100" => ascii_val <="1000010";
					when "001010110100" => ascii_val <="1000011";
					when "001011010100" => ascii_val <="1000100";
					when "000111011100" => ascii_val <="1000101";
					when "001101101100" => ascii_val <="1000110";
					when "001111110100" => ascii_val <="1000111";
					when "010101010100" => ascii_val <="1001000";
					when "000111111100" => ascii_val <="1001001";
					when "011111110100" => ascii_val <="1001010";
					when "010111110100" => ascii_val <="1001011";
					when "001101011100" => ascii_val <="1001100";
					when "001011101100" => ascii_val <="1001101";
					when "001101110100" => ascii_val <="1001110";
					when "001010101100" => ascii_val <="1001111";
					when "001101010100" => ascii_val <="1010000";
					when "011101110100" => ascii_val <="1010001";
					when "001010111100" => ascii_val <="1010010";
					when "000110111100" => ascii_val <="1010011";
					when "000110110100" => ascii_val <="1010100";
					when "010101011100" => ascii_val <="1010101";
					when "011011010100" => ascii_val <="1010110";
					when "010101110100" => ascii_val <="1010111";
					when "010111010100" => ascii_val <="1011000";
					when "010111101100" => ascii_val <="1011001";
					when "101010110100" => ascii_val <="1011010";
					when "011111011100" => ascii_val <="1011011";
					when "011110111100" => ascii_val <="1011100";
					when "011111101100" => ascii_val <="1011101";
					when "101011111100" => ascii_val <="1011110";
					when "010110110100" => ascii_val <="1011111";
					when "101101111100" => ascii_val <="1100000";
					when "000000101100" => ascii_val <="1100001";
					when "000101111100" => ascii_val <="1100010";
					when "000010111100" => ascii_val <="1100011";
					when "000010110100" => ascii_val <="1100100";
					when "000000001100" => ascii_val <="1100101";
					when "000011110100" => ascii_val <="1100110";
					when "000101101100" => ascii_val <="1100111";
					when "000010101100" => ascii_val <="1101000";
					when "000000110100" => ascii_val <="1101001";
					when "011110101100" => ascii_val <="1101010";
					when "001011111100" => ascii_val <="1101011";
					when "000001101100" => ascii_val <="1101100";
					when "000011101100" => ascii_val <="1101101";
					when "000000111100" => ascii_val <="1101110";
					when "000000011100" => ascii_val <="1101111";
					when "000011111100" => ascii_val <="1110000";
					when "011011111100" => ascii_val <="1110001";
					when "000001010100" => ascii_val <="1110010";
					when "000001011100" => ascii_val <="1110011";
					when "000000010100" => ascii_val <="1110100";
					when "000011011100" => ascii_val <="1110101";
					when "000111101100" => ascii_val <="1110110";
					when "000110101100" => ascii_val <="1110111";
					when "001101111100" => ascii_val <="1111000";
					when "000101110100" => ascii_val <="1111001";
					when "011101010100" => ascii_val <="1111010";
					when "101011011100" => ascii_val <="1111011";
					when "011011101100" => ascii_val <="1111100";
					when "101011010100" => ascii_val <="1111101";
					when "101101011100" => ascii_val <="1111110";
					when "101010101100" => ascii_val <="0000000";
					when "101101101100" => ascii_val <="0000001";
					when "101110110100" => ascii_val <="0000010";
					when "110111011100" => ascii_val <="0000011";
					when "101110101100" => ascii_val <="0000100";
					when "110101111100" => ascii_val <="0000101";
					when "101110111100" => ascii_val <="0000110";
					when "101111110100" => ascii_val <="0000111";
					when "101111111100" => ascii_val <="0001000";
					when "001110111100" => ascii_val <="0001001";
					when "000001110100" => ascii_val <="0001010";
					when "110110111100" => ascii_val <="0001011";
					when "101101110100" => ascii_val <="0001100";
					when "000001111100" => ascii_val <="0001101";
					when "110111010100" => ascii_val <="0001110";
					when "111010101100" => ascii_val <="0001111";
					when "101111011100" => ascii_val <="0010000";
					when "101111010100" => ascii_val <="0010001";
					when "111010110100" => ascii_val <="0010010";
					when "111010111100" => ascii_val <="0010011";
					when "110101101100" => ascii_val <="0010100";
					when "110110101100" => ascii_val <="0010101";
					when "110110110100" => ascii_val <="0010110";
					when "110101011100" => ascii_val <="0010111";
					when "110111101100" => ascii_val <="0011000";
					when "110111110100" => ascii_val <="0011001";
					when "111011011100" => ascii_val <="0011010";
					when "110101010100" => ascii_val <="0011011";
					when "110101110100" => ascii_val <="0011100";
					when "111011101100" => ascii_val <="0011101";
					when "101111101100" => ascii_val <="0011110";
					when "110111111100" => ascii_val <="0011111";
					when "111011010100" => ascii_val <="1111111";
					when others => ascii_val <= "0000000";
				end case;
			end if;
		end if;
	end process;
end Behavioral;

