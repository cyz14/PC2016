-- RegisterFile.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.common.all;

ENTITY RegisterFile IS
PORT (
    rst:           in std_logic;
    PCplus1:       in std_logic_vector(15 downto 0);
    RegWE:         in std_logic;
    WriteRegister: IN  STD_LOGIC_VECTOR(3  downto 0);
    WriteData:     IN  STD_LOGIC_VECTOR(15 downto 0);
    ASrc4:         in std_logic_vector(3 downto 0);
    BSrc4:         in std_logic_vector(3 downto 0);
    Data1:         out std_logic_vector(15 downto 0);
    Data2:         out std_logic_vector(15 downto 0)
);
END RegisterFile;

ARCHITECTURE Behaviour OF RegisterFile IS
    SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL SP, IH, T              : STD_LOGIC_VECTOR(15 downto 0);

    procedure selectFrom(signal sel: in std_logic_vector(3 downto 0);
                    signal R0, R1, R2, R3, R4, R5, R6, R7
                , SP, T, IH, PC : in std_logic_vector(15 downto 0);
                signal res: out std_logic_vector(15 downto 0)) is
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
    process (PCplus1, WriteRegister, WriteData, ASrc4, BSrc4
        , RegWE, rst)
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
            Data1 <= (others => '0');
            Data2 <= (others => '0');
        else
            if RegWE = '0' then 
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

            if ASrc4 = WriteRegister then
                Data1 <= WriteData;
            else
                selectFrom(ASrc4, R0, R1, R2, R3, R4, R5, R6
                , R7, SP, T, IH, PCplus1, Data1);
            end if;
            if BSrc4 = WriteRegister then
                Data2 <= WriteData;
            else
                selectFrom(BSrc4, R0, R1, R2, R3, R4, R5, R6
                , R7, SP, T, IH, PCplus1, Data2);
            end if;
        end if;
    end process;
END Behaviour;
