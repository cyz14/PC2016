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
    OP :  IN  STD_LOGIC_VECTOR( 3 downto 0);
    F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
    T  :  OUT STD_LOGIC
);
END ALU;

ARCHITECTURE Behaviour OF ALU IS

    SIGNAL tempADD: STD_LOGIC_VECTOR(16 downto 0)   := CONV_STD_LOGIC_VECTOR(0, 17);
    SIGNAL tempSUB: STD_LOGIC_VECTOR(16 downto 0)   := CONV_STD_LOGIC_VECTOR(0, 17);    

BEGIN
    
    PROCESS (A, B, OP)
    BEGIN
        CASE OP IS
            WHEN OP_NONE => 
                F <= ZERO16;
                T <= '0'; -- 
            WHEN OP_ADD  => 
                F <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned(A) + ieee.numeric_std.unsigned(B));
                tempAdd <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned('0' & A) + ieee.numeric_std.unsigned('0' & B));
            WHEN OP_SUB  => 
                F <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned(A) - ieee.numeric_std.unsigned(B));
                tempSUB <= STD_LOGIC_VECTOR(ieee.numeric_std.unsigned('0' & A) - ieee.numeric_std.unsigned('0' & B));
            WHEN OP_AND  => 
                F <= A AND B;
                T <= '0'; -- F <= A  &  B
            WHEN OP_OR   =>
                F <= A OR  B;
                T <= '0'; -- F <= A  |  B
            WHEN OP_XOR  => 
                F <= A XOR B;
                T <= '0'; -- F <= A xor B
            WHEN OP_CMP  => 
                IF A = B THEN
                    F <= ZERO16; 
                ELSE 
                    F <= ONE16;
                END IF;
                IF A = B THEN
                    T <= '0';
                ELSE
                    T <= '1'; -- F <= A !=  B, not equal
                END IF;
            WHEN OP_LT   =>
                IF A < B THEN
                    F <= ONE16;
                ELSE 
                    F <= ZERO16;
                END IF;
                IF A < B THEN
                    T <= '1'; 
                ELSE
                    T <= '0'; -- F <= A  <  B
                END IF;
            WHEN OP_POS  => 
                F <= A;
                T <= '0';        -- F <= A
            WHEN OP_SLL  => 
                F <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SLL CONV_INTEGER(B));
                T <= '0';        -- F <= A <<  B
            WHEN OP_SRL  => 
                F <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRL CONV_INTEGER(B));
                T <= '0';        -- F <= A >>  B(logical)
            WHEN OP_SRA  => 
                F <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRA CONV_INTEGER(B));
                T <= '0';        -- F <= A >>  B(arith)
            WHEN others =>
                F <= ZERO16;
                T <= '0';
        END CASE;
    END PROCESS;

END Behaviour;
