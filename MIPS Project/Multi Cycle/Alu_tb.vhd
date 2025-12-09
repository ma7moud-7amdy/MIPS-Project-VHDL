-------------------------------------------------------------------------------
--
-- Title       : ALU_Testbench
-- Design      : ALU
-- Author      : Dell
-- Company     : student
--
-------------------------------------------------------------------------------
--
-- File        : C:/My_Designs/hardware/ALU/src/ALU_Testbench.vhd
-- Generated   : Fri May  2 20:24:02 2025
-- From        : Interface description file
-- By          : ItfToHdl ver. 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--    and may be overwritten
--{entity {ALU_Testbench} architecture {Behavioral}}
 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU_Testbench is
end ALU_Testbench;

--}} End of automatically maintained section

architecture Behavioral of ALU_Testbench is
  -- Component declarations
    component alu is
        Port (
            A_Res      : in  STD_LOGIC_VECTOR(31 downto 0);
            B_Res      : in  STD_LOGIC_VECTOR(31 downto 0);
            ALUControl : in  STD_LOGIC_VECTOR(2 downto 0);
            result     : out STD_LOGIC_VECTOR(31 downto 0);
            zero       : out STD_LOGIC
        );
    end component;

    signal A_Res      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal B_Res      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALUControl : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');
    signal result     : STD_LOGIC_VECTOR(31 downto 0);
    signal zero       : STD_LOGIC;

begin

    -- DUT
    uut: alu port map (
        A_Res  => A_Res,
        B_Res  => B_Res,
        ALUControl => ALUControl,
        result => result,
        zero => zero
    );

    -- Stimulus
    process
    begin
-- ADD: 5 + 3
        A_Res  <= std_logic_vector(to_signed(5, 32));
        B_Res  <= std_logic_vector(to_signed(3, 32));
        ALUControl <= "010";
        wait for 10 ns;

        -- SUB: 5 - 5 (zero should be 1)
        A_Res  <= std_logic_vector(to_signed(5, 32));
        B_Res  <= std_logic_vector(to_signed(5, 32));
        ALUControl <= "110";
        wait for 10 ns;

        -- AND
        A_Res  <= x"0000000F";
        B_Res  <= x"000000F0";
        ALUControl <= "000";
        wait for 10 ns;

        -- OR 
		A_Res  <= x"0000000F";
        B_Res  <= x"000000F0";
        ALUControl <= "001";
        wait for 10 ns;

        -- XOR	
		A_Res  <= x"0000000F";
        B_Res  <= x"000000F0";
        ALUControl <= "011";
        wait for 10 ns;

        -- NOR	
		A_Res  <= x"0000000F";
        B_Res  <= x"000000F0";
        ALUControl <= "100";
        wait for 10 ns;

        -- SLT: 3 < 7 -> result = 1
        A_Res  <= std_logic_vector(to_signed(3, 32));
        B_Res  <= std_logic_vector(to_signed(7, 32));
        ALUControl <= "111";
        wait for 10 ns;
			--sll
		A_Res  <= std_logic_vector(to_signed(4, 32));
        B_Res  <= std_logic_vector(to_signed(2, 32));
        ALUControl <= "101";
        wait for 10 ns;


        wait;
    end process;
	
end Behavioral;
