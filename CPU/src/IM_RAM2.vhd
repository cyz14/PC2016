library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity IM_RAM2 is port(
    clk:           IN    STD_LOGIC;
    rst:           IN    STD_LOGIC;
    PC_i:          IN    STD_LOGIC_VECTOR(15 downto 0);
    mem_MemRead:   IN    STD_LOGIC;
    mem_MemWE:     IN    STD_LOGIC;
    mem_ALUOut:    IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Address
    mem_WriteData: IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Data
    Ram2_Addr:     OUT   STD_LOGIC_VECTOR(17 downto 0);
    Ram2_Data:     inout STD_LOGIC_VECTOR(15 downto 0);
    Ram2_OE:       OUT   STD_LOGIC;
    Ram2_WE:       OUT   STD_LOGIC;
    Ram2_EN:       OUT   STD_LOGIC;
    Ram2_Inst:     OUT   STD_LOGIC_VECTOR(15 downto 0)
    -- ;

    -- LedSel:        IN    STD_LOGIC_VECTOR(15 downto 0);
    -- LedOut:        OUT   STD_LOGIC_VECTOR(15 downto 0);
    -- NumOut:        OUT   STD_LOGIC_VECTOR( 7 downto 0)
);
end IM_RAM2;

architecture behaviour of IM_RAM2 is
    
begin

    Ram2_EN <= RAM_ENABLE; -- Always Enable Ram2

    process(rst, PC_i, mem_MemWE, mem_MemRead, mem_ALUOut, mem_WriteData)
    begin
        if rst = '0' then
            Ram2_EN <= RAM_ENABLE;
            Ram2_OE <= RAM_READ_ENABLE;
            Ram2_WE <= RAM_WRITE_DISABLE;
            Ram2_Data <= (others => 'Z');
            Ram2_Addr <= (others => '0');
            --Ram2_Inst <= ZERO16;
        else
            if mem_ALUOut(15) = '0' and ( (mem_MemWE = MEM_WRITE_ENABLE) or (mem_MemRead = MEM_READ_ENABLE) ) then
                Ram2_Addr <= "00" & mem_ALUOut;
                if mem_MemWE = MEM_WRITE_ENABLE then
                    Ram2_OE <= '1';
                    Ram2_data <= mem_WriteData;
                    -- Write Mode
                    Ram2_WE <= '0';
                elsif mem_MemRead = MEM_READ_ENABLE then
                    Ram2_WE <= '1';
                    Ram2_OE <= '0';
                    Ram2_Data <= (others => 'Z');
                end if;
            else
                Ram2_Addr <= "00" & PC_i;
                -- Read Mode
                Ram2_OE <= '0';
                Ram2_WE <= '1';
                Ram2_Data <= (others => 'Z');
            end if;
        end if;
    end process;

    process(rst, Ram2_Data)
    begin
        if rst = '0' then
            ram2_Inst <= (others => 'Z');
        else
            ram2_Inst <= Ram2_Data;
        end if;
    end process;

end behaviour;
            
