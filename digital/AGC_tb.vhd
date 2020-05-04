----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:10 05/04/2020 
-- Design Name: 
-- Module Name:    AGC_tb - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AGC_tb is
end AGC_tb;

architecture Behavioral of AGC_tb is
	signal clk: std_logic;
	signal input: unsigned(3 downto 0) := to_unsigned(0,4);
	signal clipped_high : std_logic;
	signal clipped_low : std_logic;
	signal output : unsigned(5 downto 0);
	constant clk_period: time := 10 us;
begin
	AGC0: entity work.AGC port map(
		clk => clk,
		input => input,
		clipped_high => clipped_high,
		clipped_low => clipped_low,
		output => output
	);
	
	-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	-- clipped_signals
	process
	begin
		clipped_high <= '0';
		clipped_low <= '0' ;
		wait for 100 ms;
		clipped_high <= '1';
		clipped_low <= '0' ;
		wait for 10 us;
	end process;
	
	process(clk) begin
		if clk'event and clk = '1' then 
			input <= output(3 downto 0) + to_unsigned(1,4);
		end if;
	end process;
end Behavioral;

