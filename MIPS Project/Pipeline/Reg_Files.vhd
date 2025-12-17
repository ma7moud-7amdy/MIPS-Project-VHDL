library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_Files is
    port (
        clk, RegWrite, reset : in std_logic;
        ReadRegister1, ReadRegister2, WriteRegister : in std_logic_vector(4 downto 0);
        WriteData : in std_logic_vector(31 downto 0);
        ReadData1, ReadData2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Reg_Files is

    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));

begin

    -- Write process: Rising edge (first half of cycle)
    -- Writes to register array on rising clock edge
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all registers to zero
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            -- Write only if RegWrite is enabled
            if RegWrite = '1' then
                -- Don't write to register $0 (hardwired to zero in MIPS)
                if WriteRegister /= "00000" then
                    registers(to_integer(unsigned(WriteRegister))) <= WriteData;
                end if;
            end if;
        end if;
    end process;

    -- Read process: COMBINATIONAL with BYPASS/FORWARDING
    -- Allows reading the value being written in the same cycle (zero delay)
    -- This implements internal forwarding within the register file
    process(registers, ReadRegister1, ReadRegister2, RegWrite, WriteRegister, WriteData)
    begin
        -- Read Port 1 with bypass logic
        -- If we're writing to the same register we're reading, forward the write data
        if (RegWrite = '1' and WriteRegister = ReadRegister1 and WriteRegister /= "00000") then
            -- BYPASS PATH: Forward write data directly to read port
            ReadData1 <= WriteData;
        else
            -- NORMAL PATH: Read from register array
            ReadData1 <= registers(to_integer(unsigned(ReadRegister1)));
        end if;
        
        -- Read Port 2 with bypass logic
        -- Same forwarding logic for second read port
        if (RegWrite = '1' and WriteRegister = ReadRegister2 and WriteRegister /= "00000") then
            -- BYPASS PATH: Forward write data directly to read port
            ReadData2 <= WriteData;
        else
            -- NORMAL PATH: Read from register array
            ReadData2 <= registers(to_integer(unsigned(ReadRegister2)));
        end if;
    end process;

end architecture;