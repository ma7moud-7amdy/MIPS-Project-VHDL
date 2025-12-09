library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionMemory is
    port (
        address : in  std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of InstructionMemory is

	-- 2048 bytes ? 512 instructions
	-- you can increase size of memory easily by change 0 - 2047 
    type memArray is array(0 to 2047) of std_logic_vector(7 downto 0);

    -- Initialize program manually (example program)   // put instructions here
    signal IMEM : memArray := (
        0  => x"20", 1 => x"08", 2 => x"00", 3 => x"05", -- addi $t0, $zero, 5
        4  => x"20", 5 => x"09", 6 => x"00", 7 => x"0A", -- addi $t1, $zero, 10
        8  => x"01", 9 => x"09", 10 => x"50", 11 => x"20", -- add $t2, $t0, $t1
        12 => x"01", 13 => x"09", 14 => x"58", 15 => x"2A", -- slt $t3, $t0, $t1
        16 => x"AD", 17 => x"0A", 18 => x"00", 19 => x"00", -- sw $t2, 0($t4)
        20 => x"8D", 21 => x"0D", 22 => x"00", 23 => x"00", -- lw $t5, 0($t4)
        24 => x"11", 25 => x"AA", 26 => x"00", 27 => x"02", -- beq $t5, $t2, +2
        28 => x"20", 29 => x"0E", 30 => x"00", 31 => x"01", -- addi $t6, $zero, 1
        32 => x"08", 33 => x"00", 34 => x"00", 35 => x"09", -- j 9
        36 => x"20", 37 => x"0F", 38 => x"00", 39 => x"63", -- addi $t7, $zero, 99
        others => x"00"
    );

begin

    -- Combinational read
    process(address)

        variable addr : integer;
    begin
		-- memory is byte addresable
        -- Word aligned
        addr := to_integer(unsigned(address));
		-- BigIndian
        instruction(31 downto 24) <= IMEM(addr);
        instruction(23 downto 16) <= IMEM(addr + 1);
        instruction(15 downto 8)  <= IMEM(addr + 2);
        instruction(7 downto 0)   <= IMEM(addr + 3);
    end process;

end architecture;

-- we use Harvard Architeture
-- this memory has instructions 
