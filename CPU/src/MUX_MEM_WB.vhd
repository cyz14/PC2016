-- MUX_MEM_WB.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_MEM_WB IS PORT (
    rst, clk: in std_logic;
    ALUOut:   in std_logic_vector(15 downto 0);
    MemData:  in std_logic_vector(15 downto 0);
    MemRead:  in std_logic;
    DstReg:   in std_logic_vector(3 downto 0);
    RegWE:    in std_logic;

    DstReg_o: out std_logic_vector(3 downto 0);
    RegWE_o:  out std_logic;
    DstVal_o: out std_logic_vector(15 downto 0)
);
END MUX_MEM_WB;

ARCHITECTURE Behaviour OF MUX_MEM_WB IS
    SIGNAL tempDstReg_o : std_logic_vector(3 downto 0) := DST_NONE;
    SIGNAL tempRegWE_o  : std_logic := '1';
    SIGNAL tempDstVal_o : std_logic_vector(15 downto 0) := ZERO16;
BEGIN
    DstReg_o <= tempDstReg_o;
    RegWE_o  <= tempRegWE_o;
    DstVal_o <= tempDstVal_o;

    process (rst, clk)
    BEGIN    
        if rst = '0' then
            tempRegWE_o <= '1';
            tempDstReg_o <= DST_NONE;
            tempDstVal_o <= ZERO16;
        elsif clk'event and clk = '1' then
            tempDstReg_o <= DstReg;
            tempRegWE_o  <= RegWE;
            if MemRead = RAM_READ_ENABLE then
                tempDstVal_o <= MemData;
            else
                tempDstVal_o <= ALUOut;
            end if;
        end if;
    end process;
END Behaviour;
