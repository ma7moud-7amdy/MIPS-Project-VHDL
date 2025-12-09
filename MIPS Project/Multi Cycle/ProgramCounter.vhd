library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port (
        clk    : in  std_logic;
        reset    : in  std_logic;
        PCWrite: in  std_logic;
        PC_in  : in  std_logic_vector(31 downto 0);
        PC_out : out std_logic_vector(31 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal PC : std_logic_vector(31 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            if PCWrite = '1' then
                PC <= PC_in;
            end if;
        end if;
    end process;

    PC_out <= PC;

end Behavioral;
