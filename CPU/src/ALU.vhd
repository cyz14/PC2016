-- ALU.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.ALL;

ENTITY ALU IS
PORT (
    MemRead:  In  STD_LOGIC;
    MemWE:    IN  STD_LOGIC;
    A:        IN  STD_LOGIC_VECTOR(15 downto 0);
    B:        IN  STD_LOGIC_VECTOR(15 downto 0);
    OP:       IN  STD_LOGIC_VECTOR( 3 downto 0);
    F:        OUT STD_LOGIC_VECTOR(15 downto 0);
    ResType:  OUT STD_LOGIC_VECTOR( 2 downto 0);
    ALUPause: OUT STD_LOGIC
);
END ALU;

ARCHITECTURE Behaviour OF ALU IS    

BEGIN
    
    PROCESS (A, B, OP)
        VARIABLE res: STD_LOGIC_VECTOR(15 downto 0) := ZERO16;
    BEGIN
        CASE OP IS
            WHEN OP_NONE => res := ZERO16;
            WHEN OP_ADD  => res := STD_LOGIC_VECTOR(ieee.numeric_std.unsigned(A) + ieee.numeric_std.unsigned(B));
            WHEN OP_SUB  => res := STD_LOGIC_VECTOR(ieee.numeric_std.unsigned(A) - ieee.numeric_std.unsigned(B));
            WHEN OP_AND  => res := A AND B;
            WHEN OP_OR   => res := A OR  B;
            WHEN OP_XOR  => res := A XOR B;
            WHEN OP_CMP  => 
                IF A = B THEN  
                    res := ZERO16;
                ELSE 
                    res := ONE16;
                END IF;
            WHEN OP_LT   => 
                IF A < B THEN
                    res := ONE16; 
                ELSE 
                    res := ZERO16;
                END IF;
            WHEN OP_POS  => res := A;
            WHEN OP_SLL  => res := TO_STDLOGICVECTOR(TO_BITVECTOR(A) SLL CONV_INTEGER(B));
            WHEN OP_SRL  => res := TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRL CONV_INTEGER(B));
            WHEN OP_SRA  => res := TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRA CONV_INTEGER(B));
            WHEN others  => res := ZERO16; ResType <= ALU_RESULT;
        END CASE;

        ALUPause <= '0';
        if MemRead = RAM_READ_ENABLE then
            if (res >= x"8000" and res <= x"BEFF") or (res >= x"BF10") then
                ResType <= DM_READ;
            elsif(res >= x"0000" and res <= x"7FFF")then
                ResType <= IM_READ;
                ALUPause <= KEEP_ENABLE;
            elsif(res = x"BF01")then
				ResType <= SerialStateRead;
			elsif(res = x"BF00")then
				ResType <= SerialDataRead;
			else
				ResType <= ALU_RESULT;
            end if;
            if res >= x"8000" then
                res := res - x"8000";
            end if;
        elsif MemWE = RAM_WRITE_ENABLE then
            if (res >= x"8000" and res <= x"BEFF") or (res >= x"BF10") then
                ResType <= DM_WRITE;
            elsif(res >= x"0000" and res <= x"7FFF")then
                ResType <= IM_WRITE;
                ALUPause <= KEEP_ENABLE;
			elsif(res = x"BF00")then
				ResType <= SerialDataWrite;
            end if;
            if res(15) = '1' then -- >= x"8000" then
                res(15) := '0'; -- res := res - x"8000";
            end if;
        else
            ResType <= ALU_RESULT;
        end if;

        F <= res;
    END PROCESS;

END Behaviour;
