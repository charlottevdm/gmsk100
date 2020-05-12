library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use UNISIM.VComponents.all;


entity digitalPLL_tb is
end digitalPLL_tb;

architecture bhv of digitalPLL_tb is
	
	signal clk	  : std_logic := '0';
   signal result : unsigned(7 downto 0);
   signal reset  : std_logic := '0';
   signal input  : unsigned(3 downto 0);
	
	constant clk_period: time := 50 ns;
	
begin
	
	digitalPLL0: entity work.digitalPLL port map(
		clk => clk,
		result => result,
		reset => reset,
		input => input
	);
	
	-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	-- stimulus process
	process
	begin
		
		-- start
		wait for 30 ms;
		
		-- assume waveform b is 24° behind waveform a
      input <= "0000"; -- a = 0
      wait for 50 ms;
      input <= "0101"; -- a = 5
      wait for 50 ms;
      input <= "0100"; -- a = 4
      wait for 50 ms;
      input <= "1101"; -- a = -3
      wait for 50 ms;
      input <= "1011"; -- a = -5
      wait for 50 ms;
		input <= "0000"; -- a = 0
		
		-- end
		wait for 1000 ms;
		
	end process;
	
end;
