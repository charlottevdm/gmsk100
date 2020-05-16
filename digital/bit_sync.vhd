----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Create a clock signal on 100 Hz	
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;


entity bit_sync is
	Port(input : 			in  	std_logic;
		  clk: 				in 	std_logic;
		  start: 			in 	std_logic;
		  output: 			out 	std_logic;
		  done: 				out 	std_logic;
		  freq_switched:	out std_logic);
	
end bit_sync;

architecture Behavioral of bit_sync is
	signal 	loop_counter : 		integer := 0;
	signal 	max_counter : 			integer := 0;
	signal 	prev_input : 			std_logic := '0';
	signal 	first_time : 			std_logic := '1'; 
	signal 	clk_counter : 			integer := 0;
	signal 	clk_out : 				std_logic := '1'; 
	constant total_length : 		integer := 200000*25; -- 50 clockcycles
	signal 	run_signal : 			std_logic := '0';
	signal	handshake_counter : 	integer := 0;
	signal 	prev_run_signal :		std_logic := '0';
	signal	compute : 				std_logic;
	signal 	done_buffer:				std_logic;
begin
	
	--compute signal
	process(clk) begin
		if clk'event and clk = '1' then
			if start = '1' then
				compute <= '1';
			else
				if done_buffer = '1' then
					compute <= '0';
				end if;
			end if;
		end if;
	end process;
	
	--handshake protocol
	done <= done_buffer;
	process(clk) begin
		if clk'event and clk = '1'then
			if compute = '1' then
				if handshake_counter = total_length then
					run_signal <= '0';
					done_buffer <= '1';
					handshake_counter <= 0;
				else
					handshake_counter <= handshake_counter + 1;
					run_signal <= '1';
					done_buffer <= '0';
				end if;
			else
				run_signal <= '0';
				done_buffer <= '0';
			end if;
		end if ;
	end process;
	
	
	--counter length calculator
	process(clk) begin
		if clk'event and clk = '1' then
			if run_signal = '1' then
				if prev_run_signal = run_signal then --offset everything by 1 cycle, can be done more efficiently
					if prev_input = input then
						loop_counter <= loop_counter + 1;
						freq_switched <= '0';
					else
						if ((loop_counter < max_counter) or (first_time = '1')) and (loop_counter > 100000) then
							freq_switched <= '1';
							max_counter <= loop_counter/2;
							first_time <= '0';
						end if;
						loop_counter <= 0;
					end if;
				end if;
			else
				first_time <= '1';
				loop_counter <= 0;
				freq_switched <= '0';
			end if;
		end if;
	end process;
	
	--clk_out generator
	output <= clk_out;
	process(clk) begin
		if clk'event and clk = '1' then
			if clk_counter > max_counter then
				clk_counter <= 0;
				clk_out <= not(clk_out);
			else
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process;
	
	-- signal delay
	process(clk) begin
		if clk'event and clk = '1' then
			prev_input <= input;
			prev_run_signal <= run_signal;
		end if;
	end process;
	

end Behavioral;
