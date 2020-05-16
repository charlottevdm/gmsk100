library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity fourbit_subtractor is
    Port ( clk : in STD_LOGIC;
	        reset : in STD_LOGIC;
			  X : in unsigned(3 downto 0);
           Y : in unsigned(3 downto 0);
           result : out unsigned(3 downto 0);
			  sub: in STD_LOGIC
	 );
end fourbit_subtractor;


architecture Behavioral of fourbit_subtractor is
	
	signal result_0 : STD_LOGIC;
	signal result_1 : STD_LOGIC;
	signal result_2 : STD_LOGIC;
	signal result_3 : STD_LOGIC;
	signal carry_0  : STD_LOGIC;
	signal carry_1  : STD_LOGIC;
	signal carry_2  : STD_LOGIC;
	signal Y_temp	 : unsigned(3 downto 0);
	signal X_temp	 : unsigned(3 downto 0);
	
begin
	process(clk)
	begin
		--if (clk'event and clk = '1') then
			if (sub = '1') then
				Y_temp <= not(Y) + 1;
				X_temp <= X;
			else
				if (X(3) = '1') then
					X_temp <= not(X) + 1;
				else
					X_temp <= X;
				end if;
				if (Y(3) = '1') then
					Y_temp <= not(Y) + 1;
				else
					X_temp <= X;
				end if;
			end if;

			result_0 <= X_temp(0) XOR Y_temp(0);
			carry_0 <= X_temp(0) AND Y_temp(0);
			result_1 <= (X_temp(1) XOR Y_temp(1)) XOR carry_0;
			carry_1 <= (X_temp(1) AND (Y_temp(1) OR carry_0)) OR (Y_temp(1) AND carry_0);
			result_2 <= (X_temp(2) XOR Y_temp(2)) XOR carry_1;
			carry_2 <= (X_temp(2) AND (Y_temp(2) OR carry_1)) OR (Y_temp(2) AND carry_1);
			result_3 <= (X_temp(3) XOR Y_temp(3)) XOR carry_2;
			result <= result_3 & result_2 & result_1 & result_0;
		--end if;
	end process;

end Behavioral;

