-- MUX_ALU_B.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MUX_ALU_B IS PORT (
    Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
    Immediate:      IN  STD_LOGIC_VECTOR(15 downto 0);
    ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
    MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
    BSrc:           IN  STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingB:    IN  STD_LOGIC_VECTOR( 2 downto 0);
    BOp:            OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ALU_B;

ARCHITECTURE Behaviour OF MUX_ALU_B IS
    CONSTANT ZERO16 : STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);
BEGIN
    
    Process(BSrc, ForwardingB)
    BEGIN
        CASE ForwardingB IS
            WHEN "00" =>
                CASE BSrc IS
                    WHEN AS_NONE  => BOp <= ZERO16;
                    WHEN AS_DATA2 => BOp <= Data2;
                    WHEN AS_IMME  => BOp <= Immediate;
                    WHEN others   => BOp <= ZERO16;
                END CASE;
            WHEN "01" =>
                BOp <= ExeMemALUOut;
            WHEN "10" =>
                BOp <= MemWbDstVal;
            WHEN others =>
                BOp <= ZERO16;
        END CASE;
    END Process;

END Behaviour;
