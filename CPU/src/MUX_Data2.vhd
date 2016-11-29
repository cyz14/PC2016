-- MUX_Data2.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_Data2 IS PORT (
    ForwardingB: IN  STD_LOGIC_VECTOR( 1 downto 0);
    Data2:       IN  STD_LOGIC_VECTOR(15 downto 0);
    ALUOut:      IN  STD_LOGIC_VECTOR(15 downto 0);
    MemDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
    BOp:         OUT STD_LOGIC_VECTOR(15 downto 0) := ZERO16
);
END MUX_Data2;

ARCHITECTURE Behaviour OF MUX_Data2 IS
    
BEGIN
    
    Process(ForwardingB, Data2, ALUOut, MemDstVal)
    BEGIN
        CASE ForwardingB IS -- Forwarding only happens with RegisterData
            WHEN FWD_NONE => BOp <= Data2;
            WHEN FWD_MEM  => BOp <= ALUOut;
            WHEN FWD_WB   => BOp <= MemDstVal;
            WHEN others   => BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
