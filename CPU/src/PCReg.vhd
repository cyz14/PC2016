library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity PCReg is Port (
    clk:   IN  std_logic;
    rst:   IN  std_logic;
    keep:  IN  std_logic;
    PCSrc: IN  std_logic_vector(15 downto 0);
    PC:    out std_logic_vector(15 downto 0)
);
end PCReg;

architecture Behaviour of PCReg is
BEGIN
    process (clk, rst)
    BEGIN
        if rst = '0' then
            PC <= ZERO16; 
        elsif clk'event and clk = '1' then
            if keep = KEEP_DISABLE then
                PC <= PCSrc;
            end if;
        end if;
    end process;
end Behaviour;
