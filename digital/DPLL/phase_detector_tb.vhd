library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VComponents.all;

entity phase_detector_tb is
end phase_detector_tb;

architecture bhv of phase_detector_tb is
	
	signal clk: std_logic := '0';
	signal phase_difference: unsigned(7 downto 0);
	signal reset: std_logic := '0';
	signal waveform_a: unsigned(3 downto 0);
	signal waveform_b: unsigned(3 downto 0);
	
	constant clk_period: time := 50 ns;

	begin
	
	phase_detector0: entity work.phase_detector port map(
		clk => clk,
		phase_difference => phase_difference,
		reset => reset,
		waveform_a => waveform_a,
		waveform_b => waveform_b
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
		wait for 100 ms;
		
		-- assume waveform b is 24° behind waveform a
      waveform_a <= "0000"; -- a = 0
		waveform_b <= "1101"; -- b = -3
      wait for 50 ms;
      waveform_a <= "0101"; -- a = 5
		waveform_b <= "0100"; -- b = 4
      wait for 50 ms;
      waveform_a <= "0100"; -- a = 4
		waveform_b <= "0101"; -- b = 5
      wait for 50 ms;
      waveform_a <= "1101"; -- a = -3
		waveform_b <= "1111"; -- b = -1
      wait for 50 ms;
      waveform_a <= "1011"; -- a = -5
		waveform_b <= "1011"; -- b = -5
      wait for 50 ms;
		waveform_a <= "0000"; -- a = 0
		waveform_b <= "1101"; -- b = -3
      wait for 100 ms;
		
	end process;
	
end bhv;