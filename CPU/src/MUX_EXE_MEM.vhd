-- MUX_EXE_MEM.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MUX_EXE_MEM IS PORT (
    rst, clk: in std_logic;
    DstReg: in std_logic_vector(3 downto 0);
    RegWE: in std_logic;
    MemRead: in std_logic;
    MemWE: in std_logic;
    MemWriteData: in std_logic_vector(15 downto 0);
    ALUOut: in std_logic_vector(15 downto 0);
    T: in std_logic;
    Stall : in std_logic;

    o_DstReg: out std_logic_vector(3 downto 0);
    o_RegWE, o_MemRead, o_MemWE: out std_logic;
    o_MemWriteData: out std_logic_vector(15 downto 0);
    o_ALUOut: out std_logic_vector(15 downto 0)
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
