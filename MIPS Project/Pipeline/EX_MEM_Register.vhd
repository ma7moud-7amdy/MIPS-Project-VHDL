		  library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX_MEM_Register is
    Port (
        clk   : in std_logic;
        reset : in std_logic;

        -- ******** EX Stage Inputs ********
        RegWrite_EX     : in std_logic;
        MemRead_EX      : in std_logic;
        MemWrite_EX     : in std_logic;
        MemToReg_EX     : in std_logic;
        Branch_EX       : in std_logic;

        branch_address_EX : in std_logic_vector(31 downto 0);
        alu_zero_EX       : in std_logic;
        alu_result_EX     : in std_logic_vector(31 downto 0);

        ReadData2_EX      : in std_logic_vector(31 downto 0);
        WriteRegister_EX  : in std_logic_vector(4 downto 0);

        -- ******** MEM Stage Outputs ********
        RegWrite_MEM     : out std_logic;
        MemRead_MEM      : out std_logic;
        MemWrite_MEM     : out std_logic;
        MemToReg_MEM     : out std_logic;
        Branch_MEM       : out std_logic;

        branch_address_MEM : out std_logic_vector(31 downto 0);
        alu_zero_MEM       : out std_logic;
        alu_result_MEM     : out std_logic_vector(31 downto 0);

        ReadData2_MEM      : out std_logic_vector(31 downto 0);
        WriteRegister_MEM  : out std_logic_vector(4 downto 0)
    );
end EX_MEM_Register;

architecture Behavioral of EX_MEM_Register is

    -- Control registers
    signal RegWrite_r  : std_logic := '0';
    signal MemRead_r   : std_logic := '0';
    signal MemWrite_r  : std_logic := '0';
    signal MemToReg_r  : std_logic := '0';
    signal Branch_r    : std_logic := '0';

    -- Data registers
    signal branch_addr_r : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_zero_r    : std_logic := '0';
    signal alu_result_r  : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadData2_r   : std_logic_vector(31 downto 0) := (others => '0');
    signal WriteReg_r    : std_logic_vector(4 downto 0)  := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            RegWrite_r  <= '0';
            MemRead_r   <= '0';
            MemWrite_r  <= '0';
            MemToReg_r  <= '0';
            Branch_r    <= '0';

            branch_addr_r <= (others => '0');
            alu_zero_r    <= '0';
            alu_result_r  <= (others => '0');
            ReadData2_r   <= (others => '0');
            WriteReg_r    <= (others => '0');

        elsif rising_edge(clk) then
            RegWrite_r  <= RegWrite_EX;
            MemRead_r   <= MemRead_EX;
            MemWrite_r  <= MemWrite_EX;
            MemToReg_r  <= MemToReg_EX;
            Branch_r    <= Branch_EX;

            branch_addr_r <= branch_address_EX;
            alu_zero_r    <= alu_zero_EX;
            alu_result_r  <= alu_result_EX;
            ReadData2_r   <= ReadData2_EX;
            WriteReg_r    <= WriteRegister_EX;
        end if;
    end process;

    -- Outputs
    RegWrite_MEM       <= RegWrite_r;
    MemRead_MEM        <= MemRead_r;
    MemWrite_MEM       <= MemWrite_r;
    MemToReg_MEM       <= MemToReg_r;
    Branch_MEM         <= Branch_r;

    branch_address_MEM <= branch_addr_r;
    alu_zero_MEM       <= alu_zero_r;
    alu_result_MEM     <= alu_result_r;
    ReadData2_MEM      <= ReadData2_r;
    WriteRegister_MEM  <= WriteReg_r;

end Behavioral;
