-- MUX_ALU_B.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_ALU_B IS PORT (
    BSrc:      IN  STD_LOGIC_VECTOR( 1 downto 0);
    Data2:     IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate: IN  STD_LOGIC_VECTOR(15 downto 0);
    BOp:       OUT STD_LOGIC_VECTOR(15 downto 0) := ZERO16
);
END MUX_ALU_B;

ARCHITECTURE Behaviour OF MUX_ALU_B IS
    
BEGIN
    
    Process(BSrc, Immediate, Data2)
    BEGIN
        CASE BSrc IS
            WHEN AS_NONE  => BOp <= ZERO16;
            WHEN AS_DATA2 => BOp <= Data2;
            WHEN AS_IMME  => BOp <= Immediate;
            WHEN others   => BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
