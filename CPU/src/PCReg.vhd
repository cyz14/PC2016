library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCReg is
    Port (
        PCSrc : in std_logic_vector(15 downto 0);
        keep : in std_logic;
        PC : out std_logic_vector(15 downto 0)
    );
end PCReg;

architecture Behaviour of PCReg is
begin
    process (PCSrc, keep)
    begin
        if keep = '1' then
            PC <= PCSrc;
        end if;
    end process;
end Behaviour;
