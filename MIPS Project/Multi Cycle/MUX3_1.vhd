library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux3_1 is
    Port (
        a  : in  STD_LOGIC_VECTOR(31 downto 0);
        b  : in  STD_LOGIC_VECTOR(31 downto 0);
        c  : in  STD_LOGIC_VECTOR(31 downto 0);
		sel: in  STD_LOGIC_VECTOR(1 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture Behavioral of Mux3_1 is
begin
    process(sel, a, b, c)
    begin
        case sel is
            when "00" =>
                output <= a;
            when "01" =>
                output <= b;
            when "10" =>
                output <= c;
            when others =>
                output <= (others => '0');
        end case;
    end process;
end architecture;
