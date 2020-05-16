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
		input : in  signed(bits_input - 1 downto 0); -- @ 100 kHz 127 to -128
		clk : in  STD_LOGIC;
		output : out  unsigned(bits_input - 1 downto 0));
end DPLL_filter;

architecture Behavioral of DPLL_filter is
	signal 	input_del1 : signed(bits_input - 1 downto 0) := to_signed(0,bits_input);
	signal 	input_del2 : signed(bits_input - 1 downto 0) := to_signed(0,bits_input);
	signal 	input_filtered : signed(bits_input - 1 downto 0):= to_signed(0,bits_input);
	signal 	input_filtered_extended : signed(bits_input downto 0):= to_signed(0,bits_input+1);
	constant loop_amount : integer := 10000/50;
	signal 	loop_counter : integer := 0;
	signal 	clk_100: std_logic;
	signal 	integrated_input : signed(bits_input downto 0) := to_signed(205,bits_input+1); -- has to be one more than integrated_input_through
	signal 	integrated_input_through : signed(bits_input downto 0) := to_signed(205,bits_input+1); -- has to include 255, so is 1 big extra in signed
	signal 	integrated_input_through_less : signed(bits_input - 1 downto 0);
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
	
	process(clk)
	begin
		if clk'event and clk = '1' then
			if clk_100 = '1' then
				integrated_input <= input_filtered_extended + integrated_input_through;
				if integrated_input_through(bits_input) = '1' then -- if result is negative, cant be so stay the same 
					integrated_input_through <= integrated_input_through;
				else
					integrated_input_through <= integrated_input;
				end if;
			end if;
		end if;
	end process;
	input_filtered_extended <= input_filtered(bits_input - 1) & input_filtered;
	integrated_input_through_less <= integrated_input_through(bits_input - 1 downto 0);
	output <= unsigned(integrated_input_through_less);

end Behavioral;

