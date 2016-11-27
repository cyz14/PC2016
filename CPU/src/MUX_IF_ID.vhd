-- MUX_IF_ID.vhd
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

use work.common.all;

ENTITY MUX_IF_ID IS PORT (
    clk          :  IN  STD_LOGIC;
    rst          :  IN  STD_LOGIC;
    if_Keep      :  IN  STD_LOGIC;
    if_PCPlus1   :  IN  STD_LOGIC_VECTOR(15 downto 0);
	if_Inst      :  IN  STD_LOGIC_VECTOR(15 downto 0);
	id_PCPlus1   :  OUT STD_LOGIC_VECTOR(15 downto 0);
    id_Inst      :  OUT STD_LOGIC_VECTOR(15 downto 0);
    id_Imme      :  OUT STD_LOGIC_VECTOR(10 downto 0)
);
END MUX_IF_ID;

ARCHITECTURE Behaviour OF MUX_IF_ID IS

BEGIN
	process(clk, rst)
		BEGIN
            if(rst = '0') then
                id_PCPlus1 <= (others => '0');
                id_Inst <= (others => '0');
                id_Imme <= (others => '0');
            elsif clk'event and clk = '1' then
                if if_Keep = KEEP_DISABLE then
                    id_PCPlus1 <= if_PCPlus1;
                    id_Inst <= if_Inst;
                    id_Imme <= if_Inst(10 downto 0);
                end if;
            end if;
	end process;

END Behaviour;