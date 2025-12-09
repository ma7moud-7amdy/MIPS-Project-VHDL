library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity MIPS_Processor_SC is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end MIPS_Processor_SC;

architecture Behavioral of MIPS_Processor_SC is	 


    -- Control Unit output Signals
    signal RegDst   : std_logic;
    signal RegWrite : std_logic;
    signal ALUSrc   : std_logic;
    signal ALUOp    : std_logic_vector(1 downto 0);
    signal MemRead  : std_logic;
    signal MemWrite : std_logic;
    signal MemToReg : std_logic;
    signal Branch   : std_logic;
    signal Jump     : std_logic;

    -- Instruction fields
	signal instruction  : std_logic_vector(31 downto 0);
    signal opcode  : std_logic_vector(5 downto 0);
    signal rs       : std_logic_vector(4 downto 0);
    signal rt       : std_logic_vector(4 downto 0);
    signal rd       : std_logic_vector(4 downto 0);
    signal immediate: std_logic_vector(15 downto 0);
    signal funct    : std_logic_vector(5 downto 0);
    signal jump_part: std_logic_vector(25 downto 0);

    -- Register Files output
    signal ReadData1 : std_logic_vector(31 downto 0);
    signal ReadData2 : std_logic_vector(31 downto 0);

    -- Register Files input
    signal WriteRegister : std_logic_vector(4 downto 0);
    signal WriteData     : std_logic_vector(31 downto 0);

    -- DataMemory
    signal DMEM_dataOut : std_logic_vector(31 downto 0);

    -- Program Counter
    signal PC_in  : std_logic_vector(31 downto 0);
    signal PC_out : std_logic_vector(31 downto 0);

    -- ALU
    signal alu_inB       : std_logic_vector(31 downto 0);
    signal alu_result    : std_logic_vector(31 downto 0);
    signal alu_zero      : std_logic;
    signal alu_control_out: std_logic_vector(3 downto 0);

    -- Sign Extend
    signal signExtend_out : std_logic_vector(31 downto 0);
    signal signExtend_shifted : std_logic_vector(31 downto 0);

    --Branching
	signal PC_4  : std_logic_vector(31 downto 0);
	signal branch_address  : std_logic_vector(31 downto 0);
	signal branch_MUX_output  : std_logic_vector(31 downto 0);
	signal branch_MUX_control   : std_logic;
	-- Jump Address
    signal jump_address : std_logic_vector(31 downto 0);

begin

    --Instruction Decode
	
	opcode   <= instruction(31 downto 26);
    rs        <= instruction(25 downto 21);
    rt        <= instruction(20 downto 16);
    rd        <= instruction(15 downto 11);
    immediate <= instruction(15 downto 0);
    funct     <= instruction(5 downto 0);
    jump_part <= instruction(25 downto 0);	  
	
	-- Component Instantiations	
    -- Control Unit
    control_unit_component: entity work.Control_Unit
        port map(
            opcode   => opcode,
            RegDst   => RegDst,
            RegWrite => RegWrite,
            ALUSrc   => ALUSrc,
            ALUOp    => ALUOp,
            MemRead  => MemRead,
            MemWrite => MemWrite,
            MemToReg => MemToReg,
            Branch   => Branch,
            Jump     => Jump
        );

    -- Program Counter
    PC_component:entity work.ProgramCounter
        port map(
            clk    => clk,
            reset  => reset,
            PC_in  => PC_in,
            PC_out => PC_out
        );

    --Instruction Memory
    Instruction_memory_component:entity work.InstructionMemory
        port map(
            address     => PC_out,
            instruction => instruction
        );

    -- Register File
    Reg_Files_component:entity work.Reg_Files
        port map(
            clk   => clk,
            RegWrite => RegWrite,
            reset => reset,
            ReadRegister1    => rs,
            ReadRegister2    => rt,
            WriteRegister    => WriteRegister,
            WriteData => WriteData,
            ReadData1 => ReadData1,
            ReadData2 => ReadData2
        );
		
		
		-- ALU Control
    alu_control_component:entity work.ALU_Control
        port map(
            ALUOp      => ALUOp,
            Funct      => funct,
            ALUControl => alu_control_out
        );

    -- ALU
    alu_component:entity work.ALU
        port map(
            A         => ReadData1,
            B         => alu_inB,
            ALUControl=> alu_control_out,
            Result    => alu_result,
            Zero      => alu_zero
        ); 
		
	-- DataMemory	
	Data_memory_component:entity work.DataMemory 
	    port map (
	        clk	 => clk,
	        address	 => alu_result,
	        WriteData => ReadData2,
	        MemWrite =>	 MemWrite,
	        MemRead	 =>	 MemRead,
	
	        ResultData => DMEM_dataOut
	    );

		

    -- Sign Extend
    sign_extend_component:entity work.sign_extend
        port map(
            input  => immediate,
            output => signExtend_out
        );

    signExtend_shifted <= signExtend_out(29 downto 0) & "00";
	
	
    

    -- MUXs

    -- Write Register Mux
    WRMux:entity work.MUX2_1_nBit
        generic map(5)
        port map(
            a   => rt,
            b   => rd,
            sel => RegDst,
            output => WriteRegister
        );

    -- Write Back Mux (Reg)
    WBMux:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => alu_result,
            b   => DMEM_dataOut,
            sel => MemToReg,
            output => WriteData
        );

    -- ALU Mux (B)
    ALUMux_B:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => ReadData2,
            b   => signExtend_out,
            sel => ALUSrc,
            output => alu_inB
        );
		
	   
	-- Branch
	-- add (pc+4) + (offset * 4)
	branch_adder:entity work.Add_32bit
		port map(
            a => PC_4,
        	b => signExtend_shifted ,
        	result => branch_address
        ); 
		
	-- branch and circuit
	andcircuit:entity work.And_1bit
		port map(
			a => Branch,
			b => alu_zero,
			output => branch_MUX_control 
		);
	
	-- branch MUX
    branchMux:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => PC_4,
            b   => branch_address,
            sel => branch_MUX_control,
            output => branch_MUX_output
        );
		
	-- PC update (pc+4)
	PC_adder:entity work.Add_32bit
		port map(
            a => PC_out,
        	b => X"00000004" ,
        	result => PC_4
        );
	
   	-- Jump Address Calculation
	jump_address <= PC_4(31 downto 28) & instruction(25 downto 0 ) & "00";   
	--
		
    -- jump MUX
    jump_MUX:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => branch_MUX_output,  -- PC + 4 or branch
            b   => jump_address,
            sel => Jump,
            output => PC_in
        );

end Behavioral;