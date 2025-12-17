library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_Processor_pipeline_tb is
end entity;

architecture Behavioral of MIPS_Processor_pipeline_tb is

    signal clk   : std_logic := '1';
    signal reset : std_logic := '0';

begin

    -- Clock generation
    clk_process : process
	begin
	    clk <= '1';
	    wait for 10 ns;
	    clk <= '0';
	    wait for 10 ns;
	end process;
	
	-- Add reset release process
	--reset_process : process
	--begin
	  --  reset <= '1';
	   -- wait for 25 ns;  -- Hold reset for more than one clock cycle
	    --reset <= '0';
	    --wait;
	--end process;

    -- Instantiate MIPS Processor
    uut: entity work.MIPS_Processor_pipeline
        port map(
            clk => clk,
            reset => reset
        );


end architecture;
