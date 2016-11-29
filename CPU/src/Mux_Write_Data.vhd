-- MUX_Write_Data.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_Write_Data IS PORT (
    MemRead:   IN  STD_LOGIC;
    MemALUOut: IN  STD_LOGIC_VECTOR(15 downto 0);
    MemData:   IN  STD_LOGIC_VECTOR(15 downto 0);
    WriteData: OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_Write_Data;

ARCHITECTURE Behaviour OF MUX_Write_Data IS

BEGIN

    Process(MemRead, MemALUOut, MemData)
    BEGIN
        IF MemRead = RAM_READ_ENABLE THEN
            WriteData <= MemData;
        ELSE
            WriteData <= MemALUOut;
        END IF;
    END Process;

END Behaviour;
