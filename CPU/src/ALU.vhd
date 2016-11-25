-- ALU.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.ALL;

ENTITY ALU IS
PORT (
    A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
    B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
    OP :  IN  STD_LOGIC_VECTOR(3  downto 0);
    F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
    T  :  OUT STD_LOGIC
);
END ALU;

ARCHITECTURE Behaviour OF ALU IS

    SIGNAL tempNUL: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempADD: STD_LOGIC_VECTOR(16 downto 0)   := CONV_STD_LOGIC_VECTOR(0, 17);
    SIGNAL tempSUB: STD_LOGIC_VECTOR(16 downto 0)   := CONV_STD_LOGIC_VECTOR(0, 17);
    SIGNAL tempAND: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempOR : STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempXOR: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempCMP: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempLT : STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempPOS: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempSLL: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempSRL: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempSRA: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16;
    SIGNAL tempROL: STD_LOGIC_VECTOR(15 downto 0)   := ZERO16; -- useless

BEGIN
    tempNUL <= ZERO16;
    tempADD <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned('0' & A) + ieee.numeric_std.unsigned('0' & B));
    tempSUB <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned('0' & A) - ieee.numeric_std.unsigned('0' & B));
    tempAND <= A AND B;
    tempOR  <= A OR  B;
    tempXOR <= A XOR B;
    tempCMP <= ZERO16 WHEN A = B ELSE ONE16;
    tempLT  <= ONE16  WHEN A < B ELSE ZERO16;
    tempPOS <= A;
    tempSLL <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SLL CONV_INTEGER(B));
    tempSRL <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRL CONV_INTEGER(B));
    tempSRA <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRA CONV_INTEGER(B));
    tempROL <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) ROL CONV_INTEGER(B));
    
    PROCESS (A, B, OP)
    BEGIN
        CASE OP IS
            WHEN OP_NONE => 
                F <= ZERO16;
                T <= '0'; -- 
            WHEN OP_ADD  => 
                F <= tempADD(15 downto 0);
                T <= tempADD(16); -- 
            WHEN OP_SUB  => 
                F <= tempSUB(15 downto 0);
                T <= tempSUB(16); -- F <= A  -  B
            WHEN OP_AND  => 
                F <= tempAND;
                T <= '0'; -- F <= A  &  B
            WHEN OP_OR   =>
                F <= tempOR;
                T <= '0'; -- F <= A  |  B
            WHEN OP_XOR  => 
                F <= tempXOR;
                T <= '0'; -- F <= A xor B
            WHEN OP_CMP  => 
                F <= tempCMP;
                T <= tempCMP(0); -- F <= A !=  B, not equal
            WHEN OP_LT   => 
                F <= tempLT;
                T <= tempLT(0);  -- F <= A  <  B
            WHEN OP_POS  => 
                F <= tempPOS;
                T <= '0';        -- F <= A
            WHEN OP_SLL  => 
                F <= tempSLL;
                T <= '0';        -- F <= A <<  B
            WHEN OP_SRL  => 
                F <= tempSRL;
                T <= '0';        -- F <= A >>  B(logical)
            WHEN OP_SRA  => 
                F <= tempSRA; 
                T <= '0';        -- F <= A >>  B(arith)
        END CASE;
    END PROCESS;

END Behaviour;
