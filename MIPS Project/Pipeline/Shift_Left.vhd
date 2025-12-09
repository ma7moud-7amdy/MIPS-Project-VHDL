library IEEE;
use IEEE.std_logic_1164.all;

entity shift_left is
	port(
	    input : in STD_LOGIC_VECTOR(31 downto 0);  
		output : out STD_LOGIC_VECTOR(31 downto 0)
	);
end shift_left;


architecture Behavioral of shift_left is
begin
	output <= input(29 downto 0) & "00";

end Behavioral;
