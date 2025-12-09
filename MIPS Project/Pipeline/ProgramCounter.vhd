library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    Port (
        clk    : in  std_logic;
        reset    : in  std_logic;
        PC_in  : in  std_logic_vector(31 downto 0);
        PC_out : out std_logic_vector(31 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal PC : std_logic_vector(31 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin -- Asynchronus Reset
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            	PC <= PC_in;
        end if;
    end process;

    PC_out <= PC;

end Behavioral;	 


-- Note: used asynchronus reset , can use synchronus 
-- in real when turning on bootstrp program run 
-- then load OS kernal into CPU 
-- when stsrt execution of programm PC points to first instruction
-- often at adress 0x0040_0000
