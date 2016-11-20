library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCReg is
	Port (
		clk : in std_logic;
		rst : in std_logic;
		PCSrc : in std_logic_vector(15 downto 0);
		keep : in std_logic;
		PC : out std_logic_vector(15 downto 0)
	);
end PCReg;

architecture Behaviour of PCReg is
begin
	process(clk,rst)
		begin
			if( rst = '0') then
				PC <= "0000000000000000";
			elsif (rising_edge(clk)) then
				if ( keep = '0') then
					PC <= PCSrc;
				end if;
			end if;
	end process;
	
end Behaviour;