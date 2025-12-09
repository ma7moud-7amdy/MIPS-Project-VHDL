library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit_TB is
end Control_Unit_TB;

architecture behavior of Control_Unit_TB is    									   
    -- Inputs
    signal clk : std_logic := '0';
    signal op : std_logic_vector(5 downto 0) := (others => '0');
    
    -- Outputs
    signal PCWriteCond : std_logic;
    signal PCWrite : std_logic;
    signal IorD : std_logic;
    signal MemRead : std_logic;
    signal MemWrite : std_logic;
    signal MemToReg : std_logic;
    signal IRWrite : std_logic;
    signal ALUSrcA : std_logic;
    signal RegWrite : std_logic;
    signal RegDst : std_logic;
    signal PCSource : std_logic_vector(1 downto 0);
    signal ALUOp : std_logic_vector(1 downto 0);
    signal ALUSrcB : std_logic_vector(1 downto 0);
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
    -- Type to make opcodes more readable
    type opcode_type is (R_TYPE, LW, SW, BEQ, JUMP, ADDI);
    signal curr_opcode : opcode_type;
    
    -- Function to convert opcode type to std_logic_vector
    function get_opcode(op_type : opcode_type) return std_logic_vector is
    begin
        case op_type is
            when R_TYPE => return "000000";
            when LW => return "100011";
            when SW => return "101011";
            when BEQ => return "000100";
            when JUMP => return "000010";
            when ADDI => return "001000";
            when others => return "000000";
        end case;
    end function;
    
begin

    uut: entity Control_Unit port map (
        clk => clk,
        op => op,
        PCWriteCond => PCWriteCond,
        PCWrite => PCWrite,
        IorD => IorD,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemToReg => MemToReg,
        IRWrite => IRWrite,
        ALUSrcA => ALUSrcA,
        RegWrite => RegWrite,
        RegDst => RegDst,
        PCSource => PCSource,
        ALUOp => ALUOp,
        ALUSrcB => ALUSrcB
    );


	clk <= not clk after clk_period/2; 
    
    stim_proc: process
    begin
        
	    -- Test beq instruction	        #tested
        curr_opcode <= BEQ;
        op <= get_opcode(BEQ);
        wait for clk_period * 3.5;
		
		-- Test R-type instruction (add, sub, etc.)	   #tested
        curr_opcode <= R_TYPE;
        op <= get_opcode(R_TYPE);
        wait for clk_period * 4;
        
        -- Test lw instruction			#tested
        curr_opcode <= LW;
        op <= get_opcode(LW);
        wait for clk_period * 5;
        
        -- Test sw instruction		 #tested
        curr_opcode <= SW;
        op <= get_opcode(SW);
        wait for clk_period * 4;
        
        -- Test jump instruction       #tested
        curr_opcode <= JUMP;
        op <= get_opcode(JUMP);
        wait for clk_period * 3;
        
        -- Test addi instruction	   #tested
        curr_opcode <= ADDI;
        op <= get_opcode(ADDI);
        wait for clk_period * 4;
        
        wait;
    end process;
    
end behavior;