library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity MIPS_Processor_pipeline is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end MIPS_Processor_pipeline;

architecture Behavioral of MIPS_Processor_pipeline is

	-- ===============================
	-- CONTROL SIGNALS (ID Stage)
	-- ===============================
	signal RegDst_ID    : std_logic := '0';
	signal RegWrite_ID  : std_logic:= '0';
	signal ALUSrc_ID    : std_logic:= '0';
	signal ALUOp_ID     : std_logic_vector(1 downto 0) := (others => '0');
	signal MemRead_ID   : std_logic:= '0';
	signal MemWrite_ID  : std_logic:= '0';
	signal MemToReg_ID  : std_logic:= '0';
	signal Branch_ID    : std_logic:= '0';
	signal Jump : std_logic:= '0';
	
	
	-- ===============================
	-- CONTROL SIGNALS (EX Stage)
	-- ===============================
	signal RegDst_EX    : std_logic:= '0';
	signal RegWrite_EX  : std_logic:= '0';
	signal ALUSrc_EX    : std_logic:= '0';
	signal ALUOp_EX     : std_logic_vector(1 downto 0):= (others => '0');
	signal MemRead_EX   : std_logic:= '0';
	signal MemWrite_EX  : std_logic:= '0';
	signal MemToReg_EX  : std_logic:= '0';
	signal Branch_EX    : std_logic:= '0';
	
	
	-- ===============================
	-- CONTROL SIGNALS (MEM Stage)
	-- ===============================
	signal RegWrite_MEM : std_logic:= '0';
	signal MemRead_MEM  : std_logic:= '0';
	signal MemWrite_MEM : std_logic:= '0';
	signal MemToReg_MEM : std_logic:= '0';
	signal Branch_MEM   : std_logic:= '0';
	
	
	-- ===============================
	-- CONTROL SIGNALS (WB Stage)
	-- ===============================
	signal RegWrite_WB  : std_logic:= '0';
	signal MemToReg_WB  : std_logic:= '0';
	

    -- Instruction fields
	signal instruction_IF  : std_logic_vector(31 downto 0):= (others => '0');
	signal instruction_ID  : std_logic_vector(31 downto 0):= (others => '0');
    signal opcode  : std_logic_vector(5 downto 0);
    signal rs       : std_logic_vector(4 downto 0);
    signal rt_ID       : std_logic_vector(4 downto 0);
	signal rt_EX       : std_logic_vector(4 downto 0);
    signal rd_ID       : std_logic_vector(4 downto 0);
	signal rd_EX       : std_logic_vector(4 downto 0);
    signal immediate: std_logic_vector(15 downto 0);
    signal funct    : std_logic_vector(5 downto 0);

    -- Register Files output
    signal ReadData1_ID : std_logic_vector(31 downto 0);
	signal ReadData1_EX : std_logic_vector(31 downto 0);
	signal ReadData2_ID : std_logic_vector(31 downto 0);
    signal ReadData2_EX : std_logic_vector(31 downto 0);
	signal ReadData2_MEM : std_logic_vector(31 downto 0);
	
    -- Register Files input
    signal WriteRegister_EX : std_logic_vector(4 downto 0);
	signal WriteRegister_MEM : std_logic_vector(4 downto 0);
	signal WriteRegister_WB : std_logic_vector(4 downto 0);
    signal WriteData     : std_logic_vector(31 downto 0);

    -- DataMemory
    signal DMEM_dataOut_MEM : std_logic_vector(31 downto 0);
	signal DMEM_dataOut_WB : std_logic_vector(31 downto 0);

    -- Program Counter
    signal PC_in  : std_logic_vector(31 downto 0):= (others => '0');
    signal PC_out : std_logic_vector(31 downto 0):= (others => '0');

    -- ALU
    signal alu_inB       : std_logic_vector(31 downto 0);
    signal alu_result_EX    : std_logic_vector(31 downto 0);
	signal alu_result_MEM    : std_logic_vector(31 downto 0);
	signal alu_result_WB    : std_logic_vector(31 downto 0);
    signal alu_zero_EX      : std_logic;
	signal alu_zero_MEM      : std_logic;
    signal alu_control_out: std_logic_vector(3 downto 0);

    -- Sign Extend
    signal signExtend_out_ID : std_logic_vector(31 downto 0);
    signal signExtend_out_EX : std_logic_vector(31 downto 0);
	signal signExtend_shifted : std_logic_vector(31 downto 0);

    --Branching
	signal PC_4_IF  : std_logic_vector(31 downto 0):=(others => '0');
	signal PC_4_ID  : std_logic_vector(31 downto 0):=(others => '0');
	signal PC_4_EX  : std_logic_vector(31 downto 0):=(others => '0');
	signal branch_address_EX  : std_logic_vector(31 downto 0);
	signal branch_address_MEM  : std_logic_vector(31 downto 0);
	signal branch_MUX_control   : std_logic := '0';
	-- Jump Address
    signal jump_address : std_logic_vector(31 downto 0);
	signal jump_mux_out : std_logic_vector(31 downto 0);

