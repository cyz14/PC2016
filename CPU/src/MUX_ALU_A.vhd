-- MUX_ALU_A.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MUX_ALU_A IS PORT (
    Data1:         STD_LOGIC_VECTOR(15 downto 0);
    Immediate:     STD_LOGIC_VECTOR(15 downto 0);
    ExeMemALUOut:  STD_LOGIC_VECTOR(15 downto 0);
    MemWbDstVal:   STD_LOGIC_VECTOR(15 downto 0);
    ASrc:          STD_LOGIC_VECTOR( 1 downto 0);
    ForwardingA:   STD_LOGIC_VECTOR( 2 downto 0);
    AOp:           STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ALU_A;

ARCHITECTURE Behaviour OF MUX_ALU_A IS
    CONSTANT ZERO16 : STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);
BEGIN
    
    Process(ASrc, ForwardingA)
    BEGIN
        CASE ForwardingA IS
            WHEN "00" =>
                CASE ASrc IS
                    WHEN "00" => AOp <= ZERO16;
                    WHEN "01" => AOp <= Data1;
                    WHEN "10" => AOp <= Immediate;
                    WHEN others => AOp <= ZERO16;
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
