----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:35 04/01/2020 
-- Design Name: 
-- Module Name:    DPLL_filter - Behavioral 
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


entity DPLL_filter is
	generic(
		bits_input: integer := 8); 
	Port( 
		input : in  signed(bits_input - 1 downto 0); -- @ 100 kHz
		clk : in  STD_LOGIC;
		output : out  unsigned(bits_input - 1 downto 0));
end DPLL_filter;

architecture Behavioral of DPLL_filter is
	signal 	input_del1 : signed(bits_input - 1 downto 0);
	signal 	input_del2 : signed(bits_input - 1 downto 0);
	signal 	input_filtered : signed(bits_input - 1 downto 0);
	signal 	input_filtered_extended : unsigned(bits_input downto 0);
	constant loop_amount : integer := 10000/50;
	signal 	loop_counter : integer := 0;
	signal 	clk_100: std_logic;
	signal 	integrated_input : unsigned(bits_input downto 0) := to_unsigned(205,bits_input+1);
	signal 	integrated_input_through : unsigned(bits_input downto 0) := to_unsigned(205,bits_input+1);
	
begin
	--enable signal at 100 kHz
	process(clk)
	begin
		if clk'event and clk = '1' then
			if loop_counter = loop_amount then
				clk_100 <= '1';
				loop_counter <= 0;
			else
				loop_counter <= loop_counter + 1;
				clk_100 <= '0';
			end if;
		end if;
	end process;
	--delaying the inputs
	process(clk)
	begin
		if clk'event and clk = '1' then
			if clk_100 = '1' then
				input_del1 <= input;
				input_del2 <= input_del1;
			else
				input_del1 <= input_del1;
				input_del2 <= input_del2;
			end if;
		end if;
	end process;
	
	-- filtering
	process(clk)
	begin
		if clk'event and clk = '1' then
			if clk_100 = '1' then
				input_filtered <= shift_right(signed(input),2) + shift_right(signed(input),3) + shift_right(signed(input_del1),2) + shift_right(signed(input_del1),3) + shift_right(signed(input_del2),2);
			else
				input_filtered <= input_filtered;
			end if;
		end if;
	end process;
	
	--integration
	input_filtered_extended <= '0' & unsigned(input_filtered);
	output <= integrated_input_through(bits_input - 1 downto 0);
	process(clk)
	begin
		if clk'event and clk = '1' then
			if clk_100 = '1' then
				integrated_input <= input_filtered_extended + integrated_input_through;
				if integrated_input(bits_input) = '1' then
					integrated_input_through <= integrated_input;
				else
					integrated_input_through <= integrated_input_through;
				end if;
			else
				integrated_input <= integrated_input;
				integrated_input_through <= integrated_input_through;
			end if;
		end if;
	end process;
end Behavioral;

