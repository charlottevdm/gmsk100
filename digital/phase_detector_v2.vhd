----------------------------------------------------------------------------------
-- Student: Mike Storms r0653464
-- Goal: 	Phase detector, detects, TOTAL phase of waveform a
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity phase_detector_v2 is
	Port (  clk_100k : in  STD_LOGIC; --100kHz
			  clk : in  STD_LOGIC; --20MHz
           total_phase : out unsigned(10 downto 0);
           waveform_a : in  signed(3 downto 0));
end phase_detector_v2;

architecture Behavioral of phase_detector_v2 is
--zero-to-zero signals
	signal running_time_a: unsigned(10 downto 0) := to_unsigned(0,11); -- amount cycles you can fit in half a period + 5 bit, is actually a floating point number with 5 bit after the point
	signal running_time_b: unsigned(10 downto 0) := to_unsigned(0,11); 
	signal waveform_a_del: signed(3 downto 0) := to_signed(1,4);
	signal waveform_b_del: signed(3 downto 0) := to_signed(1,4);
	signal waveform_a_del_hf: signed(3 downto 0) := to_signed(1,4);
	signal waveform_b_del_hf: signed(3 downto 0) := to_signed(1,4);
	signal waveform_a_del2: signed(3 downto 0) := to_signed(1,4);
	signal waveform_b_del2: signed(3 downto 0) := to_signed(1,4);
	signal z2z_a: unsigned(10 downto 0) := to_unsigned(0,11);
	signal z2z_b: unsigned(10 downto 0) := to_unsigned(0,11);
	signal after_zero_a: std_logic := '0'; 
	signal after_zero_b: std_logic := '0'; 
	
--handshanking signals
	signal enable_fraction_a: std_logic := '0';
	signal enable_fraction_b: std_logic := '0';
	signal done_fraction_a: std_logic := '0';
	signal done_fraction_b: std_logic := '0';
	signal enable_fraction_zero_a: std_logic := '0';
	signal enable_fraction_zero_b: std_logic := '0';
	signal done_fraction_zero_a: std_logic := '0';
	signal done_fraction_zero_b: std_logic := '0';

	
--fraction signals 2 point
	signal fraction_sol_a: unsigned(10 downto 0) := to_unsigned(0,11);
	signal fraction_sol_b: unsigned(10 downto 0) := to_unsigned(0,11);
	signal distance_to_zero_a: signed(3 downto 0) := to_signed(0,4);
	signal distance_to_zero_b: signed(3 downto 0) := to_signed(0,4);
	signal full_distance_a: signed(3 downto 0) := to_signed(1,4);
	signal full_distance_b: signed(3 downto 0) := to_signed(0,4);
	signal distance_to_zero_a_extended: signed(10 downto 0) := to_signed(0,11); --distance_to_zero + 5bits
	signal distance_to_zero_b_extended: signed(10 downto 0) := to_signed(0,11);
	signal full_distance_a_extended: signed(10 downto 0) := to_signed(1,11);
	signal full_distance_b_extended: signed(10 downto 0) := to_signed(1,11);
	signal cycle_a: unsigned(1 downto 0):= to_unsigned(0,2);
	signal cycle_b: unsigned(1 downto 0):= to_unsigned(0,2);	
	signal z2z_a_fraction: unsigned(10 downto 0) := to_unsigned(0,11);
	signal z2z_b_fraction: unsigned(10 downto 0) := to_unsigned(0,11);
	signal time_left_a: unsigned(10 downto 0) := to_unsigned(0,11);
	signal time_left_b: unsigned(10 downto 0) := to_unsigned(0,11);
--fraction signals 3 point	
	signal fraction_sol_zero_a: unsigned(10 downto 0) := to_unsigned(0,11);
	signal fraction_sol_zero_b: unsigned(10 downto 0) := to_unsigned(0,11);
	signal distance_to_zero_zero_a: signed(3 downto 0) := to_signed(0,4);
	signal distance_to_zero_zero_b: signed(3 downto 0) := to_signed(0,4);
	signal full_distance_zero_a: signed(3 downto 0) := to_signed(1,4);
	signal full_distance_zero_b: signed(3 downto 0) := to_signed(0,4);
	signal distance_to_zero_zero_a_extended: signed(10 downto 0) := to_signed(0,11); --distance_to_zero + 5bits
	signal distance_to_zero_zero_b_extended: signed(10 downto 0) := to_signed(0,11);
	signal full_distance_a_zero_extended: signed(10 downto 0) := to_signed(1,11);
	signal full_distance_b_zero_extended: signed(10 downto 0) := to_signed(1,11);
	signal cycle_zero_a: unsigned(1 downto 0):= to_unsigned(0,2);
	signal cycle_zero_b: unsigned(1 downto 0):= to_unsigned(0,2);	
	signal time_left_zero_a: unsigned(10 downto 0) := to_unsigned(0,11);
	signal time_left_zero_b: unsigned(10 downto 0) := to_unsigned(0,11);
	signal z2z_a_zero: unsigned(10 downto 0) := to_unsigned(0,11);
	signal z2z_b_zero: unsigned(10 downto 0) := to_unsigned(0,11);
