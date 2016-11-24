library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IM_RAM2 is port(
	pc : in std_logic_vector(15 downto 0);
	ram_2_data : inout std_logic_vector(15 downto 0);
	ram_2_addr : out std_logic_vector(15 downto 0);
	Instruction : out std_logic_vector(15 downto 0);
	ram_2_oe: out std_logic;
    ram_2_we: out std_logic;
    ram_2_en: out std_logic
);
end IM_RAM2;

architecture behaviour of IM_RAM2 is
	 SHARED VARIABLE tempData: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
	process(pc)
		begin
			ram_2_en <= '0';
			ram_2_data <= "ZZZZZZZZZZZZZZZZ";
			if(pc <= x"7FFF") then -- 没必要检查PC的值
				ram_2_oe <= '0';
				ram_2_we <= '1';
				ram_2_addr <= pc;
				tempData := ram_2_data;
				Instruction <= tempData;
			end if;
	end	process;

end behaviour;
			