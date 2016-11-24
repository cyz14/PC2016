library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCMUX is
	port(
        clk : in std_logic;
        rst : in std_logic;
		PCPlus1_data : in std_logic_vector(15 downto 0);
		PCRx_data : in std_logic_vector(15 downto 0);
		PCAdd_data : in std_logic_vector(15 downto 0);
		PC_choose : in std_logic_vector(1 downto 0);
		PCout: out std_logic_vector(15 downto 0)
	);
end PCMUX;
architecture behaviour of PCMUX is

begin
	process(PC_choose)
		begin
			case PC_choose is
				when "00" => PCout <= PCPlus1_data;
				when "01" => PCout <= PCRx_data;
				when "10" => PCout <= PCAdd_data;
				when others => null;
			end case;
	end process;
end behaviour;
