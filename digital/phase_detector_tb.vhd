----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Phase detector TB
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity phase_detector_tb is
end phase_detector_tb;


	

architecture Behavioral of phase_detector_tb is

   signal total_phase :unsigned(10 downto 0);
   signal waveform_a :signed(3 downto 0):= to_signed(0,4);
	signal waveform_reader_data: signed(3 downto 0):= to_signed(0,4);
	
	signal clk: std_logic;
	constant clk_period: time := 50 ns;
	
	--100kHz clock
	signal clk_100k: std_logic := '1';
	constant flip_value: unsigned(6 downto 0) := to_unsigned(99,7);
	signal clk_counter: unsigned(6 downto 0) := to_unsigned(0,7);
begin
	phase_detector0: entity work.phase_detector_v2 port map(
		clk_100k => clk_100k,
		clk => clk,
		total_phase => total_phase,
		waveform_a => waveform_reader_data
	);
	
	waveform_reader_0: entity work.waveform_reader generic map(
		filename => "waveforms/signal_binary_0-15_hex.txt",
		samplerate => 100000,
		bits => 4,
		rows => 17001,
		columns => 1
	) port map(
		data => waveform_reader_data
	);
	
		waveform_writer_0: entity work.waveform_writer generic map(
	filename => "waveforms/output.txt",
	samplerate => 100000,
	bits => 11,
	rows => 9000,
	columns => 1
	) port map(
		data => total_phase
	);
	
-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
-- create 100 kHz signal
	process(clk)
	begin
		if clk'event and clk = '1' then
			if clk_counter = flip_value then 
				clk_counter <= to_unsigned(0,7);
				clk_100k <= not(clk_100k);
			else
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process;
	


end Behavioral;

