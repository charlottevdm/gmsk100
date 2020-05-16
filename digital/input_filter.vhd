----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	convert a 16 bit one-of-2^n to a 4 bit binary signal
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity input_filter is
	port(	clk_100k: in std_logic;
			input: in unsigned(15 downto 0);
			output: out unsigned(3 downto 0));
end input_filter;

architecture Behavioral of input_filter is

begin
	-- one-of-2^N to binary convertor
	process(clk_100k)
	begin
		if clk_100k'event and clk_100k = '1' then 
			if input(15) = '1' then
				output <= "1111";
			if input(14) = '1' then
				output <= "1110";
			if input(13) = '1' then
				output <= "1101";
			if input(12) = '1' then
				output <= "1100";
			if input(11) = '1' then
				output <= "1011";
			if input(10) = '1' then
				output <= "1010";
			if input(9) = '1' then
				output <= "1001";
			if input(8) = '1' then
				output <= "1000";
			if input(7) = '1' then
				output <= "0111";
			if input(6) = '1' then
				output <= "0110";
			if input(5) = '1' then
				output <= "0101";
			if input(4) = '1' then
				output <= "0100";
			if input(3) = '1' then
				output <= "0011";
			if input(2) = '1' then
				output <= "0010";
			if input(1) = '1' then
				output <= "0001";
			if input(0) = '1' then
				output <= "0000";
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
			end if;
		end if;
	end process;

end Behavioral;

