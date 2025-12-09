library IEEE;
use IEEE.std_logic_1164.all;

entity And_1bit is
	port(
		a : in STD_LOGIC;
		b : in STD_LOGIC;
		output : out STD_LOGIC
	);
end entity;


architecture Behavioral of And_1bit is
begin
	output <= a and b;

end architecture;
