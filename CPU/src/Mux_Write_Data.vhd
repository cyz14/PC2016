-- MUX_Write_Data.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_Write_Data IS PORT (
    Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
    ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
    MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
    ForwardingB:    IN  STD_LOGIC_VECTOR( 1 downto 0);
    WriteData:      OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_Write_Data;

ARCHITECTURE Behaviour OF MUX_Write_Data IS

BEGIN

    Process(Data2, ExeMemALUOut, MemWbDstVal, ForwardingB)
    BEGIN
        CASE ForwardingB IS
            WHEN FWD_NONE => WriteData <= Data2;
            WHEN FWD_MEM  => WriteData <= ExeMemALUOut;
            WHEN FWD_WB   => WriteData <= MemWbDstVal;
            WHEN others   => WriteData <= Data2;
        END CASE;
    END Process;

END Behaviour;
