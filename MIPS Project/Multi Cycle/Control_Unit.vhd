library ieee;
use ieee.std_logic_1164.all; 

entity Control_Unit is 
	port(
		clk : in std_logic;
		op : in std_logic_vector(5 downto 0);
		PCWriteCond, PCWrite, IorD, MemRead, Memwrite, MemToReg, IRWrite, ALUSrcA, RegWrite, RegDst: out std_logic; 
		PCSource, ALUOp, ALUSrcB : out std_logic_vector(1 downto 0) 
	);	
end entity;


architecture behav of Control_Unit is 
type cycle is (FETCH, DECODE, EXECUTE, MEM_ACCESS, WRITE_BACK);
signal curr_state : cycle := FETCH;	 

constant R_TYPE :  std_logic_vector(5 downto 0) := "000000";   
constant LW :  std_logic_vector(5 downto 0) := "100011"; 
constant SW :  std_logic_vector(5 downto 0) := "101011"; 
constant BEQ :  std_logic_vector(5 downto 0) := "000100"; 
constant JUMP :  std_logic_vector(5 downto 0) := "000010"; 
constant ADDI :  std_logic_vector(5 downto 0) := "001000"; 
begin 
	
process(clk, op) is
begin 
	if rising_edge(clk) then
		MemRead     <= '0';
	        MemWrite    <= '0';
	        RegWrite    <= '0';
	        ALUSrcA     <= '0';
	        ALUSrcB     <= "00";
	        ALUOp       <= "00";  
		PCSource	<= "00"; 
	        IRWrite     <= '0';
	        PCWrite     <= '0';	  
		IorD        <= '0';
		PCWriteCond <= '0';	 
		MemToReg    <= '0';	
		RegDst      <= '0';
		case (curr_state) is 
			when FETCH => 
				MemRead <= '1';
				IRWrite <= '1';
				ALUSrcB <= "01";
				PCWrite <= '1'; 
				curr_state <= DECODE;
			
			when DECODE => 
				ALUSrcB <= "11";
				curr_state <= EXECUTE;
			
			when EXECUTE =>
				case op is 
					when JUMP =>  --jump 
						PCSource <= "10";
						PCWrite <= '1';
						curr_state <= FETCH;
						
					when BEQ =>  -- beq
						ALUSrcA <= '1';
						ALUOp <= "01";
						PCSource <= "01";
						PCWriteCond <= '1';
						curr_state <= FETCH;
						
					when R_TYPE =>  --R-type
						ALUSrcA <= '1';
						ALUOp <= "10";
						curr_state <= WRITE_BACK;
		
					when LW | SW => --i-type						
						ALUSrcA <= '1';
						ALUSrcB <= "10";
						curr_state <= MEM_ACCESS;
					when ADDI =>  
						ALUSrcA <= '1';
						ALUSrcB <= "10";		   
						curr_state <= WRITE_BACK;
					when others => curr_state <= FETCH;
				end case;
			
			when MEM_ACCESS =>	
				case (op) is 
					when SW =>	--sw
						IorD <= '1';
						MemWrite <= '1';
						curr_state <= FETCH;
					when LW => 	--lw
						IorD <= '1';
						MemRead <= '1';
						curr_state <= WRITE_BACK;
					when others => curr_state <= FETCH; 
				end case;
			
			when WRITE_BACK =>	
				case(op) is 
					when R_TYPE =>  --R-type
						RegDst  <= '1';
						RegWrite <= '1';
						curr_state <= FETCH;
					when LW =>    --lw
						MemToReg <= '1';  
						Regwrite <= '1';
						curr_state <= FETCH;   
					when ADDI =>  	--addi
						RegWrite <= '1';
						curr_state <= FETCH;
					when others => curr_state <= FETCH;
				end case;
		end case;
	end if; 
end process;
	
end architecture;
