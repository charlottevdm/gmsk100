----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:21:00 03/18/2020 
-- Design Name: 
-- Module Name:    phase_acc - Behavioral 
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

entity phase_acc is
 	generic(
		bits_input: integer :=  8 ;
		bits_increment: integer := 8;
		bits_phase: integer := 10); --bits_input+3 because max step = (2^n-1)/5 @ 20 kHz
    Port ( input : in  unsigned(bits_input - 1  downto 0);
			  clk: in std_logic;
           phase_out : out  unsigned(bits_phase - 1 downto 0));
end phase_acc;

architecture Behavioral of phase_acc is
	signal phase_increment : unsigned(bits_increment - 1 downto 0):= to_unsigned(0, bits_increment); 
	signal phase : unsigned(bits_phase - 1 downto 0):= to_unsigned(0, bits_phase);
	constant loop_amount : integer := 10000/50;
	signal loop_counter : integer := 0;
begin
		phase_increment <= input;
		phase_out <= phase;
		
	
	process(clk) begin
		if clk'event and clk = '1' then
			if loop_counter = loop_amount then
				phase <= resize(phase + (to_unsigned(0, bits_phase - bits_increment) & phase_increment) ,bits_phase);
				loop_counter <= 0;
			else
				loop_counter <= loop_counter + 1;
			end if;
		end if;
	end process;
	
end Behavioral;
