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
    
BEGIN
    process (rst, clk)
    BEGIN    
        if rst = '0' then
            RegWE_o <= '1';
            DstReg_o <= DST_NONE;
            DstVal_o <= ZERO16;
        elsif clk'event and clk = '1' then
            DstReg_o <= DstReg;
            RegWE_o  <= RegWE;
            if MemRead = RAM_READ_ENABLE then
                DstVal_o <= MemData;
            else
                DstVal_o <= ALUOut;
            end if;
        end if;
    end process;
END Behaviour;
