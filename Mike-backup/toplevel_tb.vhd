----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:02 05/10/2020 
-- Design Name: 
-- Module Name:    toplevel_tb - Behavioral 
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

entity toplevel_tb is
end toplevel_tb;

architecture Behavioral of toplevel_tb is
	signal clk_ext: std_logic;
	signal test_switches: std_logic_vector(3 downto 0);
	signal test_buttons: std_logic_vector(3 downto 0);
	signal test_leds: std_logic_vector(7 downto 0);
	signal uart_rx: std_logic;
	signal uart_tx: std_logic;
	signal uart_rts_bar: std_logic;
	signal uart_cts_bar: std_logic;
	signal display_digits: std_logic_vector(3 downto 0);
	signal display_segments: std_logic_vector(6 downto 0);
	signal display_colon: std_logic;
	signal analog_comp: std_logic_vector(5 downto 0);
	signal analog_gain: std_logic_vector(5 downto 0);
begin
	toplevel0: entity work.toplevel port map(
		clk_ext => clk_ext,
		test_switches => test_switches,
		test_buttons => test_buttons,
		test_leds => test_leds,
		uart_rx => uart_rx,
		uart_tx => uart_tx,
		uart_rts_bar => uart_rts_bar,
		uart_cts_bar => uart_cts_bar,
		display_digits => display_digits,
		display_segments => display_segments,
		display_colon => display_colon,
		analog_comp => analog_comp,
		analog_gain => analog_gain
	);
	--clk generation, will get bypassed, is not the same in the real setup
	process
		constant clk_period: time := 50 ns;
	begin
		clk_ext <= '0';
		wait for clk_period/2;
		clk_ext <= '1';
		wait for clk_period/2;
	end process;
	
	--input generation
	process
		constant clk_period: time := 50 ns;
	begin
		analog_comp <= "000111";
		wait for clk_period;
		analog_comp <= "111111";
		wait for clk_period;
		analog_comp <= "000111";
		wait for clk_period;
		analog_comp <= "000000";
		wait for clk_period;
	end process;
end Behavioral;

