----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Testbench to test VL2B and the decoder
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity Decoder_VL2B_tb is
end Decoder_VL2B_tb;

architecture Behavioral of Decoder_VL2B_tb is

	signal clk: std_logic;

	signal binary_data: std_logic;
	signal phase_input: unsigned(7 downto 0);
	constant clk_period: time := 50 ns;
	signal ASCII: unsigned(6 downto 0);
	signal start: std_logic;
	
	--100kHz clock
	signal clk_100k: std_logic := '1';
	constant flip_value: unsigned(6 downto 0) := to_unsigned(99,7);
	signal clk_counter: unsigned(6 downto 0) := to_unsigned(0,7);
begin
	VL2B0: entity work.VL2B port map(
		clk => clk_100k,
		phase_input => phase_input,
		binary_data => binary_data
	);
	
	Decoder0: entity work.full_decoder port map(
		clk => clk,
		input => binary_data,
		start => start,
		output => ASCII
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
	
-- simultae input
	process
	begin
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		--repeat
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		--repeat
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		--repeat
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		
	end process;
	
--make start signal
	process
	begin
		start <= '1';
		wait for 10 ms;
		start <= '0';
		wait;
	end process;


end Behavioral;

