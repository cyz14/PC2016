library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity PCMUX is
    port(
        clk, rst:      IN  STD_LOGIC;
        PCAdd1_data:   IN  STD_LOGIC_VECTOR(15 downto 0);
        PCRx_data:     IN  STD_LOGIC_VECTOR(15 downto 0);
        PCAddImm_data: IN  STD_LOGIC_VECTOR(15 downto 0);
        PC_choose:     IN  STD_LOGIC_VECTOR( 1 downto 0);
        ExeMemALUOut:  IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
        ForwardA:      IN  STD_LOGIC_VECTOR( 1 downto 0);
        PCout:         out STD_LOGIC_VECTOR(15 downto 0) := ZERO16
    );
end PCMUX;

architecture behaviour of PCMUX is
    
    SIGNAL PCRx_o : STD_LOGIC_VECTOR(15 downto 0) := ZERO16;

BEGIN
    process(clk, rst)
    BEGIN
        if rst = '0' then
            PCOUT <= (others => '0');
        elsif clk'event and clk = '1' then
            case PC_choose is
                when PC_Add1   => PCout <= PCAdd1_data;
                when PC_Rx     => --PCout <= PCRx_o;
                    CASE ForwardA is
                        WHEN FWD_NONE => PCout <= PCRx_data;
                        WHEN FWD_MEM  => PCout <= ExeMemALUOut;
                        WHEN FWD_WB   => PCout <= MemWbDstVal;
                        WHEN others   => PCout <= PCRx_data;
                    END CASE;
                when PC_AddImm => PCout <= PCAddImm_data;
                when others    => PCout <= PCAdd1_data;
            end case;
        end if;
    end process;

    -- Process(PCRx_data, ExeMemALUOut, MemWbDstVal, ForwardA, PC_choose)
    -- BEGIN
    --     if PC_choose = PC_Rx then
            
    --     end if;
    -- END Process;
end behaviour;
