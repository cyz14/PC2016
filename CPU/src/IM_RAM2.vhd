library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

entity IM_RAM2 is port(
    clk         : in    std_logic;
    rst         : in    std_logic;
    PC_i        : in    std_logic_vector(15 downto 0);
    Ram2_Data   : inout std_logic_vector(15 downto 0);
    MemRead     : IN    std_logic;
    MemWE       : in    std_logic;
    ALUOut      : in    std_logic_vector(15 downto 0); -- Mem Write Address
    WriteData   : in    std_logic_vector(15 downto 0); -- Mem Write Data
    Ram2_Addr   : out   std_logic_vector(17 downto 0);
    Instruction : out   std_logic_vector(15 downto 0);
    Ram2_OE     : out   std_logic;
    Ram2_WE     : out   std_logic;
    Ram2_EN     : out   std_logic;
    LedSel      : in    std_logic_vector(15 downto 0);
    LedOut      : out   std_logic_vector(15 downto 0);
    NumOut      : out   std_logic_vector( 7 downto 0)
);
end IM_RAM2;

architecture behaviour of IM_RAM2 is
    
    SHARED VARIABLE tempData: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
begin

    Ram2_EN <= RAM_ENABLE; -- Always Enable Ram2

    process(clk, rst)
    begin
        if rst = '0' then
            Ram2_EN <= RAM_ENABLE;
            Ram2_OE <= RAM_READ_ENABLE;
            Ram2_WE <= RAM_WRITE_DISABLE;
            Ram2_Data <= (others => 'Z');
            Ram2_Addr <= (others => '0');
            Instruction <= ZERO16;
        elsif clk'event and clk = '1' then
            if MemWE = MEM_WRITE_ENABLE then
                Ram2_Addr <= "00" & ALUOut;
                Ram2_data <= WriteData;
                -- Write Mode
                Ram2_OE <= '1';
                Ram2_WE <= '0';
            else
                Ram2_Addr <= "00" & PC_i;
                -- Read Mode
                Ram2_OE <= '0';
                Ram2_WE <= '1';
                Ram2_Data <= (others => 'Z');
                tempData := Ram2_data;
                Instruction <= tempData;
            end if;
        end if;
    end process;

end behaviour;
            
