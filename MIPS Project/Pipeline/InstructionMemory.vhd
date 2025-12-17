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
    0  => x"20", 1  => x"08", 2  => x"00", 3  => x"05", -- addi $t0, $zero, 5
    4  => x"20", 5  => x"09", 6  => x"00", 7  => x"0A", -- addi $t1, $zero, 10	

    -- 2 NOPs due to RAW hazard
    8  => x"00", 9  => x"00", 10 => x"00", 11 => x"20", -- NOP
    12 => x"00", 13 => x"00", 14 => x"00", 15 => x"20", -- NOP

    16 => x"01", 17 => x"09", 18 => x"50", 19 => x"20", -- add $t2, $t0, $t1
    20 => x"01", 21 => x"09", 22 => x"58", 23 => x"2A", -- slt $t3, $t0, $t1

    24 => x"00", 25 => x"00", 26 => x"00", 27 => x"20", -- NOP

    28 => x"AC", 29 => x"0A", 30 => x"00", 31 => x"00", -- sw $t2, 0($t4)
    32 => x"8D", 33 => x"8D", 34 => x"00", 35 => x"00", -- lw $t5, 0($t4)

    -- ONLY ONE NOP before BEQ (load ? branch hazard)
    36 => x"00", 37 => x"00", 38 => x"00", 39 => x"20", -- NOP 
	40 => x"00", 41 => x"00", 42 => x"00", 43 => x"20", -- NOP

    44 => x"11", 45 => x"AA", 46 => x"00", 47 => x"04", -- beq $t5, $t2, +1
	
	
	48 => x"00", 49 => x"00", 50 => x"00", 51 => x"20", -- NOP 
	52 => x"00", 53 => x"00", 54 => x"00", 55 => x"20", -- NOP
	56 => x"00", 57 => x"00", 58 => x"00", 59 => x"20", -- NOP
	
    60 => x"20", 61 => x"0E", 62 => x"00", 63 => x"01", -- addi $t6, $zero, 1
	
    --48 => x"08", 49 => x"00", 50 => x"00", 51 => x"09", -- j 9	-- NOT TESTED
    
	64 => x"20", 65 => x"0F", 66 => x"00", 67 => x"63", -- addi $t7, $zero, 99

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