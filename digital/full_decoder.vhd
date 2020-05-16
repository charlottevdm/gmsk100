----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Full signal decoder
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
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
	signal drive: std_logic;
begin
	drive <= start or error;
	bit_sync0: entity work.bit_sync port map(
		clk => clk,
		input => input,
		start => drive,
		output => clk_output,
		done => done,
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

