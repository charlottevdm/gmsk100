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
	signal waveform_reader_data: std_logic_vector(3 downto 0);
	
	constant clk_period: time := 50 ns;
	
begin
	
	digitalPLL0: entity work.digitalPLL port map(
		clk => clk,
		result => result,
		reset => reset,
		input => input
	);
	
	input <= unsigned(waveform_reader_data);
	waveform_reader_0: entity work.waveform_reader generic map(
		filename => "waveforms/signal_binary_0-15_hex.txt",
		samplerate => 100000,
		bits => 4,
		rows => 17001,
		columns => 1
	) port map(
		data => waveform_reader_data
	);
	
	-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
end;
