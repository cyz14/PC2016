library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCAddImm is
    Port ( PCin : in  STD_LOGIC_VECTOR (15 downto 0);
           Imm : in  STD_LOGIC_VECTOR (15 downto 0);
           PCout : out  STD_LOGIC_VECTOR (15 downto 0));
end PCAddImm;

architecture Behavioral of PCAddImm is

begin
process(PCin,Imm)
begin
	PCout <= PCin + Imm;
end process;

end Behavioral;