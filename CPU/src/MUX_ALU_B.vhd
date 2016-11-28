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
        CASE BSrc IS
            WHEN AS_NONE  => BOp <= ZERO16;
            WHEN AS_DATA2 => 
                CASE ForwardingB IS -- Forwarding only happens with RegisterData
                    WHEN FWD_NONE => BOp <= Data2;
                    WHEN FWD_MEM  => BOp <= ExeMemALUOut;
                    WHEN FWD_WB   => BOp <= MemWbDstVal;
                    WHEN others   => BOp <= Data2;
                END CASE;
            WHEN AS_IMME => BOp <= Immediate;
            WHEN others  => BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
