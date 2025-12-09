library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A_Res     : in  STD_LOGIC_VECTOR(31 downto 0);
        B_Res      : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0);
        result     : out STD_LOGIC_VECTOR(31 downto 0);
        zero       : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is
signal a, b, res : signed(31 downto 0);


   

begin
    a <= signed(A_Res);
    b <= signed(B_Res);
	
	


    process(a, b, ALUControl)
    begin
        case ALUControl is
            when "000" => res <= a and b; -- AND
            when "001" => res <= a or b;  -- OR
            when "010" => res <= a + b;   -- ADD
            when "011" => res <= a xor b; -- XOR
            when "100" => res <= not (a or b); -- NOR
            when "101" => res <= b sll to_integer(unsigned(A_Res(10 downto 6))); -- SLL
            when "110" => res <= a - b;   -- SUB
            when "111" => 
                if a < b then
                    res <= (others => '0'); res(0) <= '1'; -- SLT
                else
                    res <= (others => '0');
                end if;
            when others =>
                res <= (others => '0');

        end case;
    end process;

    result <= std_logic_vector(res);
    zero <= '1' when a=b else '0';	  --beq


end Behavioral;
