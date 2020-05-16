----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Convert a 8 bit signal to a binary signal, the two levels that represent
--				'1' and '0' can be variable, so the treshold is sensed to differenciate
--				the two binary values
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity VL2B is
	Port(phase_input : 	in  	unsigned(7 downto 0);
		  clk: 				in 	std_logic; --100kHz 
		  binary_data: 	out 	std_logic);
end VL2B;

architecture Behavioral of VL2B is
	signal sum: unsigned(21 downto 0) := to_unsigned(0,22); --bits input + 14 bit because average over 16000 cycles
	signal running_counter: unsigned(13 downto 0) := to_unsigned(0,14); --counter that wraps around
	signal average: unsigned(7 downto 0) := to_unsigned(205,8);
begin
	--create average signal as treshold for binary signal
	process(clk)
	begin
		if clk'event and clk = '1' then 
			if running_counter = to_unsigned(0,14) then
				sum <= to_unsigned(0,22);
				average <= sum(21 downto 14);
			else
				sum <= sum + phase_input;
			end if;
			running_counter <= running_counter + 1;
		end if;
	end process;
	
	--compare incoming signal with average to convert to binary
	process(clk)
	begin
		if clk'event and clk = '1' then 
			if phase_input <= average then
				binary_data <= '0';
			else
				binary_data <= '1';
			end if;
		end if;
	end process;
	

end Behavioral;

