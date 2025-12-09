library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity jumpCal is
	port (
		jump: std_logic_vector(25 downto 0);
		pc_out: in std_logic_vector(31 downto 0);
		jump_address: out std_logic_vector(31 downto 0)
		
		);
end entity;

architecture behave of jumpCal is

begin
		jump_address <= pc_out(31 downto 28) & jump(25 downto 0 ) & "00";
		
end architecture ;