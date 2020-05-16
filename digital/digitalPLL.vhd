library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity digitalPLL is
		generic(
			bits_output: integer := 8;
			bits_input: integer := 4;
			bits_phase: integer := 10
		);
		Port(
			clk 	 : in  STD_LOGIC;
         result : inout unsigned(bits_output-1 downto 0);
         reset  : in  STD_LOGIC;
         input  : in  unsigned(bits_input-1 downto 0)
		);
end digitalPLL;

architecture Behavioral of digitalPLL is
	
	signal phase_difference: unsigned(bits_output-1 downto 0);
	signal result_PA: unsigned(bits_phase-1 downto 0);
	signal result_PTA: signed(bits_input-1 downto 0);

	begin

	phase_detector0: entity work.phase_detector port map(
		clk => clk, --input
      phase_difference => phase_difference, --output -- 2 complement form - positive if phase of waveform b is too large (larger than a)
      reset => reset, --input
      waveform_a => unsigned(result_PTA),--input
      waveform_b => input --input
	);

	PIF0: entity work.DPLL_filter port map(
		input => signed(phase_difference), -- @ 100 kHz --input
		clk => clk, --input
		output => result --output
	);
	
	phase_acc0: entity work.phase_acc port map(
		input => result, --input
		clk => clk, --input
		phase_out => result_PA --output
	);
	
	phase_to_amp0: entity work.phase_to_amp port map(
	   phase_in => result_PA, --input
      clk => clk, --input
      amp_out => result_PTA --output
	);
	
	waveform_writer_0: entity work.waveform_writer generic map(
	filename => "waveforms/output.txt",
	samplerate => 100000,
	bits => 8,
	rows => 9000,
	columns => 1
	) port map(
		data => phase_difference
	);
	
end Behavioral;
