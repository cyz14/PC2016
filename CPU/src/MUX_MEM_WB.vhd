-- MUX_MEM_WB.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MUX_MEM_WB IS PORT (
    rst, clk: in std_logic;
    ALUOut: in std_logic_vector(15 downto 0);
    MemData: in std_logic_vector(15 downto 0);
    MemRead: in std_logic;
    DstReg: in std_logic_vector(3 downto 0);
    RegWE: in std_logic;

    o_DstReg: out std_logic_vector(3 downto 0);
    o_RegWE: out std_logic;
    o_DestVal: out std_logic_vector(15 downto 0)
);
END MUX_MEM_WB;

ARCHITECTURE Behaviour OF MUX_MEM_WB IS
BEGIN
    process (rst, clk)
    begin
        if rst = '0' then
            o_RegWE <= '1';
        elsif clk'event and clk = '1' then
            o_DstReg <= DstReg;
            o_RegWE <= RegWE;
            if MemRead = '0' then
                o_DestVal <= MemData;
            else
                o_DestVal <= ALUOut;
            end if;
        end if;
    end process;
END Behaviour;
