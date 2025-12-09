library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMemory is 
    port (
        clk        : in std_logic;
        address    : in std_logic_vector(31 downto 0);
        WriteData  : in std_logic_vector(31 downto 0);
        MemWrite   : in std_logic;
        MemRead    : in std_logic;

        ResultData : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of DataMemory is

    -- Memory size = 4096 bytes 
    type memArray is array(0 to 4095) of std_logic_vector(7 downto 0);
	
	
	function init_memory return memArray is
    variable temp_mem : memArray := (others => (others => '0'));
	begin	   
    -- Data section:
    -- 0x00000030: variable a = 10 (0x0000000A)
    temp_mem(48) := x"00"; temp_mem(49) := x"00"; temp_mem(50) := x"00"; temp_mem(51) := x"0A";

    -- 0x00000034: variable b = 15 (0x0000000F)
    temp_mem(52) := x"00"; temp_mem(53) := x"00"; temp_mem(54) := x"00"; temp_mem(55) := x"0F";

    -- 0x00000038: variable c (output) = 0 (placeholder)
    temp_mem(56) := x"00"; temp_mem(57) := x"00"; temp_mem(58) := x"00"; temp_mem(59) := x"00";

    return temp_mem;
end function;
	
    signal Memory : memArray := init_memory;

begin

    ------------------------------------------------------------
    --  WRITE Operation (Synchronous)
    ------------------------------------------------------------
    process(clk)
        variable addr : integer;
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                addr := to_integer(unsigned(address));

                -- Store 1 word = 4 bytes
                Memory(addr)     <= WriteData(31 downto 24);
                Memory(addr + 1) <= WriteData(23 downto 16);
                Memory(addr + 2) <= WriteData(15 downto 8);
                Memory(addr + 3) <= WriteData(7 downto 0);
            end if;
        end if;
    end process;

    ------------------------------------------------------------
    --  READ Operation (Asynchronous)
    ------------------------------------------------------------
     process(MemRead, address)
        variable addr : integer;
    begin
        if MemRead = '1' then
            addr := to_integer(unsigned(address));

            ResultData(31 downto 24) <= Memory(addr);
            ResultData(23 downto 16) <= Memory(addr + 1);
            ResultData(15 downto 8)  <= Memory(addr + 2);
            ResultData(7 downto 0)   <= Memory(addr + 3);
        else
            ResultData <= (others => '0');
        end if;
    end process;

end architecture;
