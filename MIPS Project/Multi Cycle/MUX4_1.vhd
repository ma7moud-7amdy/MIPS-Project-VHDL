library IEEE;
use IEEE.std_logic_1164.all;

entity mux4_1 is
	port(
		a : in STD_LOGIC_VECTOR(31 downto 0);
		b : in STD_LOGIC_VECTOR(31 downto 0);
		c : in STD_LOGIC_VECTOR(31 downto 0);
		d : in STD_LOGIC_VECTOR(31 downto 0);
		sel : in STD_LOGIC_VECTOR(1 downto 0);
		output : out STD_LOGIC_VECTOR(31 downto 0)
	);
end mux4_1;

--}} End of automatically maintained section

architecture Behavioral of mux4_1 is
begin
	  process(a , b , c , d , sel)
    begin
        case sel is
            when "00" => output <= a ;
            when "01" => output <= b;
            when "10" => output <=c ;
            when "11" => output <= d ;
            when others => output <= (others => '0');
        end case;
    end process;

end Behavioral;
