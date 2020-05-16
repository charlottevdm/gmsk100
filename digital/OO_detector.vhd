----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Detect two consequetive zeros, generate error signals if words are 
--				longer than the maximum length.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;


entity OO_detector is
	Port(	input: 		in 	std_logic;
			clk: 			in 	std_logic; -- 100 Hz
			reset:	 	in		std_logic;
			detect: 		out 	std_logic;
			error: 		out 	std_logic);
end OO_detector;

architecture Behavioral of OO_detector is
	signal 	prev_input : 		std_logic;
	constant	max_word_length:	unsigned(3 downto 0) := to_unsigned(13,4); -- max length is 10, +2 for possible 00, so 13 is when fault
	signal	current_cycle:		unsigned(3 downto 0) := to_unsigned(0,4);
	signal	detect_buffer:		std_logic;
	
begin
	-- 00 detection
	detect <= detect_buffer;
	process(clk) begin
		if clk'event and clk = '1' then
			if input = '0' and prev_input = '0' then
				detect_buffer <= '1';
			else 
				detect_buffer <= '0';
			end if;
		end if;
	end process;
	
	--error detection
	process(clk) begin
		if clk'event and clk = '1' then
			if detect_buffer = '1' or reset = '1' then
				current_cycle <= to_unsigned(2,4);
			else
				if current_cycle > max_word_length then
					current_cycle <= to_unsigned(0,4);
					error <= '1';
				else
					error <= '0';
				end if;
				current_cycle <= current_cycle + to_unsigned(1,4);
			end if;
		end if;
	end process;
	
	--delay input
	process(clk) begin
		if clk'event and clk = '1' then
		prev_input <= input;
		end if;
	end process;

end Behavioral;

