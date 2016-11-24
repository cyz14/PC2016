library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

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
        case ImmeSrc is
            when "000" => -- 3 bit
                Imme(2 downto 0) <= inImme(2 downto 0);
                ext := Signf and inImme(2);
                Imme(15 downto 3) <= (others => ext);
            when "001" => -- 4 bit
                Imme(3 downto 0) <= inImme(3 downto 0);
                ext := Signf and inImme(3);
                Imme(15 downto 4) <= (others => ext);
            when "010" => -- 5 bit
                Imme(4 downto 0) <= inImme(4 downto 0);
                ext := Signf and inImme(4);
                Imme(15 downto 5) <= (others => ext);
            when "011" => -- 8 bit
                Imme(7 downto 0) <= inImme(7 downto 0);
                ext := Signf and inImme(7);
                Imme(15 downto 8) <= (others => ext);
            when "100" => -- 11 bit
                Imme(10 downto 0) <= inImme(10 downto 0);
                ext := Signf and inImme(10);
                Imme(15 downto 11) <= (others => ext);
            when others =>
                Imme <= (others => '0');
        end case;
    end process;
end BHA;
