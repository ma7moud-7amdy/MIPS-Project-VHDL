library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_ID_Register is
    Port (
        clk            : in  std_logic;
        reset          : in  std_logic;

        PC_4_IF        : in  std_logic_vector(31 downto 0);
        instruction_IF : in  std_logic_vector(31 downto 0);

        PC_4_ID        : out std_logic_vector(31 downto 0);
        instruction_ID : out std_logic_vector(31 downto 0)
    );
end IF_ID_Register;

architecture Behavioral of IF_ID_Register is

    signal PC_4_reg        : std_logic_vector(31 downto 0) := (others => '0');
    signal instruction_reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            PC_4_reg        <= (others => '0');
            instruction_reg <= (others => '0');

        elsif rising_edge(clk) then
            PC_4_reg        <= PC_4_IF;
            instruction_reg <= instruction_IF;
        end if;
    end process;

    PC_4_ID        <= PC_4_reg;
    instruction_ID <= instruction_reg;

end Behavioral;
