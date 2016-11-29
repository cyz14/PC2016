-- RegisterFile.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.COMMON.all;

ENTITY RegisterFile IS
PORT (
    rst:                    IN  STD_LOGIC;
    clk:                    IN  STD_LOGIC;
    PCplus1:                IN  STD_LOGIC_VECTOR(15 downto 0);
    RegWE:                  IN  STD_LOGIC;
    WriteRegister:          IN  STD_LOGIC_VECTOR( 3 downto 0);
    WriteData:              IN  STD_LOGIC_VECTOR(15 downto 0);
    ASrc4:                  IN  STD_LOGIC_VECTOR( 3 downto 0);
    BSrc4:                  IN  STD_LOGIC_VECTOR( 3 downto 0);
    Data1:                  OUT STD_LOGIC_VECTOR(15 downto 0):= ZERO16;
    Data2:                  OUT STD_LOGIC_VECTOR(15 downto 0):= ZERO16;
    R0_o, R1_o, R2_o, R3_o: OUT STD_LOGIC_VECTOR(15 downto 0);
    R4_o, R5_o, R6_o, R7_o: OUT STD_LOGIC_VECTOR(15 downto 0);
    SP_o, T_o, IH_o:        OUT STD_LOGIC_VECTOR(15 downto 0)
);
END RegisterFile;

ARCHITECTURE Behaviour OF RegisterFile IS
    SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL SP, IH, T              : STD_LOGIC_VECTOR(15 downto 0);

    procedure selectFrom(signal sel: IN STD_LOGIC_VECTOR(3 downto 0);
                    signal R0, R1, R2, R3, R4, R5, R6, R7
                , SP, T, IH, PC : IN STD_LOGIC_VECTOR(15 downto 0);
                signal res: OUT STD_LOGIC_VECTOR(15 downto 0)) is
    begin
        case sel is
            when Dst_R0 => res <= R0;
            when Dst_R1 => res <= R1;
            when Dst_R2 => res <= R2;
            when Dst_R3 => res <= R3;
            when Dst_R4 => res <= R4;
            when Dst_R5 => res <= R5;
            when Dst_R6 => res <= R6;
            when Dst_R7 => res <= R7;
            when Dst_SP => res <= SP;
            when Dst_T  => res <= T;
            when Dst_IH => res <= IH;
            when Dst_PC => res <= PC;
            when others => res <= (others => '0');
        end case;
    end selectFrom;

BEGIN
    R0_o <= R0;
    R1_o <= R1;
    R2_o <= R2;
    R3_o <= R3;
    R4_o <= R4;
    R5_o <= R5;
    R6_o <= R6;
    R7_o <= R7;
    SP_o <= SP;
    T_o  <= T;
    IH_o <= IH;

    p_write: process (clk, rst, PCplus1, WriteRegister, WriteData, ASrc4, BSrc4
        , RegWE)
    begin
        if rst = '0' then
            R0 <= (others => '0');
            R1 <= (others => '0');
            R2 <= (others => '0');
            R3 <= (others => '0');
            R4 <= (others => '0');
            R5 <= (others => '0');
            R6 <= (others => '0');
            R7 <= (others => '0');
            SP <= (others => '0');
            IH <= (others => '0');
            T  <= (others => '0');
        elsif clk'event and clk = '1' then
            if RegWE = REG_WRITE_ENABLE then 
                case WriteRegister is
                    when Dst_R0 => R0 <= WriteData;
                    when Dst_R1 => R1 <= WriteData;
                    when Dst_R2 => R2 <= WriteData;
                    when Dst_R3 => R3 <= WriteData;
                    when Dst_R4 => R4 <= WriteData;
                    when Dst_R5 => R5 <= WriteData;
                    when Dst_R6 => R6 <= WriteData;
                    when Dst_R7 => R7 <= WriteData;
                    when DST_SP => SP <= WriteData;
                    when DST_T  => T  <= WriteData;
                    when DST_IH => IH <= WriteData;
                    when others => null; -- do nothing
                end case;
            end if;
        end if;
    end process;

    p_read1: process(rst, ASrc4, RegWE, WriteRegister, WriteData)
    BEGIN
        if rst = '0' then
            Data1 <= (others => '0');
        elsif (not (ASrc4 = DST_NONE)) and RegWE = REG_WRITE_ENABLE and ASrc4 = WriteRegister then
            Data1 <= WriteData;
        else
            selectFrom(ASrc4, R0, R1, R2, R3, R4, R5, R6
            , R7, SP, T, IH, PCplus1, Data1);
        end if;
    END process;

    p_read2: process(rst, BSrc4, RegWE, WriteRegister, WriteData)
    BEGIN
        if rst = '0' then
            Data2 <= (others => '0');
        elsif not (BSrc4 = DST_NONE) and RegWE = REG_WRITE_ENABLE and BSrc4 = WriteRegister then
            Data2 <= WriteData;
        else
            selectFrom(BSrc4, R0, R1, R2, R3, R4, R5, R6
            , R7, SP, T, IH, PCplus1, Data2);
        end if;
    END process;
END Behaviour;
