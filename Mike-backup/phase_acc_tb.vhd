----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:32 03/18/2020 
-- Design Name: 
-- Module Name:    phase_acc_tb - Behavioral 
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
use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phase_acc_tb is
end phase_acc_tb;

architecture Behavioral of work.phase_acc_tb is
	signal clk: std_logic := '0';
	signal input: unsigned(7 downto 0) := to_unsigned(0,8);
	signal phase: unsigned(9 downto 0);
	signal amplitude : signed(3 downto 0);
	signal amplitude_delay : signed(3 downto 0);
	constant clk_period: time := 50 ns;
	--signal filtered_input : unsigned(7 downto 0);
	
	--writing
	
	
	
	
begin
--	filter0: entity work.DPLL_filter port map(
--		input => input,
--		clk => clk,
--		output => filtered_input
--	);
	phase_acc0: entity work.phase_acc port map(
		clk => clk,
		input => input,
		phase_out => phase
	);
	phase_to_amp0: entity work.phase_to_amp port map(
		clk => clk,
		phase_in => phase,
		amp_out => amplitude
	);
	

		
	-- clock process
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	-- stimulus process
	process
	begin
	
		-- start
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		wait for 10 us;
		input <= to_unsigned(210,8);
		
		
		
	end process;
	
	--delay
	process(clk)
	begin
		if clk'event and clk = '1' then
			amplitude_delay <= amplitude;
		end if;
	end process;
	
	writer0: entity work.waveform_writer generic map(
		filename => "waveforms/nco_test.txt",
		samplerate => 100000,
		bits => 4,
		rows => 150,
		columns => 1
	) port map(
		data => amplitude
	);
	
end Behavioral;
