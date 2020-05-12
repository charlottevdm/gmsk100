library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity phase_detector is
	 generic(
			  bits_output: integer := 8;
			  bits_input: integer := 4
	 );
    Port ( clk : in  STD_LOGIC;
           phase_difference : out unsigned(bits_output-1 downto 0);
			  -- 2 complement form
			  -- positive if phase of waveform b is too large (larger than a)
			  -- negative if phase of waveform b is too small (smaller than a)
           reset : in  STD_LOGIC;
           waveform_a : in  unsigned(bits_input-1 downto 0);
           waveform_b : in  unsigned(bits_input-1 downto 0));
end phase_detector;


architecture Behavioral of phase_detector is			  
	
	--signal phase: unsigned(bits_output-1 downto 0) := to_unsigned(24, bits_output); -- 24° in binary, assuming the nb of input bits is 4 (360/15 = 24°)
	signal result_xor: unsigned(bits_input-1 downto 0); 
	
	signal temp_a: unsigned(bits_input-1 downto 0);
	signal temp_b: unsigned(bits_input-1 downto 0);
	signal waveform_a_pre: unsigned(bits_input-1 downto 0);
	signal waveform_b_pre: unsigned(bits_input-1 downto 0);
	signal waveform_a_prepre: unsigned(bits_input-1 downto 0);
	signal waveform_b_prepre: unsigned(bits_input-1 downto 0);

	signal dist: unsigned(bits_input-1 downto 0);
	signal dist_prev: unsigned(bits_input-1 downto 0);
	signal waveform_diff: unsigned(bits_input-1 downto 0);
	signal waveform_diff_pre: unsigned(bits_input-1 downto 0);	
	signal waveform_diff_prepre: unsigned(bits_input-1 downto 0);
	signal dist_diff: unsigned(bits_input-1 downto 0);
	signal sub: STD_LOGIC:= '1';
	signal add: STD_LOGIC:= '0';
	signal average: unsigned(bits_input-1 downto 0);
	signal average_pre: unsigned(bits_input-1 downto 0);
	signal final_average: unsigned(bits_input-1 downto 0);
	signal mult: unsigned(bits_output-2 downto 0);

	component fourbit_subtractor is
		Port ( clk : in STD_LOGIC;
	        reset : in STD_LOGIC;
			  X : in unsigned(bits_input-1 downto 0);
           Y : in unsigned(bits_input-1 downto 0);
           result : out unsigned(bits_input-1 downto 0);
			  sub: in STD_LOGIC
		);
	end component;
		
	begin

		process(waveform_a)
		begin
			if waveform_a'event then
				temp_a <= waveform_a;
				temp_b <= waveform_b;
			end if;
		end process;
		
		process(waveform_a)
		begin
			if waveform_a'event then
				waveform_a_pre <= temp_a;
				waveform_b_pre <= temp_b;
			end if;
		end process;
		
		process(waveform_a)
		begin
			if waveform_a'event then
				waveform_a_prepre <= waveform_a_pre;
				waveform_b_prepre <= waveform_b_pre;
			end if;
		end process;
		
		SUB1: fourbit_subtractor 
			port map (
				clk, 
				reset, 
				waveform_a, 
				waveform_a_pre, 
				dist,
				sub
			);
		
		SUB2: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_a_pre,
				waveform_a_prepre,
				dist_prev,
				sub
			);
			
		SUB3: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_a,
				waveform_b,
				waveform_diff,
				sub
			);
			
		SUB4: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_a_pre,
				waveform_b_pre,
				waveform_diff_pre,
				sub
			);
			
		SUB5: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_a_prepre,
				waveform_b_prepre,
				waveform_diff_prepre,
				sub
			);
			
		SUB6: fourbit_subtractor
			port map (
				clk,
				reset,
				dist,
				dist_prev,
				dist_diff,
				sub
			);
		
		SUB7: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_diff_pre,
				waveform_diff_prepre,
				average_pre,
				add
			);
			
		SUB8: fourbit_subtractor
			port map (
				clk,
				reset,
				waveform_diff,
				average_pre,
				average, -- the average is equal to the average of (the current waveform difference and the average of the two previous waveform differences)
				add
			);
			
		process(clk)
		begin
			if (clk'event and clk = '1') then
			
				result_xor <= waveform_a xor waveform_b;
				if average = "0001" then
					mult <= "0010000"; -- mult = 16
				elsif average = "0010" then
					mult <= "0100000";-- mult = 32
				else
					mult <= "0110000"; -- mult = 48
				end if;
				
				if (result_xor = "0000") then
					phase_difference <= "00000000";
				else
					if dist_diff(bits_input-1) = '0' then -- rising edge (dist > prev_dist)
						if waveform_diff(bits_input-1) = '0' then -- waveform_a > waveform_b
							phase_difference <= "0" & mult; -- positive
						elsif waveform_diff(bits_input-1) = '1' then -- waveform_a < waveform_b
							phase_difference <= "1" & (not(mult)+1); -- negative
						end if;
					else -- falling edge (dist < prev_dist)
						if waveform_diff(bits_input-1) = '0' then -- waveform_a > waveform_b
							phase_difference <= "1" & (not(mult)+1); -- negative
						elsif waveform_diff(bits_input-1) = '1' then -- waveform_a < waveform_b
							phase_difference <= "0" & mult; -- positive
						end if;
					end if;
					
				end if;
			end if;
		end process;
		

	end Behavioral;
