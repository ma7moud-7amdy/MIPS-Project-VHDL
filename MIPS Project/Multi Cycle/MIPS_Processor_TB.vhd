library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPS_Processor_tb is
end MIPS_Processor_tb;

architecture behavior of MIPS_Processor_tb is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

    -- clock period
    constant clk_period : time := 20 ns;

begin

    -- instantiate the processor
    uut: entity MIPS_Processor
        port map (
            clk   => clk,
            reset => reset
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

end behavior;
