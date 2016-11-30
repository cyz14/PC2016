library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity PCMUX is port (
    rst:           IN  STD_LOGIC;
    PCAdd1_data:   IN  STD_LOGIC_VECTOR(15 downto 0);
    PCRx_data:     IN  STD_LOGIC_VECTOR(15 downto 0);
    PCAddImm_data: IN  STD_LOGIC_VECTOR(15 downto 0);
    PC_choose:     IN  STD_LOGIC_VECTOR( 1 downto 0);
    PCout:         out STD_LOGIC_VECTOR(15 downto 0)
);
end PCMUX;

architecture behaviour of PCMUX is
    
BEGIN
    process(rst, PCAdd1_data, PCRx_data, PCAddImm_data, PC_choose)
    BEGIN
        if rst = '0' then
            PCOUT <= (others => '0');
        else
            case PC_choose is
                when PC_Add1   => PCout <= PCAdd1_data;
                when PC_Rx     => PCout <= PCRx_data;
                when PC_AddImm => PCout <= PCAddImm_data;
                when others    => PCout <= PCAdd1_data;
            end case;
        end if;
    end process;
end behaviour;
