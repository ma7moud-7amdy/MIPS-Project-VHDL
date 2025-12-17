library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX_Register is
    Port (
        clk   : in std_logic;
        reset : in std_logic;

        RegDst_ID      : in std_logic;
        RegWrite_ID    : in std_logic;
        ALUSrc_ID      : in std_logic;
        ALUOp_ID       : in std_logic_vector(1 downto 0);
        MemRead_ID     : in std_logic;
        MemWrite_ID    : in std_logic;
        MemToReg_ID    : in std_logic;
        Branch_ID      : in std_logic;

        PC_4_ID        : in std_logic_vector(31 downto 0);
        ReadData1_ID   : in std_logic_vector(31 downto 0);
        ReadData2_ID   : in std_logic_vector(31 downto 0);
        signExtend_out_ID : in std_logic_vector(31 downto 0);

        rt_ID          : in std_logic_vector(4 downto 0);
        rd_ID          : in std_logic_vector(4 downto 0);

        RegDst_EX      : out std_logic;
        RegWrite_EX    : out std_logic;
        ALUSrc_EX      : out std_logic;
        ALUOp_EX       : out std_logic_vector(1 downto 0);
        MemRead_EX     : out std_logic;
        MemWrite_EX    : out std_logic;
        MemToReg_EX    : out std_logic;
        Branch_EX      : out std_logic;

        PC_4_EX        : out std_logic_vector(31 downto 0);
        ReadData1_EX   : out std_logic_vector(31 downto 0);
        ReadData2_EX   : out std_logic_vector(31 downto 0);
        signExtend_out_EX : out std_logic_vector(31 downto 0);

        rt_EX          : out std_logic_vector(4 downto 0);
        rd_EX          : out std_logic_vector(4 downto 0)
    );
end ID_EX_Register;

architecture Behavioral of ID_EX_Register is

    signal RegDst_r    : std_logic := '0';
    signal RegWrite_r  : std_logic := '0';
    signal ALUSrc_r    : std_logic := '0';
    signal ALUOp_r     : std_logic_vector(1 downto 0) := (others => '0');
    signal MemRead_r   : std_logic := '0';
    signal MemWrite_r  : std_logic := '0';
    signal MemToReg_r  : std_logic := '0';
    signal Branch_r    : std_logic := '0';

    signal PC_4_r        : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadData1_r   : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadData2_r   : std_logic_vector(31 downto 0) := (others => '0');
    signal signExt_r     : std_logic_vector(31 downto 0) := (others => '0');

    signal rt_r          : std_logic_vector(4 downto 0)  := (others => '0');
    signal rd_r          : std_logic_vector(4 downto 0)  := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            RegDst_r    <= '0';
            RegWrite_r  <= '0';
            ALUSrc_r    <= '0';
            ALUOp_r     <= (others => '0');
            MemRead_r   <= '0';
            MemWrite_r  <= '0';
            MemToReg_r  <= '0';
            Branch_r    <= '0';

            PC_4_r      <= (others => '0');
            ReadData1_r <= (others => '0');
            ReadData2_r <= (others => '0');
            signExt_r   <= (others => '0');

            rt_r        <= (others => '0');
            rd_r        <= (others => '0');

        elsif rising_edge(clk) then
            RegDst_r    <= RegDst_ID;
            RegWrite_r  <= RegWrite_ID;
            ALUSrc_r    <= ALUSrc_ID;
            ALUOp_r     <= ALUOp_ID;
            MemRead_r   <= MemRead_ID;
            MemWrite_r  <= MemWrite_ID;
            MemToReg_r  <= MemToReg_ID;
            Branch_r    <= Branch_ID;

            PC_4_r      <= PC_4_ID;
            ReadData1_r <= ReadData1_ID;
            ReadData2_r <= ReadData2_ID;
            signExt_r   <= signExtend_out_ID;

            rt_r        <= rt_ID;
            rd_r        <= rd_ID;
        end if;
    end process;

    RegDst_EX         <= RegDst_r;
    RegWrite_EX       <= RegWrite_r;
    ALUSrc_EX         <= ALUSrc_r;
    ALUOp_EX          <= ALUOp_r;
    MemRead_EX        <= MemRead_r;
    MemWrite_EX       <= MemWrite_r;
    MemToReg_EX       <= MemToReg_r;
    Branch_EX         <= Branch_r;

    PC_4_EX           <= PC_4_r;
    ReadData1_EX      <= ReadData1_r;
    ReadData2_EX      <= ReadData2_r;
    signExtend_out_EX <= signExt_r;

    rt_EX             <= rt_r;
    rd_EX             <= rd_r;

end Behavioral;
