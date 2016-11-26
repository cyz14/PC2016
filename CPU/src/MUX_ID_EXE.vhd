-- MUX_ID_EXE.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.common.ALL;

ENTITY MUX_ID_EXE IS PORT (
    clk:          IN     STD_LOGIC;
    rst:          IN     STD_LOGIC;
    Data1:        IN     STD_LOGIC_VECTOR(15 downto 0);
    Data2:        IN     STD_LOGIC_VECTOR(15 downto 0);
    Immediate:    IN     STD_LOGIC_VECTOR(15 downto 0);
    DstReg:       IN     STD_LOGIC_VECTOR( 3 downto 0);
    RegWE:        IN     STD_LOGIC;
    MemRead:      IN     STD_LOGIC;
    MemWE:        IN     STD_LOGIC;
    ALUOp:        IN     STD_LOGIC_VECTOR( 3 downto 0);
    ASrc:         IN     STD_LOGIC_VECTOR( 1 downto 0);
    BSrc:         IN     STD_LOGIC_VECTOR( 1 downto 0);
    ASrc4:        IN     STD_LOGIC_VECTOR( 3 downto 0);
    BSrc4:        IN     STD_LOGIC_VECTOR( 3 downto 0);
    Stall:        IN     STD_LOGIC; -- whether stop for a stage from HazardDetectingUnit
    Data1_o:      OUT    STD_LOGIC_VECTOR(15 downto 0);
    Data2_o:      OUT    STD_LOGIC_VECTOR(15 downto 0);
    Immediate_o:  OUT    STD_LOGIC_VECTOR(15 downto 0);
    DstReg_o:     OUT    STD_LOGIC_VECTOR( 3 downto 0);
    RegWE_o:      OUT    STD_LOGIC;
    MemRead_o:    OUT    STD_LOGIC;
    MemWE_o:      OUT    STD_LOGIC;
    ALUOp_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    ASrc_o:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
    BSrc_o:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
    ASrc4_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    BSrc4_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    MemWriteData: OUT    STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ID_EXE;

ARCHITECTURE Behaviour OF MUX_ID_EXE IS

BEGIN

    PROCESS(Stall, clk, rst)
    BEGIN
        IF (rst = '0') THEN
            Data1_o  <= ZERO16;
            Data2_o  <= ZERO16;
            Immediate_o <= ZERO16;
            DstReg_o <= DST_NONE;
            RegWE_o  <= ZERO1;
            MemRead_o<= RAM_READ_DISABLE;
            MemWE_o  <= RAM_WRITE_DISABLE;
            ALUOp_o  <= OP_NONE;
            ASrc_o   <= AS_NONE;
            BSrc_o   <= AS_NONE;
            ASrc4_o  <= DST_NONE;
            BSrc4_o  <= DST_NONE;
            MemWriteData <= ZERO16;
        ELSIF (rising_edge(clk)) THEN
            IF Stall = '1' THEN
                 -- do nothing, wait for a period until Stall is 0
                 null;
            ELSE
                Data1_o  <= Data1;
                Data2_o  <= Data2;
                Immediate_o <= Immediate;
                DstReg_o <= DstReg;
                RegWE_o  <= RegWE;
                MemRead_o<= MemRead;
                MemWE_o  <= MemWE;
                ALUOp_o  <= ALUOp;
                ASrc_o   <= ASrc;
                BSrc_o   <= BSrc;
                ASrc4_o  <= ASrc4;
                BSrc4_o  <= BSrc4;
                IF MemWE = RAM_WRITE_ENABLE THEN
                    MemWriteData <= Data2;
                ELSE
                    MemWriteData <= ZERO16;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behaviour;