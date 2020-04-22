----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:03 04/22/2020 
-- Design Name: 
-- Module Name:    bit_sync_tb - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit_sync_tb is
end bit_sync_tb;

architecture Behavioral of work.bit_sync_tb is
	signal clk : std_logic := '0';
	signal input: std_logic := '0';
	signal clk_output: std_logic := '0';
	signal start: std_logic := '0';
	signal done: std_logic;
	signal detect: std_logic;
	signal error: std_logic;
	signal freq_switched: std_logic;
	constant clk_period: time := 50 ns;
begin
	bit_sync0: entity work.bit_sync port map(
		clk => clk,
		input => input,
		start => start,
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
	
		-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
		-- input generation
	process
	begin
	
		-- start
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		input <= '0';
		wait for 10 ms;
		input <= '1';
		wait for 10 ms;
		
		
		
	end process;

	--start/done signal
	process
	begin
		start <= '1';
		wait until done = '1';
		start <= '0';
		wait for 30 ms;
	end process;
end Behavioral;

