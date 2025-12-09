library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Memory_tb is
end entity;

architecture sim of Memory_tb is 
	signal clk: std_logic := '0';
    signal address: std_logic_vector(31 downto 0) := x"0000_0000";   
    signal dataIn : std_logic_vector(31 downto 0) := x"0000_0000";
    signal MemWrite : std_logic := '1';
    signal MemRead : std_logic := '0';	 
		
    signal dataOut : std_logic_vector(31 downto 0) := x"0000_0000";
	begin
		Mem: entity Memory
			port map(clk, address, dataIn, MemWrite, MemRead, dataOut) ;


	
	-- Clock generation
	ClockGen: process
	begin
		while true loop
			clk <= '0';
			wait for 10 ns;
			clk <= '1';
			wait for 10 ns;
		end loop;
	end process;

	Driver: process
	begin
		-- Initial write to address 0
		--wait for 20 ns;
		address <= x"0000_0000";
		dataIn <= x"1111_1111";
		MemWrite <= '1';
		wait for 20 ns;

		-- Write to address 1
		address <= x"0000_0004";
		dataIn <= x"2222_2222";
		wait for 20 ns;

		-- Now read back address 0
		MemWrite <= '0';
		MemRead <= '1';
		address <= x"0000_0000";
		wait for 20 ns;

		-- Read back address 1
		address <= x"0000_0004";
		wait for 20 ns;

		wait; -- Stop simulation
	end process;
end architecture;
