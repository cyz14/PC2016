-- MUX_Write_Data.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_Write_Data IS PORT (
    MemSignal:  IN  STD_LOGIC_VECTOR( 2 downto 0);
    mem_ALUOut: IN  STD_LOGIC_VECTOR(15 downto 0);
    DMData:     IN  STD_LOGIC_VECTOR(15 downto 0);
    IMData:     IN  STD_LOGIC_VECTOR(15 downto 0);
    WriteData:  OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_Write_Data;

ARCHITECTURE Behaviour OF MUX_Write_Data IS

BEGIN
    Process(MemSignal, mem_ALUOut, DMData, IMData)
    BEGIN
        Case MemSignal IS
            WHEN ALU_RESULT => WriteData <= mem_ALUOut;
            WHEN IM_READ => WriteData <= IMData;
            WHEN DM_READ =>  WriteData <= DMData;
            WHEN SerialStateRead => WriteData <= DMData;
            WHEN SerialDataRead => WriteData <= DMData; 
            WHEN others => WriteData <= ZERO16;
        END Case;
    END Process;

END Behaviour;
