library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.common.ALL;

entity PCMUX is
    port(
        clk, rst : in std_logic;
        PCAdd1_data : in std_logic_vector(15 downto 0);
        PCRx_data : in std_logic_vector(15 downto 0);
        PCAddImm_data : in std_logic_vector(15 downto 0);
        PC_choose : in std_logic_vector(1 downto 0);
        PCout: out std_logic_vector(15 downto 0)
    );
end PCMUX;
architecture behaviour of PCMUX is

begin
    process(clk, rst)
    begin
        if rst = '0' then
            PCout <= (others => '0');
        elsif clk'event and clk = '1' then
            case PC_choose is
                when PC_Add1   => PCout <= PCAdd1_data;
                when PC_Rx     => PCout <= PCRx_data;
                when PC_AddImm => PCout <= PCAddImm_data;
                when others => null;
            end case;
        end if;
    end process;
end behaviour;
