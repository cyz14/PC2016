library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity IM_RAM2 is port(
    MemSignal:     IN    STD_LOGIC_VECTOR( 2 downto 0);
    ReadWriteAddr: In    STD_LOGIC_VECTOR(15 downto 0);
    WriteData:     IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Data
    Ram2_Addr:     OUT   STD_LOGIC_VECTOR(17 downto 0);
    Ram2_Data:     INOUT STD_LOGIC_VECTOR(15 downto 0);
    Ram2_OE:       OUT   STD_LOGIC;
    Ram2_WE:       OUT   STD_LOGIC;
    Ram2_EN:       OUT   STD_LOGIC;
    ReadData:      OUT   STD_LOGIC_VECTOR(15 downto 0)
);
end IM_RAM2;

architecture behaviour of IM_RAM2 is
    
begin

    Ram2_EN <= RAM_ENABLE; -- Always Enable Ram2

    process(ReadWriteAddr, WriteData, MemSignal)
    begin
        case (MemSignal) is
            WHEN IM_WRITE => 
                Ram2_Data <= (others => 'Z');
                Ram2_Addr <= "00" & ReadWriteAddr;
				Ram2_OE <= '1';
				Ram2_WE <= '0';
            when others =>
				Ram2_Data <= (others => 'Z');
				Ram2_OE <= '0';
				Ram2_WE <= '1';
				Ram2_Addr <= "00" & ReadWriteAddr;
        end case;
    end process;

    process(Ram2_Data)
    begin
        if MemSignal /= IM_WRITE then
            ReadData <= Ram2_Data;
        else
            ReadData <= ZERO16;
        end if;
    end process;

end behaviour;
            
