library IEEE;
use ieee.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- my Packages
use work.MIPS_Package.all;

entity MIPS_Processor is
    Port (
        clk     : in  std_logic;
        reset     : in  std_logic
    );
end MIPS_Processor;

architecture Behavioral of MIPS_Processor is

	-- Control Unite output Signals
    signal PCWriteCond : std_logic;
	signal PCWrite : std_logic;
	signal IorD : std_logic;
	signal MemRead : std_logic;
	signal Memwrite : std_logic;
	signal MemToReg : std_logic;
	signal IRWrite : std_logic;
	signal ALUSrcA : std_logic;
	signal RegWrite : std_logic;
	signal RegDst : std_logic;
	
	signal PCSource : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(1 downto 0);
	signal ALUSrcB : std_logic_vector(1 downto 0);
	
	--IR output
	signal Op_code: std_logic_vector(31 downto 26);
	signal rs: std_logic_vector(25 downto 21);
	signal rt: std_logic_vector(20 downto 16);
	signal immediate: std_logic_vector(15 downto 0);
	
	signal rd:std_logic_vector(4 downto 0);
	signal funct:std_logic_vector(5 downto 0);
	signal jump_part: std_logic_vector(25 downto 0);
	
	--register files output
	signal ReadData1 :std_logic_vector(31 downto 0); --A
	signal ReadData2 :std_logic_vector(31 downto 0); --B
	
	--register files input
	signal WriteRegister: std_logic_vector(4 downto 0);
	signal WriteData: std_logic_vector(31 downto 0);
	
	-- memory
	signal memory_address : std_logic_vector(31 downto 0);
	signal memory_dataOut : std_logic_vector(31 downto 0); 
	
	-- program counter
	signal PC_in  : std_logic_vector(31 downto 0);
    signal PC_out : std_logic_vector(31 downto 0);
	signal PC_enable : std_logic;	
	
	--RegisterAB
	signal data_A: STD_LOGIC_VECTOR(31 downto 0);
	signal data_B: STD_LOGIC_VECTOR(31 downto 0);
	
	-- ALU , ALU control
	signal alu_inA: STD_LOGIC_VECTOR(31 downto 0);
    signal alu_inB: STD_LOGIC_VECTOR(31 downto 0);
	signal alu_result: STD_LOGIC_VECTOR(31 downto 0);
    signal alu_zero: STD_LOGIC;
	
	signal alu_control_out: STD_LOGIC_VECTOR(2 downto 0);
	
	--ALUOut
	signal alu_out: STD_LOGIC_VECTOR(31 downto 0);
	
	-- memory data register
	signal MDR_out: std_logic_vector(31 downto 0);
	-- Jump Address
	signal jump_address: std_logic_vector(31 downto 0);
	
	-- sign extend
	signal signExtend_out : STD_LOGIC_Vector(31 downto 0);
	signal signExtend_out_shifted : STD_LOGIC_Vector(31 downto 0);
	

begin
	-- Component Instantion
	
	-- control_unite
	control_unite_comopnent : Control_Unit
	port map( clk , Op_code , PCWriteCond, PCWrite, IorD, MemRead, Memwrite, MemToReg, IRWrite, ALUSrcA, RegWrite, RegDst,
	PCSource, ALUOp, ALUSrcB );
	
	-- Program counter 
	PC_component: ProgramCounter
    Port map( clk ,reset , PC_enable ,PC_in ,PC_out );
	
	-- memory
	memory_component: Memory 
	port map( clk , memory_address , data_B , Memwrite , MemRead ,memory_dataOut);

	-- IR_reg
    IR_reg_component: IR_reg
	port map( clk , reset, IRWrite , memory_dataOut , Op_code , rs , rt , immediate);

	-- MDR
	MDR_component: MDR
	port map( clk , memory_dataOut , MDR_out);
	
	--Reg_Files
	Reg_Files_component: Reg_Files
	port map( clk , RegWrite , reset ,rs ,rt , WriteRegister , WriteData, ReadData1 ,ReadData2 );
	
	--sign_extend
	sign_extend_component: sign_extend
	port map( immediate , signExtend_out);
	
	--alu_control
	alu_control_component: alu_control 
	port map( ALUOp , funct	, alu_control_out);
	
	-- alu
	alu_component: alu
    Port map(alu_inA , alu_inB , alu_control_out , alu_result , alu_zero);
	
	--ALUOut
	ALUOut_component :ALUOut 
	port map( clk , alu_result , alu_out);
	
	--RegisterAB
	RegisterAB_component: RegisterAB
    Port map ( clk , ReadData1 , ReadData2 , data_A , data_B); 

	
	-- MUXs
	
	--Memory input Mux
	memMUX : MUX2_1_nBit
	generic map(32)
	port map(a => PC_out , b => alu_out , sel => IorD , output => memory_address);
	
	--write register Mux
	WRMux : MUX2_1_nBit
	generic map(5)
	port map(a => rt  , b => rd , sel => RegDst , output => WriteRegister );
	
	
	--write data in Reg Mux
	WDMux : MUX2_1_nBit
	generic map(32)
	port map(a => alu_out  , b => MDR_out  , sel => MemToReg , output => WriteData );
	
	--ALU MUX ( A )
	ALUMux_A : MUX2_1_nBit
	generic map(32)
	port map(a => PC_out  , b => data_A  , sel => ALUSrcA  , output => alu_inA );
	
	--ALU MUX ( B )
	ALUMux_B : mux4_1 
	port map(a => data_B , b => X"00000004" , c=> signExtend_out , d => signExtend_out_shifted,
	sel => 	ALUSrcB , output => alu_inB );
	
	--PC_in MUX
	PC_in_MUX: Mux3_1 
    Port map( a=> alu_result , b=> alu_out , c=> jump_address , sel=> PCSource , output=> PC_in); 
	
	
	
	
	-- circuits
	PC_enable <= (alu_zero and PCWriteCond) or pcWrite;
	rd <= immediate(15 downto 11);
	funct <= immediate(5 downto 0);
	jump_part <= rs & rt & immediate;
	
	signExtend_out_shifted <= signExtend_out(29 downto 0) & "00";
	jump_address <= pc_out(31 downto 28) & jump_part(25 downto 0 ) & "00"; 

end Behavioral;
