library IEEE;
use IEEE.std_logic_1164.all;

entity alu_control is
	port(
		ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
		funct : in STD_LOGIC_VECTOR(5 downto 0);
		ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
	);
end alu_control;

architecture Behavioral of alu_control is
begin
    process(ALUOp, funct)
    begin
        case ALUOp is
            when "00" =>
                ALUControl <= "010"; -- lw, sw, addi (ADD)
            when "01" =>
                ALUControl <= "110"; -- beq (SUB)
            when "10" => -- R-type
                case funct is
                    when "100000" => ALUControl <= "010"; -- ADD
                    when "100010" => ALUControl <= "110"; -- SUB
                    when "100100" => ALUControl <= "000"; -- AND
                    when "100101" => ALUControl <= "001"; -- OR
                    when "100110" => ALUControl <= "011"; -- XOR
                    when "100111" => ALUControl <= "100"; -- NOR
                    when "000000" => ALUControl <= "101"; -- SLL
                    when "101010" => ALUControl <= "111"; -- SLT
                    when others   => ALUControl <= "000";
                end case;
            when others =>
                ALUControl <= "000";
        end case;
    end process;



end Behavioral;
