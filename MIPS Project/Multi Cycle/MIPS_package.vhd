library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package MIPS_Package is
	
    -- Component declarations
		
	--MUX2_1_nBit
	component MUX2_1_nBit is
	generic( n : integer);
	port(
		a : in STD_LOGIC_VECTOR(n-1 downto 0);
		b : in STD_LOGIC_VECTOR(n-1 downto 0);
		sel : in STD_LOGIC;
		output : out STD_LOGIC_VECTOR(n-1 downto 0)
	);
	end component;
	
	--mux4_1
	component mux4_1 is
	port(
		a : in STD_LOGIC_VECTOR(31 downto 0);
		b : in STD_LOGIC_VECTOR(31 downto 0);
		c : in STD_LOGIC_VECTOR(31 downto 0);
		d : in STD_LOGIC_VECTOR(31 downto 0);
		sel : in STD_LOGIC_VECTOR(1 downto 0);
		output : out STD_LOGIC_VECTOR(31 downto 0)
	);
	end component;
	
	--MUX3_1
	component Mux3_1 is
    Port (
        a  : in  STD_LOGIC_VECTOR(31 downto 0);
        b  : in  STD_LOGIC_VECTOR(31 downto 0);
        c  : in  STD_LOGIC_VECTOR(31 downto 0);
		sel: in  STD_LOGIC_VECTOR(1 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
	end component;
		
	-- IR_reg
    component IR_reg is
	port (
		clk,reset,enable: in std_logic;
		IR_in   : in std_logic_vector(31 downto 0);
		Op_code: out std_logic_vector(31 downto 26);
		rs: out std_logic_vector(25 downto 21);
		rt: out std_logic_vector(20 downto 16);
		immediate: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--ProgramCounter
	component ProgramCounter is
    Port (
        clk    : in  std_logic;
        reset    : in  std_logic;
        PCWrite: in  std_logic;
        PC_in  : in  std_logic_vector(31 downto 0);
        PC_out : out std_logic_vector(31 downto 0)
    );
	end component;
	
	--alu_control
	component alu_control is
	port(
		ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
		funct : in STD_LOGIC_VECTOR(5 downto 0);
		ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
	);
	end component;
	
	-- alu
	component alu is
    Port (
        A_Res     : in  STD_LOGIC_VECTOR(31 downto 0);
        B_Res      : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0);
        result     : out STD_LOGIC_VECTOR(31 downto 0);
        zero       : out STD_LOGIC
    );
	end component;
	
	--ALUOut
	component ALUOut is
	port (
		clk : in std_logic;
		reg_in   : in std_logic_vector(31 downto 0);
		reg_out  : out std_logic_vector(31 downto 0)
		);
	end component;
	
	-- MDR
	component MDR is
	port (
		clk : in std_logic;
		reg_in   : in std_logic_vector(31 downto 0);
		reg_out  : out std_logic_vector(31 downto 0)
		);
	end component;
	
	--sign_extend
	component sign_extend is
	port(
	input : in STD_LOGIC_Vector(15 downto 0):="1000000011111111";
	output : out STD_LOGIC_Vector(31 downto 0)
	);
	end component;
	
	-- shift_left
	component shift_left is
	port(
	    input : in STD_LOGIC_VECTOR(31 downto 0);  
		output : out STD_LOGIC_VECTOR(31 downto 0)
	);
	end component;
	
	--Reg_Files
	component Reg_Files is
	port (
		clk,RegWrite,reset: in std_logic;
		ReadRegister1,ReadRegister2,WriteRegister: in std_logic_vector(4 downto 0);
		
		WriteData: in std_logic_vector(31 downto 0);
		ReadData1,ReadData2: out std_logic_vector(31 downto 0)
		);
	end component;
	
	--RegisterAB
	component RegisterAB is
    Port (
        clk    : in STD_LOGIC;
        AIn    : in STD_LOGIC_VECTOR(31 downto 0);
        BIn    : in STD_LOGIC_VECTOR(31 downto 0);
        AOut   : out STD_LOGIC_VECTOR(31 downto 0);
        BOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
	end component;
	
	-- Memory
	component Memory is 
	port (
        clk: in std_logic;
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0);
        MemWrite : in std_logic;
        MemRead : in std_logic;
        dataOut : out std_logic_vector(31 downto 0)
	);				   			   
	end component;
	
	-- Control_Unit
	component Control_Unit is 
	port(
		clk : in std_logic;
		op : in std_logic_vector(5 downto 0);
		PCWriteCond, PCWrite, IorD, MemRead, Memwrite, MemToReg, IRWrite, ALUSrcA, RegWrite, RegDst: out std_logic; 
		PCSource, ALUOp, ALUSrcB : out std_logic_vector(1 downto 0) 
	);	
	end component;
	
	

end package;
