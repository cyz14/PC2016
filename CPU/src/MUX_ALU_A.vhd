-- MUX_ALU_A.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_ALU_A IS PORT (
    ASrc:        IN  STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingA: IN  STD_LOGIC_VECTOR( 1 downto 0);
    Data1:       IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate:   IN  STD_LOGIC_VECTOR(15 downto 0);
    ALUOut:      IN  STD_LOGIC_VECTOR(15 downto 0);
    MemDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
    AOp:         OUT STD_LOGIC_VECTOR(15 downto 0) := ZERO16
);
END MUX_ALU_A;

ARCHITECTURE Behaviour OF MUX_ALU_A IS

BEGIN
    
    Process(ASrc, ForwardingA, Immediate, Data1, ALUOut, MemDstVal)
    BEGIN
        CASE ForwardingA IS
            WHEN FWD_NONE =>
                CASE ASrc IS
                    WHEN AS_NONE  => AOp <= ZERO16;
                    WHEN AS_DATA1 => AOp <= Data1;
                    WHEN AS_IMME  => AOp <= Immediate;
                    WHEN others   => AOp <= ZERO16;
                END CASE;
            WHEN FWD_MEM =>
                AOp <= ALUOut;
            WHEN FWD_WB  =>
                AOp <= MemDstVal;
            WHEN others =>
                AOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
