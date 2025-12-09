library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity concat is
	port (
		im: in std_logic_vector(15 downto 0);
		rs: in std_logic_vector(25 downto 21);
		rt: in std_logic_vector(20 downto 16);
		jump: out std_logic_vector(25 downto 0)
		
		);
end entity;

architecture behave of concat is

begin
		jump <= rs & rt & im;
		
end architecture ;