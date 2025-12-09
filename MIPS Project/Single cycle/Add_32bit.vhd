library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Add_32bit is
    port(
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        result : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of Add_32bit is
begin	
	-- add unsigned (address)
    result <= std_logic_vector(unsigned(a) + unsigned(b));
end architecture;