----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:06:13 05/06/2020 
-- Design Name: 
-- Module Name:    input_filter - Behavioral 
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

entity input_filter_board is
	port(	clk: in std_logic;
			input: in unsigned(5 downto 0);
			output: out unsigned(3 downto 0);
			clk_100k : out std_logic);
end input_filter_board;

architecture Behavioral of input_filter_board is
	signal input_bits: unsigned(2 downto 0);
	signal MA: unsigned(10 downto 0) := to_unsigned(0,11);
	signal MA_inter_rounded: unsigned(16 downto 0);
	constant multiply: unsigned(5 downto 0) := to_unsigned(51,6);
	signal MA_rounded: unsigned(5 downto 0);
	signal MA_rounded_LSB: unsigned(4 downto 0); -- do 1 bit extra for the rounding
	signal MA_rounded_LSB_prev: unsigned(4 downto 0);
	signal number_cycles: unsigned(7 downto 0) := to_unsigned(0,8);
	signal output_buffer: unsigned(3 downto 0);
	signal clk_switch: std_logic := '0';
	signal clk_buffer: std_logic := '0';
begin
	-- switch thermometer code to binary 
	process(clk) 
	begin
		if clk'event and clk = '1' then 
			case input is
				when "000000" => input_bits <= "000";
				when "000001" => input_bits <= "001";
				when "000011" => input_bits <= "010";
				when "000111" => input_bits <= "011";
				when "001111" => input_bits <= "100";
				when "011111" => input_bits <= "101";
				when "111111" => input_bits <= "110";
				when others => input_bits <= "000";
			end case;
		end if;
	end process;
	
	--moving average filter
	MA_rounded_LSB <= MA_rounded(4 downto 0); 
	process(clk) 
		constant max_cycles: unsigned(7 downto 0) := to_unsigned(200,8);
	begin
		if clk'event and clk = '1' then 
			if number_cycles = max_cycles then
				clk_switch <= '1';
				number_cycles <= to_unsigned(0,8);
				MA <= to_unsigned(0,11);
				MA_inter_rounded <= MA * multiply;
				MA_rounded <= MA_inter_rounded(16 downto 11); -- rescale a number between 0 and 1200 to 0 and 15 , so dev by 80, this is made by *51/4096
			else                                             -- but this here an extra lsb is taken for rounding
				clk_switch <= '0';
				number_cycles <= number_cycles + 1;
				MA <= MA + ("00000000" & input_bits);
			end if;
		end if;
	end process;

	--rounding of the output
	output <= output_buffer;
	process(clk)
	begin
		if clk'event and clk = '1' then 
			if MA_rounded_LSB_prev /= MA_rounded_LSB then
				if MA_rounded_LSB(0) = '0' then
					output_buffer <= MA_rounded_LSB(4 downto 1);
				else
					output_buffer <= MA_rounded_LSB(4 downto 1) + 1;
				end if;
			end if;
		end if;
	end process;
	
	--clk out
	clk_100k <= clk_buffer;
	process(clk)
	begin 
		if clk'event and clk = '1' then 
			if clk_switch = '1' then 
				clk_buffer <= not clk_buffer;
			end if;
		end if;
	end process;
	
	--delay 
	process(clk)
	begin
		if clk'event and clk = '1' then 
			MA_rounded_LSB_prev <= MA_rounded_LSB;
		end if;
	end process;
	
end Behavioral;

