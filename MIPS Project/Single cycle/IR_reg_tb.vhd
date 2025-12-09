library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_reg_tb is
end entity;

architecture tb of IR_reg_tb is
	signal clk       : std_logic := '0';
	signal enable    : std_logic := '0';
	signal IR_in     : std_logic_vector(31 downto 0) := (others => '0');
	signal Op_code   : std_logic_vector(31 downto 26);
	signal rs        : std_logic_vector(25 downto 21);
	signal rt        : std_logic_vector(20 downto 16);
	signal immediate : std_logic_vector(15 downto 0);
begin
	DUT:entity IR_reg
	port map (clk,enable,IR_in,Op_code,rs,rt,immediate);
	
	
	clk<=not clk after 20ns;
	process
	begin
		wait for 10 ns;
		IR_in <= "10001101001010000000000000000100";
		enable <= '1';
		wait for 20 ns;
		enable <= '0';
		wait for 20 ns;
		
		IR_in <= "00100010011100100000000000001010";
		enable <= '1';
		wait for 20 ns;
		enable <= '0';
		wait;
	end process;
end architecture;
