-- MUX_EXE_MEM.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_EXE_MEM IS PORT (
    rst             : IN  STD_LOGIC;
    clk             : IN  STD_LOGIC;
    DstReg          : IN  STD_LOGIC_VECTOR(3 downto 0);
    RegWE           : IN  STD_LOGIC;
    MemRead         : IN  STD_LOGIC;
    MemWE           : IN  STD_LOGIC;
    MemWriteData    : IN  STD_LOGIC_VECTOR(15 downto 0);
    ALUOut          : IN  STD_LOGIC_VECTOR(15 downto 0);
    T               : IN  STD_LOGIC;
    Stall           : IN  STD_LOGIC;
    o_DstReg        : OUT STD_LOGIC_VECTOR(3 downto 0);
    o_RegWE         : OUT STD_LOGIC;
    o_MemRead       : OUT STD_LOGIC;
    o_MemWE         : OUT STD_LOGIC;
    o_MemWriteData  : OUT STD_LOGIC_VECTOR(15 downto 0);
    o_ALUOut        : OUT STD_LOGIC_VECTOR(15 downto 0);
    o_InstRead      : OUT STD_LOGIC;
    o_InstVal       : OUT STD_LOGIC_VECTOR(15 downto 0)

);
END MUX_EXE_MEM;

ARCHITECTURE Behaviour OF MUX_EXE_MEM IS
BEGIN
    process (rst, clk)
    begin
        if rst = '0' then
            o_RegWE <= '1';
            o_MemWE <= '1';
            o_MemRead <= '1';
            o_ALUOut <= ZERO16;
            o_MemWriteData <= ZERO16;
        elsif clk'event and clk = '1' then 
            if Stall = '0' then
                o_RegWE <= '1';
                o_MemWE <= '1';
                o_MemRead <= '1';
            else
                o_DstReg <= DstReg;
                o_RegWE <= RegWE;
                o_MemRead <= MemRead;
                o_MemWE <= MemWE;
                o_MemWriteData <= MemWriteData;
                o_ALUOut <= ALUOut;
            end if;
        end if;
    end process;
END Behaviour;
