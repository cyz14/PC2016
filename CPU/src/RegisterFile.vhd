-- RegisterFile.vhd
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

ENTITY RegisterFile IS
PORT (
    PCplus1:    in std_logic_vector(15 downto 0);
    Read1Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
    Read2Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
    WriteRegister:  IN  STD_LOGIC_VECTOR(3  downto 0);
    WriteData:  IN  STD_LOGIC_VECTOR(15 downto 0);
    Data1Src:   in std_logic_vector(2 downto 0);
    Data2Src:   in std_logic_vector(2 downto 0);
    RegWE:      in std_logic;
    Data1:  out std_logic_vector(15 downto 0);
    Data2:  out std_logic_vector(15 downto 0)
);
END RegisterFile;

ARCHITECTURE Behaviour OF RegisterFile IS
    SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL SP, IH, T, PC              : STD_LOGIC_VECTOR(15 downto 0);

    procedure selectIn8Arguments(signal sel: in std_logic_vector(2 downto 0);
        signal r0, r1, r2, r3, r4, r5, r6, r7: in std_logic_vector(15 downto 0);
        signal ret: out std_logic_vector(15 downto 0)) is
    begin
        case sel is
            when "000" =>
                ret <= r0;
            when "001" =>
                ret <= r1;
            when "010" =>
                ret <= r2;
            when "011" =>
                ret <= r3;
            when "100" =>
                ret <= r4;
            when "101" =>
                ret <= r5;
            when "110" =>
                ret <= r6;
            when "111" =>
                ret <= r7;
            when others =>
                ret <= (others => '0');
        end case;
    end selectIn8Arguments;

    procedure selectFromRegs(signal sel0, selx, sely:
        in std_logic_vector(2 downto 0);
        signal r0, r1, r2, r3, r4, r5, r6, r7, PC, SP, T, IH:
            in std_logic_vector(15 downto 0);
        signal ret: out std_logic_vector(15 downto 0))
        is
    begin
        case sel0 is
            when "000" =>
                ret <= (others => '0');
            when "001" =>
                selectIn8Arguments(selx
                , r0, r1, r2, r3, r4, r5, r6, r7, ret);
            when "010" =>
                selectIn8Arguments(sely
                , r0, r1, r2, r3, r4, r5, r6, r7, ret);
            when "011" =>
                ret <= PC;
            when "100" =>
                ret <= SP;
            when "101" =>
                ret <= T;
            when "110" =>
                ret <= IH;
            when "111" =>
                ret <= (others => '0');
            when others =>
                ret <= (others => '0');
        end case;
    end selectFromRegs;

BEGIN
    process (PCplus1, Read1Register, Read2Register
        , WriteRegister, WriteData, Data1Src, Data2Src
        , RegWE)
    begin
        PC <= PCplus1;
        if RegWE = '0' then 
            case WriteRegister is
                when "0000" =>
                    R0 <= WriteData;
                when "0001" =>
                    R1 <= WriteData;
                when "0010" =>
                    R2 <= WriteData;
                when "0011" =>
                    R3 <= WriteData;
                when "0100" =>
                    R4 <= WriteData;
                when "0101" =>
                    R5 <= WriteData;
                when "0110" =>
                    R6 <= WriteData;
                when "0111" =>
                    R7 <= WriteData;
                when "1000" =>
                    SP <= WriteData;
                when "1001" =>
                    T <= WriteData;
                when "1010" =>
                    IH <= WriteData;
                when others =>
                    -- do nothing
            end case;
        end if;

        selectFromRegs(Data1Src, Read1Register
        , Read2Register, R0, R1, R2, R3, R4, R5, R6, R7
        , PC, SP, T, IH, Data1);
        selectFromRegs(Data2Src, Read1Register
        , Read2Register, R0, R1, R2, R3, R4, R5, R6, R7
        , PC, SP, T, IH, Data2);
    end process;
END Behaviour;
