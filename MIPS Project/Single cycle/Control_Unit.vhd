				  library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control_Unit is
    port(
        opcode   : in  std_logic_vector(5 downto 0);
        RegDst   : out std_logic;
        RegWrite : out std_logic;
        ALUSrc   : out std_logic;
        ALUOp    : out std_logic_vector(1 downto 0);
        MemRead  : out std_logic;
        MemWrite : out std_logic;
        MemToReg : out std_logic;
        Branch   : out std_logic;
        Jump     : out std_logic
    );
end entity;

architecture Behavioral of Control_Unit is
begin
    process(opcode)
    begin
        -- Default values
        RegDst   <= '0';
        RegWrite <= '0';
        ALUSrc   <= '0';
        ALUOp    <= "00";
        MemRead  <= '0';
        MemWrite <= '0';
        MemToReg <= '0';
        Branch   <= '0';
        Jump     <= '0';

        case opcode is
            when "000000" =>  -- R-Type
                RegDst   <= '1';
                RegWrite <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "10";
            when "001000" =>  -- addi
                RegDst   <= '0';
                RegWrite <= '1';
                ALUSrc   <= '1';
                ALUOp    <= "00";
            when "001100" =>  -- andi
                RegDst   <= '0';
                RegWrite <= '1';
                ALUSrc   <= '1';
                ALUOp    <= "11";
            when "100011" =>  -- lw
                RegDst   <= '0';
                RegWrite <= '1';
                ALUSrc   <= '1';
                ALUOp    <= "00";
                MemRead  <= '1';
                MemToReg <= '1';
            when "101011" =>  -- sw
                ALUSrc   <= '1';
                ALUOp    <= "00";
                MemWrite <= '1';
            when "000100" =>  -- beq
                ALUSrc   <= '0';
                ALUOp    <= "01";
                Branch   <= '1';
            when "000010" =>  -- j
                Jump     <= '1';
            when others =>
                null;
        end case;
    end process;
end architecture;
