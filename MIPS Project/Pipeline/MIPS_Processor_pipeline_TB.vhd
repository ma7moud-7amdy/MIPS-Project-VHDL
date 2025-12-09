library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_Processor_pipeline_tb is
end entity;

architecture Behavioral of MIPS_Processor_pipeline_tb is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

begin

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Instantiate MIPS Processor
    uut: entity MIPS_Processor_pipeline
        port map(
            clk => clk,
            reset => reset
        );


end architecture;
