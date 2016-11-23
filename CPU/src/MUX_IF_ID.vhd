-- MUX_IF_ID.vhd
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

ENTITY MUX_IF_ID IS PORT (
    keep    :  in     STD_LOGIC;
    PCplus1_in  :  IN  STD_LOGIC_VECTOR(15 downto 0);
	Instruction :  in  std_logic_vector(15 downto 0);
	PCplus1_out : out std_logic_vector(15 downto 0);
    InsType :  OUT    STD_LOGIC_VECTOR(4  downto 0);
    rx      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    ry      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    rz      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    funct   :  OUT    STD_LOGIC_VECTOR(1  downto 0);
    imme    :  OUT    STD_LOGIC_VECTOR(7  downto 0)
);
END MUX_IF_ID;

ARCHITECTURE Behaviour OF MUX_IF_ID IS

BEGIN
	process(PCplus1_in)
		BEGIN
				if(keep = '1') then
					PCplus1_out <= "0000000000000000";
					InsType <= "00000";
					rx <= "000";
					ry <= "000";
					rz <= "000";
					funct <= "00";
					imme <= "00000000";
				
				else  
					PCplus1_out <= PCplus1_in;
					InsType <= Instruction(15 downto 11);
					rx <= Instruction(10 DOWNTO 8);
					ry <= Instruction(7 downto 5);
					rz <= Instruction(4 downto 2);
					funct <= Instruction(1 downto 0);
					imme <= Instruction(7 downto 0);
					
				end if;
	end process;

END Behaviour;