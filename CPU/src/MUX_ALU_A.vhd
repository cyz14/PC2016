-- MUX_ALU_A.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_ALU_A IS PORT (
    Data1:         IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate:     IN  STD_LOGIC_VECTOR(15 downto 0);
    ExeMemALUOut:  IN  STD_LOGIC_VECTOR(15 downto 0);
    MemWbDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
    ASrc:          IN  STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingA:   IN  STD_LOGIC_VECTOR( 1 downto 0);
    AOp:           OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ALU_A;

ARCHITECTURE Behaviour OF MUX_ALU_A IS

BEGIN
    
    Process(ASrc, ForwardingA, Immediate, Data1, ExeMemALUOut, MemWbDstVal)
    BEGIN
        CASE ForwardingA IS
            WHEN "00" =>
                CASE ASrc IS
                    WHEN AS_NONE  => AOp <= ZERO16;
                    WHEN AS_DATA1 => AOp <= Data1;
                    WHEN AS_IMME  => AOp <= Immediate;
                    WHEN others   => AOp <= ZERO16;
                END CASE;
            WHEN "01" =>
                AOp <= ExeMemALUOut;
            WHEN "10" =>
                AOp <= MemWbDstVal;
            WHEN others =>
                AOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
