-- MUX_ALU_B.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_ALU_B IS PORT (
    BSrc:        IN  STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingB: IN  STD_LOGIC_VECTOR( 1 downto 0);
    Data2:       IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate:   IN  STD_LOGIC_VECTOR(15 downto 0);
    ALUOut:      IN  STD_LOGIC_VECTOR(15 downto 0);
    MemDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
    BOp:         OUT STD_LOGIC_VECTOR(15 downto 0) := ZERO16
);
END MUX_ALU_B;

ARCHITECTURE Behaviour OF MUX_ALU_B IS
    
BEGIN
    
    Process(BSrc, ForwardingB, Immediate, Data2, ALUOut, MemDstVal)
    BEGIN
        CASE BSrc IS
            WHEN AS_NONE  => BOp <= ZERO16;
            WHEN AS_DATA2 => 
                CASE ForwardingB IS -- Forwarding only happens with RegisterData
                    WHEN FWD_NONE => BOp <= Data2;
                    WHEN FWD_MEM  => BOp <= ALUOut;
                    WHEN FWD_WB   => BOp <= MemDstVal;
                    WHEN others   => BOp <= Data2;
                END CASE;
            WHEN AS_IMME => BOp <= Immediate;
            WHEN others  => BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
