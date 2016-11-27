library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.ALL;

entity HazardDetectingUnit is 
    port (
    rst,clk:    in std_logic;
    MemRead:    in std_logic;
    DstReg:     in std_logic_vector(3 downto 0);
    ASrc4:      in std_logic_vector(3 downto 0);
    BSrc4:      in std_logic_vector(3 downto 0);
    ALUOut:     in std_logic_vector(15 downto 0);
    MemWE:      in std_logic;

    PC_Keep:    out std_logic;
    IFID_Keep:  out std_logic;
    IDEX_Stall: out std_logic
);
end entity;

architecture bha of HazardDetectingUnit is
    signal s1_DstReg: std_logic_vector(3 downto 0);
    signal s1_MemRead: std_logic;
begin
    stall_gen: process (s1_MemRead, s1_DstReg, ASrc4, BSrc4)
        variable stall: std_logic;
    begin
        if (s1_MemRead = '0' and (s1_DstReg = ASrc4 or s1_DstReg = BSrc4))
        or (s1_DstReg = Dst_T and (ASrc4 = Dst_T or BSrc4 = Dst_T))
        or (MemWE = RAM_WRITE_ENABLE and ALUOut(15) = '0') then
            PC_Keep <= '0';
            IFID_Keep <= '0';
            IDEX_Stall <= '0';
        else
            PC_Keep <= '1';
            IFID_Keep <= '1';
            IDEX_Stall <= '1';
        end if;
    end process stall_gen;

    trigger: process (clk, rst)
    begin
        if rst = '0' then
            s1_DstReg <= (others => '1');
            s1_MemRead <= '1';
        elsif clk'event and clk = '1' then
            s1_DstReg <= DstReg;
            s1_MemRead <= MemRead;
        end if;
    end process trigger;

end bha;
