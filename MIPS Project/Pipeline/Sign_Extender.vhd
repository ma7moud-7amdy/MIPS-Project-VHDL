library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity sign_extend is
	port(
	input : in STD_LOGIC_Vector(15 downto 0);
	output : out STD_LOGIC_Vector(31 downto 0)
	);
end sign_extend;

architecture convert of sign_extend is
begin	 	
	output <= std_logic_vector(resize(signed(input),32));
end convert;
