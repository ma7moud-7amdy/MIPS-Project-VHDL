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
	
	function init_memory return memArray is
    variable temp_mem : memArray := (others => (others => '0'));
	begin	   
		
    -- Instructions section:
    -- 0x00000000: lw $t0, 48($zero) => 8C080030
	temp_mem(0)  := x"8C"; temp_mem(1)  := x"08"; temp_mem(2)  := x"00"; temp_mem(3)  := x"30";

	-- 0x00000004: lw $t1, 52($zero) => 8C090034
	temp_mem(4)  := x"8C"; temp_mem(5)  := x"09"; temp_mem(6)  := x"00"; temp_mem(7)  := x"34";	
	
    -- 0x00000008: add $t2, $t0, $t1 => 01095020
    temp_mem(8)  := x"01"; temp_mem(9)  := x"09"; temp_mem(10) := x"50"; temp_mem(11) := x"20";	
	
	-- 0x0000000C: sw $t2, 56($zero)
    temp_mem(12) := x"AC"; temp_mem(13) := x"0A"; temp_mem(14) := x"00"; temp_mem(15) := x"38";
    
	-- 0x00000010: sub $t3, $t0, $t1 => 01095822
    temp_mem(16) := x"01"; temp_mem(17) := x"09"; temp_mem(18) := x"58"; temp_mem(19) := x"22";

    -- 0x00000014: and $t4, $t0, $t1 => 01096124
    temp_mem(20) := x"01"; temp_mem(21) := x"09"; temp_mem(22) := x"61"; temp_mem(23) := x"24";

    -- 0x00000018: nor $t5, $t0, $t1 => 01096927
    temp_mem(24) := x"01"; temp_mem(25) := x"09"; temp_mem(26) := x"69"; temp_mem(27) := x"27";

    -- 0x0000001C: addi $t6, $t1, 2 => 0x212E0002
    temp_mem(28) := x"21"; temp_mem(29) := x"2E"; temp_mem(30) := x"00"; temp_mem(31) := x"02";
										
    -- 0x00000020: slt $t7, $t0, $t1 => 0109782A
    temp_mem(32) := x"01"; temp_mem(33) := x"09"; temp_mem(34) := x"78"; temp_mem(35) := x"2A";

    -- 0x00000024: beq $t0, $t1, 1 => 11090001
    temp_mem(36) := x"11"; temp_mem(37) := x"09"; temp_mem(38) := x"00"; temp_mem(39) := x"01";

    -- 0x00000028: addi $s0, $zero, 50 => 20100032
    temp_mem(40) := x"20"; temp_mem(41) := x"10"; temp_mem(42) := x"00"; temp_mem(43) := x"32";

    -- 0x0000002C: j 0x00000020 => 08000008
	temp_mem(44) := x"08"; temp_mem(45) := x"00"; temp_mem(46) := x"00"; temp_mem(47) := x"08";	 
	
    return temp_mem;
end function;
	
	
    -- Initialize program manually (example program)   // put instructions here
    signal IMEM : memArray := init_memory;
	

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
