----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:23 03/18/2020 
-- Design Name: 
-- Module Name:    phase_to_amp - Behavioral 
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

entity phase_to_amp is
	 generic(
		bits_phase: integer := 10 ;
		bits_amp: integer := 4;
	   len: integer := 20;
		amount_cordic: integer := 18); 
    Port ( phase_in : in  unsigned(bits_phase - 1 downto 0);
           clk : in  STD_LOGIC;
           amp_out : out  signed(bits_amp - 1 downto 0));
end phase_to_amp;

architecture Behavioral of phase_to_amp is
	constant x_val_begin : signed(len - 1 downto 0) := to_signed(318375, len);
	constant y_val_begin : signed(len - 1 downto 0) := to_signed(0, len);
	signal 	x_val_first : signed(len - 1 downto 0);
	signal 	y_val_first : signed(len - 1 downto 0);
	signal 	x_val : signed(len - 1 downto 0);
	signal 	y_val : signed(len - 1 downto 0);
	signal 	x_val_next : signed(len - 1 downto 0);
	signal 	y_val_next : signed(len - 1 downto 0);
	signal 	out_rounded : signed(len - 1 downto 0);
	signal 	phase_val_first : unsigned(len - 1 downto 0);
	signal 	phase_val : unsigned(len - 1 downto 0);
	signal 	phase_val_next : unsigned(len - 1 downto 0);
	signal 	prev_phase : unsigned(bits_phase - 1 downto 0) := to_unsigned(0, bits_phase);
	signal 	k : integer := 0;
	signal 	loop_enable: std_logic := '0';
	signal 	stay_enable: std_logic := '0';
	type 		mem_cordic is array (0 to amount_cordic - 1) of unsigned(len - 1 downto 0);
	constant cordic_angles : mem_cordic := (resize(x"12E40",20), resize(x"9FB4",20), resize(x"5111",20), resize(x"28B1",20), resize(x"145D",20), resize(x"A2F",20), resize(x"518",20), resize(x"28C",20), resize(x"146",20), resize(x"A3",20), resize(x"51",20), resize(x"29",20), resize(x"14",20), resize(x"A",20), resize(x"5",20), resize(x"3",20), resize(x"1",20), resize(x"1",20));
	signal 	ready : std_logic := '0';
	signal 	amp_out_prev :  signed(bits_amp - 1 downto 0) := to_signed(0, bits_amp);
	signal 	reset_k : std_logic := '0';
	
begin 
	process(clk)
	begin
	
		-- initialiser
		if clk'event and clk = '1' then
			if prev_phase /= phase_in then
				loop_enable <= '1';
				ready <= '0';
				reset_k <= '1';
				case phase_in(bits_phase - 1 downto bits_phase - 3) is
					when "000" =>
						x_val_first <= x_val_begin;
						y_val_first <= y_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase));
					when "001"=>
						x_val_first <= -y_val_begin;
						y_val_first <= x_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(262144,len);
					when "010"=>
						x_val_first <= -y_val_begin;
						y_val_first <= x_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(262144,len);
					when "011"=>
						x_val_first <= -x_val_begin;
						y_val_first <= -y_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(524288,len);
					when "100"=>
						x_val_first <= -x_val_begin;
						y_val_first <= -y_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(524288,len);
					when "101"=>
						x_val_first <= y_val_begin;
						y_val_first <= -x_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(786432,len);
					when "110"=>
						x_val_first <= y_val_begin;
						y_val_first <= -x_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase)) - to_unsigned(786432,len);
					when "111"=>
						x_val_first <= x_val_begin;
						y_val_first <= y_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase));
					when others => -- isn't needed but gave an error?
						x_val_first <= x_val_begin;
						y_val_first <= y_val_begin;
						phase_val_first <= (phase_in & to_unsigned(0,len - bits_phase));
				end case;
			elsif k = (amount_cordic - 1) then -- gets problematic when input changes at the same time as k is maximum
				ready <= '1';
			else
				loop_enable <= '0';
				reset_k <= '0';
			end if;
		end if;
	end process;
	
	--CORDIC computator
	x_val <= x_val_first when (loop_enable = '1') else x_val_next;
	y_val <= y_val_first when (loop_enable = '1') else y_val_next;
	phase_val <= phase_val_first when (loop_enable = '1') else phase_val_next;
	process(clk)
	begin
		if clk'event and clk = '1' then 
			if loop_enable = '1' or stay_enable = '1' then
				if phase_val(len - 1) = '1' then
					-- negative phase
					x_val_next <= x_val + shift_right(y_val,k+1);
					y_val_next <= y_val - shift_right(x_val,k+1);

					phase_val_next <= phase_val + cordic_angles(k);
				else
					--poisitive phase
					x_val_next <= x_val - shift_right(y_val,k+1);
					y_val_next <= y_val + shift_right(x_val,k+1);
					
					phase_val_next <= phase_val - cordic_angles(k);	
				end if;
				
				if k = (amount_cordic - 1) then
					stay_enable <= '0';
				else
					stay_enable <= '1';
				end if;
			end if;
		end if;
	end process;
	
	--counter
	process(clk)
	begin
		if clk'event and clk = '1' then
			if reset_k = '1' then
				k <= 0;
			elsif loop_enable = '1' or stay_enable = '1' then
				if k /= (amount_cordic - 1) then
					k <= k + 1;
				else
					k <= 0;
				end if;
			end if;
		end if;
	end process;
	
	
	--select corrent output
	amp_out <= amp_out_prev;
	process(clk)
	begin
		if clk'event and clk = '1' then
			if ready = '1' then
				out_rounded <= y_val_next + to_signed(32768, len);
				amp_out_prev <= out_rounded(len-1 downto len - bits_amp);
			else
				amp_out_prev <= amp_out_prev;
			end if;
		end if;
	end process;
	
	
	-- delay phase
	process(clk)
	begin
		if clk'event and clk = '1' then
			prev_phase <= phase_in;
		end if;
	end process;
	
end Behavioral;
