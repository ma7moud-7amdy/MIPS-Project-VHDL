library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_Files_tb is
end entity;

architecture tb of Reg_Files_tb is
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal RegWrite      : std_logic := '0';
    signal ReadRegister1 : std_logic_vector(4 downto 0) := (others => '0');
    signal ReadRegister2 : std_logic_vector(4 downto 0) := (others => '0');
    signal WriteRegister : std_logic_vector(4 downto 0) := (others => '0');
    signal WriteData     : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadData1     : std_logic_vector(31 downto 0);
    signal ReadData2     : std_logic_vector(31 downto 0);

begin
    DUT: entity Reg_Files
        port map (
            clk => clk,
            reset => reset,
            RegWrite => RegWrite,
            ReadRegister1 => ReadRegister1,
            ReadRegister2 => ReadRegister2,
            WriteRegister => WriteRegister,
            WriteData => WriteData,
            ReadData1 => ReadData1,
            ReadData2 => ReadData2
        );

    clk <= not clk after 10 ns;

    process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        WriteRegister <= "00101"; 
        WriteData <= x"12345678";
        RegWrite <= '1';
        wait for 20 ns;
        RegWrite <= '0';

        ReadRegister1 <= "00101";  
        ReadRegister2 <= "00000";  
        wait for 20 ns;

       
        WriteRegister <= "00000";
        WriteData <= x"FFFFFFFF";
        RegWrite <= '1';
        wait for 20 ns;
        RegWrite <= '0';

       
        ReadRegister1 <= "00000";
        wait for 20 ns;

        wait;
    end process;

end architecture;
