library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        A          : in  std_logic_vector(31 downto 0);
        B          : in  std_logic_vector(31 downto 0);
        ALUControl : in  std_logic_vector(3 downto 0);
        Result     : out std_logic_vector(31 downto 0);
        Zero       : out std_logic
    );
end entity;

architecture Behavioral of ALU is
    signal Result_int : std_logic_vector(31 downto 0);
begin
    
    --  (Combinational Logic)
    process(A, B, ALUControl)
        variable A_signed, B_signed : signed(31 downto 0);
        variable SLT_result : signed(31 downto 0);
    begin
        A_signed := signed(A);
        B_signed := signed(B);
        
        case ALUControl is
            when "0000" =>  -- AND
                Result_int <= A and B;
                
            when "0001" =>  -- OR
                Result_int <= A or B;
                
            when "0010" =>  -- ADD
                Result_int <= std_logic_vector(A_signed + B_signed);
                
            when "0110" =>  -- SUB
                Result_int <= std_logic_vector(A_signed - B_signed);
                
            when "0111" =>  -- SLT (Set Less Than)
                if (A_signed < B_signed) then
                    SLT_result := to_signed(1, 32);
                else
                    SLT_result := to_signed(0, 32);
                end if;
                Result_int <= std_logic_vector(SLT_result);
                
            when "0011" =>  -- XOR
                Result_int <= A xor B;
                
            when "1100" =>  -- NOR
                Result_int <= not (A or B);
                
            when others =>
                Result_int <= (others => '0');
        end case;
    end process;
    
    Result <= Result_int;
    
    -- Result_int (combinational)
    Zero <= '1' when Result_int = X"00000000" else '0';
    
end Behavioral;