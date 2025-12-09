library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Control is
    port(
        ALUOp      : in  std_logic_vector(1 downto 0);
        Funct      : in  std_logic_vector(5 downto 0);
        ALUControl : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of ALU_Control is
begin
    process(ALUOp, Funct)
    begin
        -- Default value
        ALUControl <= "0000";

        case ALUOp is
            when "00" =>  -- I-type (addi, lw, sw)
                ALUControl <= "0010";  -- ADD
            when "01" =>  -- beq
                ALUControl <= "0110";  -- SUB
            when "10" =>  -- R-type
                case Funct is
                    when "100000" => ALUControl <= "0010"; -- add
                    when "100010" => ALUControl <= "0110"; -- sub
                    when "100100" => ALUControl <= "0000"; -- and
                    when "100101" => ALUControl <= "0001"; -- or
                    when "100111" => ALUControl <= "1100"; -- nor
                    when "100110" => ALUControl <= "0011"; -- xor
                    when "101010" => ALUControl <= "0111"; -- slt
                    when others   => ALUControl <= "0000"; -- default NOP
                end case;
            when "11" =>  -- I-type logic (andi)
                ALUControl <= "0000"; -- AND
            when others =>
                ALUControl <= "0000"; -- default
        end case;
    end process;
end Behavioral;
