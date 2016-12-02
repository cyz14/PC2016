-- MUX_EXE_MEM.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_EXE_MEM IS PORT (
    rst:            IN  STD_LOGIC;
    clk:            IN  STD_LOGIC;
    RegWE:          IN  STD_LOGIC;
    DstReg:         IN  STD_LOGIC_VECTOR( 3 downto 0);
    MemSignal:      IN  STD_LOGIC_VECTOR( 2 downto 0);
    ALUPause:       IN  STD_LOGIC;
    MemWriteData:   IN  STD_LOGIC_VECTOR(15 downto 0);
    ALUOut:         IN  STD_LOGIC_VECTOR(15 downto 0);
    NowPC:          IN  STD_LOGIC_VECTOR(15 downto 0);
    o_NowPC:        out STD_LOGIC_VECTOR(15 downto 0);
    o_RegWE:        OUT STD_LOGIC;
    o_DstReg:       OUT STD_LOGIC_VECTOR( 3 downto 0);
    o_MemSignal:    OUT STD_LOGIC_VECTOR( 2 downto 0);
    o_ALUPause:     OUT STD_LOGIC;
    o_MemWriteData: OUT STD_LOGIC_VECTOR(15 downto 0);
    o_ALUOut:       OUT STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_EXE_MEM;

ARCHITECTURE Behaviour OF MUX_EXE_MEM IS
BEGIN
    process (rst, clk)
    begin
        if rst = '0' then
            o_RegWE <= REG_WRITE_DISABLE;
            o_DstReg <= Dst_None;
            o_MemSignal <= ALU_RESULT;
            o_ALUPause <= KEEP_DISABLE;
            o_MemWriteData <= ZERO16;
            o_ALUOut <= ZERO16;
            o_NowPC <= ZERO16;
        elsif clk'event and clk = '1' then
            o_NowPC <= NowPC; 
            o_RegWE <= RegWE;
            o_DstReg <= DstReg;
            o_MemSignal <= MemSignal;
            o_ALUPause <= ALUPause;
            o_MemWriteData <= MemWriteData;
            o_ALUOut <= ALUOut;
        end if;
    end process;
END Behaviour;
