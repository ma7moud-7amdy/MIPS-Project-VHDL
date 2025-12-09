 library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity Memory is 
	port (
        clk: in std_logic;
        -- We only have 2048 address available so 11 bits would be enough
        -- But we use 32 bit because we are dealing with other registers and gates
        -- that work with 32-bit format.
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0); -- Data to write [used only with "SW"]
        -- Control Signals
        MemWrite : in std_logic;
        MemRead : in std_logic;
        
        -- Output Data [Data or Instructions]
        dataOut : out std_logic_vector(31 downto 0)
	);
					   			   
end entity;
-- Our Memory is a simple array of 2048 8-bits words [Byte]
architecture Behavioral of Memory is
    type memArray is array(0 to 2047) of std_logic_vector(7 downto 0); -- Creating custom type


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

    -- 0x0000001C: sll $t6, $t1, 2 => 00094A00
    temp_mem(28) := x"00"; temp_mem(29) := x"09"; temp_mem(30) := x"4A"; temp_mem(31) := x"00";

    -- 0x00000020: slt $t7, $t0, $t1 => 0109712A
    temp_mem(32) := x"01"; temp_mem(33) := x"09"; temp_mem(34) := x"71"; temp_mem(35) := x"2A";

    -- 0x00000024: beq $t0, $t1, 1 => 11090001
    temp_mem(36) := x"11"; temp_mem(37) := x"09"; temp_mem(38) := x"00"; temp_mem(39) := x"01";

    -- 0x00000028: addi $s0, $zero, 50 => 20100032
    temp_mem(40) := x"20"; temp_mem(41) := x"10"; temp_mem(42) := x"00"; temp_mem(43) := x"32";

    -- 0x0000002C: j 0x00000020 => 08000008
	temp_mem(44) := x"08"; temp_mem(45) := x"00"; temp_mem(46) := x"00"; temp_mem(47) := x"08";	 
	
    -- Data section:
    -- 0x00000030: variable a = 10 (0x0000000A)
    temp_mem(48) := x"00"; temp_mem(49) := x"00"; temp_mem(50) := x"00"; temp_mem(51) := x"0A";

    -- 0x00000034: variable b = 15 (0x0000000F)
    temp_mem(52) := x"00"; temp_mem(53) := x"00"; temp_mem(54) := x"00"; temp_mem(55) := x"0F";

    -- 0x00000038: variable c (output) = 0 (placeholder)
    temp_mem(56) := x"00"; temp_mem(57) := x"00"; temp_mem(58) := x"00"; temp_mem(59) := x"00";

    return temp_mem;
end function;


    signal Memory: memArray := init_memory;
    
begin
    -- Memory organization:
    -- Addresses 0-16: Instructions
    -- Addresses 20-23: Variable a (value = 10)
    -- Addresses 24-27: Variable b (value = 15)
    -- Addresses 28-31: Variable c (will store a + b = 25)
		
	-- Clocked process (for writes only)
    process (clk)
        variable addr_ind : Integer; 
    begin
        if (rising_edge(clk)) then
            if (MemWrite = '1') then
                addr_ind := to_integer(unsigned(address));
                Memory(addr_ind)   <= dataIn(31 downto 24); 
                Memory(addr_ind+1) <= dataIn(23 downto 16);  
                Memory(addr_ind+2) <= dataIn(15 downto 8);  
                Memory(addr_ind+3) <= dataIn(7 downto 0); 
            end if;
        end if;
    end process;  
	
    -- Combinational read (immediate)
    process (MemRead, address)
        variable addr_ind : Integer; 
    begin
        if (MemRead = '1') then
            addr_ind := to_integer(unsigned(address));
            dataOut(31 downto 24) <= Memory(addr_ind); 
            dataOut(23 downto 16) <= Memory(addr_ind+1); 
            dataOut(15 downto 8)  <= Memory(addr_ind+2); 
            dataOut(7 downto 0)   <= Memory(addr_ind+3); 
        else
            dataOut <= (others => '0'); -- Default output
        end if;
    end process;
end architecture;
