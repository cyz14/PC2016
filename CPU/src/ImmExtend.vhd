library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.common.ALL;

entity ImmExtend is 
    port 
    (
        ImmeSrc: in std_logic_vector(2 downto 0);
        inImme: in std_logic_vector(10 downto 0);
        ZeroExtend: in std_logic;
        Imme: out std_logic_vector(15 downto 0)
    );
end entity;

architecture BHA of ImmExtend is

begin
    process (ImmeSrc, inImme, ZeroExtend)
        variable ext, Signf : std_logic;
    begin
        Signf := not ZeroExtend;
        Imme <= (others => '0');
        
        case ImmeSrc is
            -- 3bit: SLL and SRA instructions, 00110 + rx + ry + imm(3) + 00/01
            when IMM_THREE => -- 3 bit
                Imme(2 downto 0) <= inImme(4 downto 2);
                Imme(3) <= not(inImme(0) or inImme(1) or inImme(2));
                Imme(15 downto 4) <= (others => '0');
            
            -- 4bit: ADDIU3, 01000 + rx + ry + 0 + imm(4)
            when IMM_FOUR => -- 4 bit
                Imme(3 downto 0) <= inImme(3 downto 0);
                ext := Signf and inImme(3);
                Imme(15 downto 4) <= (others => ext);
            
            -- 5bit: LW, 10011+rx+ry+imm(5)
            when IMM_FIVE => -- 5 bit
                Imme(4 downto 0) <= inImme(4 downto 0);
                ext := Signf and inImme(4);
                Imme(15 downto 5) <= (others => ext);
            
            when IMM_EIGHT => -- 8 bit
                Imme(7 downto 0) <= inImme(7 downto 0);
                ext := Signf and inImme(7);
                Imme(15 downto 8) <= (others => ext);
            
            -- 11bit: B, 00010+imm(11)
            when IMM_ELEVEN => -- 11 bit
                Imme(10 downto 0) <= inImme(10 downto 0);
                ext := Signf and inImme(10);
                Imme(15 downto 11) <= (others => ext);
            
            when others =>
                Imme <= (others => '0');
        end case;
    end process;
end BHA;
