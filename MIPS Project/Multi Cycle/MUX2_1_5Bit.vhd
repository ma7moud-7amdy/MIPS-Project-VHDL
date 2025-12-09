library IEEE;
use IEEE.std_logic_1164.all;

entity MUX2_1_5Bit is
	port(
		a : in STD_LOGIC_VECTOR(4 downto 0);
		b : in STD_LOGIC_VECTOR(4 downto 0);
		sel : in STD_LOGIC;
		output : out STD_LOGIC_VECTOR(4 downto 0)
	);
end entity;


architecture Behavioral of MUX2_1_5Bit is
begin
	output <= a when sel = '0' else b;

end architecture;
