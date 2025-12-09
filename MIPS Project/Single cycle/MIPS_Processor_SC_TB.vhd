library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_Processor_SC_tb is
end entity;

architecture Behavioral of MIPS_Processor_SC_tb is

    signal clk   : std_logic := '1';
    signal reset : std_logic := '0';

begin

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for 20 ns;
            clk <= '0';
            wait for 20 ns;
        end loop;
    end process;

    -- Instantiate MIPS Processor
    uut: entity work.MIPS_Processor_SC
        port map(
            clk => clk,
            reset => reset
        );


end architecture;