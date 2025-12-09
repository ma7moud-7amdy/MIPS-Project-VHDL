library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM_WB_Register is
    Port (
        clk   : in std_logic;
        reset : in std_logic;

        -- ******** MEM Stage Inputs ********
        RegWrite_MEM     : in std_logic;
        MemToReg_MEM     : in std_logic;

        DMEM_dataOut_MEM : in std_logic_vector(31 downto 0);
        alu_result_MEM   : in std_logic_vector(31 downto 0);
        WriteRegister_MEM: in std_logic_vector(4 downto 0);

        -- ******** WB Stage Outputs ********
        RegWrite_WB      : out std_logic;
        MemToReg_WB      : out std_logic;

        DMEM_dataOut_WB  : out std_logic_vector(31 downto 0);
        alu_result_WB    : out std_logic_vector(31 downto 0);
        WriteRegister_WB : out std_logic_vector(4 downto 0)
    );
end MEM_WB_Register;

architecture Behavioral of MEM_WB_Register is

    -- Registers to hold the values
    signal RegWrite_r, MemToReg_r : std_logic;

    signal DMEM_data_r   : std_logic_vector(31 downto 0);
    signal alu_result_r  : std_logic_vector(31 downto 0);
    signal WriteReg_r    : std_logic_vector(4 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then

            RegWrite_r     <= '0';
            MemToReg_r     <= '0';

            DMEM_data_r    <= (others => '0');
            alu_result_r   <= (others => '0');
            WriteReg_r     <= (others => '0');

        elsif rising_edge(clk) then

            RegWrite_r     <= RegWrite_MEM;
            MemToReg_r     <= MemToReg_MEM;

            DMEM_data_r    <= DMEM_dataOut_MEM;
            alu_result_r   <= alu_result_MEM;
            WriteReg_r     <= WriteRegister_MEM;

        end if;
    end process;

    -- Outputs to WB stage
    RegWrite_WB      <= RegWrite_r;
    MemToReg_WB      <= MemToReg_r;

    DMEM_dataOut_WB  <= DMEM_data_r;
    alu_result_WB    <= alu_result_r;
    WriteRegister_WB <= WriteReg_r;

end Behavioral;
 