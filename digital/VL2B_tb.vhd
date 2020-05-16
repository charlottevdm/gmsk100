----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Testbench VL2B
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity VL2B_tb is
end VL2B_tb;

architecture Behavioral of VL2B_tb is
	signal clk: std_logic;
	signal binary_data: std_logic;
	signal phase_input: unsigned(7 downto 0);
	constant clk_period: time := 10 us;
begin
	VL2B0: entity work.VL2B port map(
		clk => clk,
		phase_input => phase_input,
		binary_data => binary_data
	);
-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
-- simultae input
	process
	begin
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
		phase_input <= to_unsigned(202,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(207,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		phase_input <= to_unsigned(201,8);
		wait for 10 ms;
		
	end process;

end Behavioral;

