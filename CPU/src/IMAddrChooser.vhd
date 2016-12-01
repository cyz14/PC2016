library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.common.all;

entity IMAddrChooser is port(
	chooser:  in  std_logic_vector(2 downto 0);
	PCInput:  in  std_logic_vector(15 downto 0);
	AluInput: in  std_logic_vector(15 downto 0);
	outData:  out std_logic_vector(15 downto 0)
);
end IMAddrChooser;

architecture Behavioral of IMAddrChooser is
begin
	
	process(PCInput, AluInput, chooser)
	begin
		case (chooser) is
			when IM_READ => outData <= AluInput;
			when IM_WRITE => outData <= AluInput;
			when others => outData <= PCInput;
		end case;
	end process;
end Behavioral;