begin
	--zero_to_zero calculation a
	total_phase <= z2z_a;
	process(clk_100k)
	begin
		if clk_100k'event and clk_100k = '1' then 
			if waveform_a = to_signed(0,4) then
				-- zero crossing at the point
				after_zero_a <= '1';
			elsif after_zero_a = '1' then 
				after_zero_a <= '0';
				running_time_a <= time_left_zero_a;
				z2z_a <= z2z_a_zero;
			elsif waveform_a(3) = waveform_a_del(3) then
				-- both are at the same sign, so same half period
				running_time_a <= running_time_a + "00010000000";
			else
				--signes are different, so zerocrossing, but not a full clockcycle
				z2z_a <= z2z_a_fraction;
				running_time_a <= time_left_a;
			end if;
		end if;
	end process;
	
	--fraction calculation a
	distance_to_zero_a_extended <= distance_to_zero_a & "0000000";
	full_distance_a_extended <= "0000000" & full_distance_a;
	
	distance_to_zero_zero_a_extended <= distance_to_zero_zero_a(2 downto 0) & "00000000";
	full_distance_a_zero_extended <= "0000000" & full_distance_zero_a;
	process(clk)
	begin
		if clk'event and clk = '1' then 
			--handshaking,
			if waveform_a(3) /= waveform_a_del_hf(3) and waveform_a /= "0000" and waveform_a_del_hf /= "0000" then
				--start fraction with 2 points
				enable_fraction_a <= '1';
			elsif waveform_a(3) /= waveform_a_del_hf(3) and waveform_a_del_hf = "0000" then
				--start fraction with 3 points
				enable_fraction_zero_a <= '1';
			else
				if done_fraction_a = '1' then
					enable_fraction_a <= '0';
					done_fraction_a <= '0';
				end if;
				if done_fraction_zero_a = '1' then
					enable_fraction_zero_a <= '0';
					done_fraction_zero_a <= '0';
				end if;
			end if;
			
			--fraction with 2 points calculation
			if enable_fraction_a = '1' then 
				distance_to_zero_a <= abs(waveform_a_del);
				full_distance_a <= abs(waveform_a) + abs(waveform_a_del);
				fraction_sol_a <= unsigned(distance_to_zero_a_extended)/unsigned(full_distance_a_extended);
				if cycle_a = "00" then
					cycle_a <= "01";
				elsif cycle_a = "01" then
					cycle_a <= "10";
					done_fraction_a <= '1';
				else
					cycle_a <= "00";
					z2z_a_fraction <= running_time_a + unsigned(fraction_sol_a(10 downto 0));
					time_left_a <= "00010000000" - fraction_sol_a(10 downto 0);
				end if;
			end if;
			
			--fraction with 3 points calculation
			if enable_fraction_zero_a = '1' then 
				distance_to_zero_zero_a <= abs(waveform_a_del2);
				full_distance_zero_a <= abs(waveform_a) + abs(waveform_a_del2);
				fraction_sol_zero_a <= unsigned(distance_to_zero_zero_a_extended)/unsigned(full_distance_a_zero_extended);
				if cycle_zero_a = "00" then
					cycle_zero_a <= "01";
				elsif cycle_zero_a = "01" then
					cycle_zero_a <= "10";
					done_fraction_zero_a <= '1';
				else
					cycle_zero_a <= "00";
					z2z_a_zero <= running_time_a + fraction_sol_zero_a(10 downto 0);
					time_left_zero_a <= "00100000000" - unsigned(fraction_sol_zero_a(10 downto 0));
				end if;
			end if;
			
		end if;
	end process;
	
	-- delay signal at 100 kHz
	process(clk_100k)
	begin
		if clk_100k'event and clk_100k = '1' then 
			waveform_a_del <= waveform_a;
			waveform_a_del2 <= waveform_a_del;
			waveform_b_del2 <= waveform_b_del;
		end if;
	end process;
	
	-- delay signal at 20MHz
	process(clk)
	begin
		if clk'event and clk = '1' then 
			waveform_a_del_hf <= waveform_a;
		end if;
	end process;

end Behavioral;

