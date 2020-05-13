----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:24:46 04/29/2020 
-- Design Name: 
-- Module Name:    full_decoder - Behavioral 
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

entity full_decoder is
	Port(input : 			in  	std_logic;
		  clk: 				in 	std_logic;
		  start: 			in 	std_logic;
		  output: 			out 	unsigned(6 downto 0));
end full_decoder;

architecture Behavioral of full_decoder is
signal clk_output : std_logic;
signal detect : std_logic;
signal freq_switched : std_logic;
signal error : std_logic;
signal done : std_logic;
begin

	bit_sync0: entity work.bit_sync port map(
		clk => clk,
		input => input,
		start => start,
		output => clk_output,
		done => done, -- needed?
		freq_switched => freq_switched
	);
	
	OO_detector0: entity work.OO_detector port map(
		clk => clk_output,
		input => input,
		detect => detect,
		reset => freq_switched,
		error => error
	);
	
	varicode_decoder0: entity work.varicode_decoder port map(
		clk => clk_output,
		input => input,
		detected => detect,
		output => output
	);


end Behavioral;

