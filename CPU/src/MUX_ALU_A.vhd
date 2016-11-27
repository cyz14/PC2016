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
    
    SIGNAL tempAOp : STD_LOGIC_VECTOR(15 downto 0);

BEGIN
    AOp <= tempAOp;
    
    Process(Data1, Immediate, ExeMemALUOut, MemWbDstVal, ASrc, ForwardingA)
    BEGIN
        tempAOp <= ZERO16;
        CASE ForwardingA IS
            WHEN "00" =>
                CASE ASrc IS
                    WHEN AS_NONE  => tempAOp <= ZERO16;
                    WHEN AS_DATA1 => tempAOp <= Data1;
                    WHEN AS_IMME  => tempAOp <= Immediate;
                    WHEN others   => tempAOp <= ZERO16;
                END CASE;
            WHEN "01" =>
                tempAOp <= ExeMemALUOut;
            WHEN "10" =>
                tempAOp <= MemWbDstVal;
            WHEN others =>
                tempAOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
