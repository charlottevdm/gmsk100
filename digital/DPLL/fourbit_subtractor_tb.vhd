library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fourbit_subtractor_tb is
end fourbit_subtractor_tb;

architecture bhv of fourbit_subtractor_tb is
	
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	signal X: unsigned(3 downto 0);
	signal Y: unsigned(3 downto 0);
	signal result: unsigned(3 downto 0);
	signal sub: std_logic := '1';
	
	constant clk_period: time := 50 ns;
	
begin
	
	fourbit_subtractor0: entity work.fourbit_subtractor port map(
		clk => clk,
		reset => reset,
		X => X,
		Y => Y,
		result => result,
		sub => sub
	);
	
	-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	-- normal process
	process
	begin
		
		-- start
		wait for 30 ms;
		
		-- assume waveform b is 24° behind waveform a
      X <= "0000"; -- a = 0
		Y <= "1101"; -- b = -3
      wait for 10 ms;
      X <= "0101"; -- a = 5
		Y <= "0100"; -- b = 4
      wait for 10 ms;
      X <= "0100"; -- a = 4
		Y <= "0101"; -- b = 5
      wait for 10 ms;
      X <= "1101"; -- a = -3
		Y <= "1111"; -- b = -1
      wait for 10 ms;
      X <= "1011"; -- a = -5
		Y <= "1011"; -- b = -5
      wait for 10 ms;
		X <= "0000"; -- a = 0
		Y <= "1101"; -- b = -3
      wait for 1000 ms;
		
	end process;
	
end;