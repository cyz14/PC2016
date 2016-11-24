library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCAdd1 is
    Port (
		PCin : in  STD_LOGIC_VECTOR (15 downto 0);
        PCout : out  STD_LOGIC_VECTOR (15 downto 0));
end PCAdd1;

architecture Behavioral of PCAdd1 is
begin

    PCout <= PCin + 1;

end Behavioral;