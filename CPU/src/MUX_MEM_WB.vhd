-- MUX_MEM_WB.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.ALL;

ENTITY MUX_MEM_WB IS PORT (
    rst, clk: in std_logic;
    RegWE:    in std_logic;
    DstReg:   in std_logic_vector( 3 downto 0);
    DstVal:   in std_logic_vector(15 downto 0);
    exe_MemWE: in std_logic;
    mem_MemWE: out std_logic;
    RegWE_o:  out std_logic;
    DstReg_o: out std_logic_vector( 3 downto 0);
    DstVal_o: out std_logic_vector(15 downto 0)
);
END MUX_MEM_WB;

ARCHITECTURE Behaviour OF MUX_MEM_WB IS
    
BEGIN
    process (rst, clk, DstReg, RegWE, DstVal)
    BEGIN    
        if rst = '0' then
            RegWE_o <= REG_WRITE_DISABLE;
            DstReg_o <= DST_NONE;
            DstVal_o <= ZERO16;
            mem_MemWE <= RAM_WRITE_DISABLE;
        elsif clk'event and clk = '1' then
            mem_MemWE <= exe_MemWE;
            RegWE_o  <= RegWE;
            DstReg_o <= DstReg;
            DstVal_o <= DstVal;
        end if;
    end process;
END Behaviour;