begin

    --Instruction Decode
	
	opcode   <= instruction_ID(31 downto 26);
    rs        <= instruction_ID(25 downto 21);
    rt_ID        <= instruction_ID(20 downto 16);
    rd_ID        <= instruction_ID(15 downto 11);
    immediate <= instruction_ID(15 downto 0);
	funct <= signExtend_out_EX(5 downto 0);		  --- 21 to 16 
	
	-- Component Instantiations	
    -- Control Unit
    control_unit_component: entity work.Control_Unit
        port map(
            opcode   => opcode,
            RegDst   => RegDst_ID,
            RegWrite => RegWrite_ID,
            ALUSrc   => ALUSrc_ID,
            ALUOp    => ALUOp_ID,
            MemRead  => MemRead_ID,
            MemWrite => MemWrite_ID,
            MemToReg => MemToReg_ID,
            Branch   => Branch_ID,
            Jump     => Jump
        );
		
	-- IF_ID_Register
	IF_ID_Reg : entity work.IF_ID_Register
    port map(
        clk            => clk,
        reset          => reset,
        PC_4_IF        => PC_4_IF,
        instruction_IF => instruction_IF,
        PC_4_ID        => PC_4_ID,
        instruction_ID => instruction_ID
    );
	
	-- ID_EX_Register
	ID_EX_Reg : entity work.ID_EX_Register
    port map(
        clk           => clk,
        reset         => reset,

        RegDst_ID     => RegDst_ID,
        RegWrite_ID   => RegWrite_ID,
        ALUSrc_ID     => ALUSrc_ID,
        ALUOp_ID      => ALUOp_ID,
        MemRead_ID    => MemRead_ID,
        MemWrite_ID   => MemWrite_ID,
        MemToReg_ID   => MemToReg_ID,
        Branch_ID     => Branch_ID,

        PC_4_ID       => PC_4_ID,
        ReadData1_ID  => ReadData1_ID,
        ReadData2_ID  => ReadData2_ID,
        signExtend_out_ID => signExtend_out_ID,
        rt_ID         => rt_ID,
        rd_ID         => rd_ID,

        RegDst_EX     => RegDst_EX,
        RegWrite_EX   => RegWrite_EX,
        ALUSrc_EX     => ALUSrc_EX,
        ALUOp_EX      => ALUOp_EX,
        MemRead_EX    => MemRead_EX,
        MemWrite_EX   => MemWrite_EX,
        MemToReg_EX   => MemToReg_EX,
        Branch_EX     => Branch_EX,

        PC_4_EX       => PC_4_EX,
        ReadData1_EX  => ReadData1_EX,
        ReadData2_EX  => ReadData2_EX,
        signExtend_out_EX => signExtend_out_EX,
        rt_EX         => rt_EX,
        rd_EX         => rd_EX
    );
	
	-- EX_MEM_Register
	EX_MEM_Reg : entity work.EX_MEM_Register
    port map(
        clk  => clk,
        reset => reset,

        RegWrite_EX => RegWrite_EX,
        MemRead_EX  => MemRead_EX,
        MemWrite_EX => MemWrite_EX,
        MemToReg_EX => MemToReg_EX,
        Branch_EX   => Branch_EX,

        branch_address_EX => branch_address_EX,
        alu_zero_EX       => alu_zero_EX,
        alu_result_EX     => alu_result_EX,
        ReadData2_EX      => ReadData2_EX,
        WriteRegister_EX  => WriteRegister_EX,

        RegWrite_MEM => RegWrite_MEM,
        MemRead_MEM  => MemRead_MEM,
        MemWrite_MEM => MemWrite_MEM,
        MemToReg_MEM => MemToReg_MEM,
        Branch_MEM   => Branch_MEM,

        branch_address_MEM => branch_address_MEM,
        alu_zero_MEM       => alu_zero_MEM,
        alu_result_MEM     => alu_result_MEM,
        ReadData2_MEM      => ReadData2_MEM,
        WriteRegister_MEM  => WriteRegister_MEM
    );
	
	--MEM_WB_Register
	MEM_WB_Reg : entity work.MEM_WB_Register
    port map(
        clk  => clk,
        reset => reset,

        RegWrite_MEM => RegWrite_MEM,
        MemToReg_MEM => MemToReg_MEM,

        DMEM_dataOut_MEM => DMEM_dataOut_MEM,
        alu_result_MEM   => alu_result_MEM,
        WriteRegister_MEM=> WriteRegister_MEM,

        RegWrite_WB => RegWrite_WB,
        MemToReg_WB => MemToReg_WB,

        DMEM_dataOut_WB => DMEM_dataOut_WB,
        alu_result_WB   => alu_result_WB,
        WriteRegister_WB=> WriteRegister_WB
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
            instruction => instruction_IF
        );

    -- Register File
    Reg_Files_component:entity work.Reg_Files
        port map(
            clk   => clk,
            RegWrite => RegWrite_WB,
            reset => reset,
            ReadRegister1    => rs,
            ReadRegister2    => rt_ID,
            WriteRegister    => WriteRegister_WB,
            WriteData => WriteData,
            ReadData1 => ReadData1_ID,
            ReadData2 => ReadData2_ID
        );
		
		
		-- ALU Control
    alu_control_component:entity work.ALU_Control
        port map(
            ALUOp      => ALUOp_EX,
            Funct      => funct,
            ALUControl => alu_control_out
        );

    -- ALU
    alu_component:entity work.ALU
        port map(
            A         => ReadData1_EX,
            B         => alu_inB,
            ALUControl=> alu_control_out,
            Result    => alu_result_EX,
            Zero      => alu_zero_EX
        ); 
		
	-- DataMemory	
	Data_memory_component:entity work.DataMemory 
	    port map (
	        clk	 => clk,
	        address	 => alu_result_MEM,
	        WriteData => ReadData2_MEM,
	        MemWrite =>	 MemWrite_MEM,
	        MemRead	 =>	 MemRead_MEM,
	
	        ResultData => DMEM_dataOut_MEM
	    );

		

    -- Sign Extend
    sign_extend_component:entity work.sign_extend
        port map(
            input  => immediate,
            output => signExtend_out_ID
        );

    signExtend_shifted <= signExtend_out_EX(29 downto 0) & "00";
	
	
    

    -- MUXs

    -- Write Register Mux
    WRMux:entity work.MUX2_1_nBit
        generic map(5)
        port map(
            a   => rt_EX,
            b   => rd_EX,
            sel => RegDst_EX,
            output => WriteRegister_EX
        ); 
		
		

    -- Write Back Mux (Reg)
    WBMux:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => alu_result_WB,
            b   => DMEM_dataOut_WB,
            sel => MemToReg_WB,
            output => WriteData
        );
		
	

    -- ALU Mux (B)
    ALUMux_B:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => ReadData2_EX,
            b   => signExtend_out_EX,	
            sel => ALUSrc_EX,
            output => alu_inB
        );
	   
	-- Branch
	-- add (pc+4) + (offset * 4)
	branch_adder:entity work.Add_32bit
		port map(
            a => PC_4_EX,
        	b => signExtend_shifted ,
        	result => branch_address_EX
        ); 
		
	-- branch and circuit
	andcircuit:entity work.And_1bit
		port map(
			a => Branch_MEM,
			b => alu_zero_MEM,
			output => branch_MUX_control 
		);
						   
	-- branch MUX
    branchMux:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => jump_mux_out,
            b   => branch_address_MEM,
            sel => branch_MUX_control,
            output => PC_in
        );
		
	-- PC update (pc+4)
	PC_adder:entity work.Add_32bit
		port map(
            a => PC_out,
        	b => X"00000004" ,
        	result => PC_4_IF
        );
	
   	-- Jump Address Calculation
	jump_address <= PC_4_ID(31 downto 28) & instruction_ID(25 downto 0 ) & "00";   
	--
		
    -- jump MUX
    jump_MUX:entity work.MUX2_1_nBit
        generic map(32)
        port map(
            a   => PC_4_IF,  -- PC + 4 or branch
            b   => jump_address,
            sel => Jump,
            output => jump_mux_out
        );

end Behavioral;
