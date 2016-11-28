-- MUX_ALU_B.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_ALU_B IS PORT (
    Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate:      IN  STD_LOGIC_VECTOR(15 downto 0);
    ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
    MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
    BSrc:           IN  STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingB:    IN  STD_LOGIC_VECTOR( 1 downto 0);
    BOp:            OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ALU_B;

ARCHITECTURE Behaviour OF MUX_ALU_B IS
    
BEGIN
    
    Process(BSrc, ForwardingB, Immediate, Data2, ExeMemALUOut, MemWbDstVal)
    BEGIN
        CASE ForwardingB IS
            WHEN FWD_NONE =>
                CASE BSrc IS
                    WHEN AS_NONE  => BOp <= ZERO16;
                    WHEN AS_DATA2 => BOp <= Data2;
                    WHEN AS_IMME  => BOp <= Immediate;
                    WHEN others   => BOp <= ZERO16;
                END CASE;
            WHEN FWD_MEM =>
                BOp <= ExeMemALUOut;
            WHEN FWD_WB  =>
                BOp <= MemWbDstVal;
            WHEN others =>
                BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
