library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity slice is
	port (
		immediate: in std_logic_vector(15 downto 0);
		rd : out  std_logic_vector(4 downto 0);
		funct: out std_logic_vector(5 downto 0)
		);
end entity;

architecture behave of slice is

begin
		rd <= immediate(15 downto 11);
		funct <= immediate(5 downto 0);
		
end architecture ;