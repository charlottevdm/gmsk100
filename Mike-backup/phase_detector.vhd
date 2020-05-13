library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity phase_detector is
	 generic(
			  bits_output: integer := 8;
			  bits_input: integer := 4);
    Port ( clk : in  STD_LOGIC;
           phase_difference : out  STD_LOGIC_VECTOR(bits_output-1 downto 0); -- negative is phase of waveform a is 
           reset : in  STD_LOGIC;
           waveform_a : in  STD_LOGIC_VECTOR(bits_input-1 downto 0);
           waveform_b : in  STD_LOGIC_VECTOR(bits_input-1 downto 0));
end phase_detector;

architecture Behavioral of phase_detector is

	signal counter: unsigned(19 downto 0) := TO_UNSIGNED(0, 20);
	signal reg: STD_LOGIC := '0';  										 -- reg for falling (0) or rising (1) edge
	signal previous: STD_LOGIC_VECTOR(bits_input-1 downto 0);    -- reg to determine previous point
	signal preprevious: STD_LOGIC_VECTOR(bits_input-1 downto 0); -- reg to determine preprevious point
	signal distance_1: STD_LOGIC_VECTOR(bits_output-1 downto 0); -- reg to distance between two points
	signal distance_2: STD_LOGIC_VECTOR(bits_output-1 downto 0); -- reg to distance between two points

begin

	output <= reg;
	
	process(clk)
	begin
		if clk'event and clk = '1' then
			if input = reg then
				counter <= to_unsigned(0, 20);
			elsif counter = (19 downto 0 => '1') then
				counter <= to_unsigned(0, 20);
				reg <= input;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;

end Behavioral;
