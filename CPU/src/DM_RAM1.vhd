----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:08 11/23/2016 
-- Design Name: 
-- Module Name:    DM_RAM1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use WORK.COMMON.ALL;

entity DM_RAM1 is port (
    CLK:            IN   STD_LOGIC;
    RST:            IN   STD_LOGIC;
    
    MemWE:          IN   STD_LOGIC;
    MemWriteData:   IN   STD_LOGIC_VECTOR(15 downto 0);
    MemRead:        IN   STD_LOGIC;
    ALUOut:         IN   STD_LOGIC_VECTOR(15 downto 0); -- if MemWE, this is Address
    DstVal:         OUT  STD_LOGIC_VECTOR(15 downto 0);
    
    Ram1OE:         OUT   STD_LOGIC;
    Ram1WE:         OUT   STD_LOGIC;
    Ram1EN:         OUT   STD_LOGIC;
    Ram1Addr:       OUT   STD_LOGIC_VECTOR(17 downto 0);
    Ram1Data:       INOUT STD_LOGIC_VECTOR(15 downto 0);
    
    rdn:            OUT  STD_LOGIC;
    wrn:            OUT  STD_LOGIC;
    data_ready:     IN   STD_LOGIC;
    tbre:           IN   STD_LOGIC;
    tsre:           IN   STD_LOGIC;
    
    keyboard_val:   IN   STD_LOGIC_VECTOR(15 downto 0);
	vga_wrn:        OUT  STD_LOGIC;
	vga_data:       OUT  STD_LOGIC_VECTOR(15 downto 0);
    
    NowPC:          IN   STD_LOGIC_VECTOR(15 downto 0);
    Exception:      OUT  STD_LOGIC;
    ExceptPC:       OUT  STD_LOGIC_VECTOR(15 downto 0);
    
    LedSel:         IN   STD_LOGIC_VECTOR(15 downto 0);
    LedOut:         OUT  STD_LOGIC_VECTOR(15 downto 0);
    NumOut:         OUT  STD_LOGIC_VECTOR(7 downto 0)
);
end DM_RAM1;

architecture Behavioral of DM_RAM1 is

    
    SIGNAL IsWriteMode : STD_LOGIC;
    SIGNAL IsUartWrite : STD_LOGIC;
    SIGNAL IsVGAWrite  : STD_LOGIC;
    
    SIGNAL UartReadyLoad : STD_LOGIC;
    SIGNAL UartUpRead    : STD_LOGIC;
    
    SIGNAL LastException : STD_LOGIC;
    
begin
    Ram1EN <= '0';
    Ram1Addr(17 downto 16) <= (others => '0');
    
    Ram1WE <= not IsWriteMode or 
    
    Process(CLK, RST)
    BEGIN
        if RST = '0' THEN
            Ram1OE <= '0';
            Ram1Data <= (others => 'Z');
            IsWriteMode <= '0';
            IsUartWrite <= '0';
            IsVGAWrite  <= '0';
            UartReadyLoad <= '0';
            UartUpRead <= '1';
            
        ELSIF CLK'event and CLK = 1 THEN
            Ram1OE <= not MemWE;
            Ram1Addr(15 downto 0) <= ALUOut;
            IsUartWrite <= '0';
            IsVGAWrite  <= '0';
            UartReadyLoad <= '0';
            IsWriteMode <= MemWE;
            LastException <= '0';

            if MemWE = RAM_WRITE_ENABLE then
                Ram1Data <= MemWriteData;
                Ram1Addr(15 downto 0) <= ALUOut;
            else
                Ram1Data <= (others => 'Z');
            end if;
            
            if InstRead = '1' then
                if DstAddr = x"BF00" then -- Write Uart
                    
                elsif DstAddr = x"BF01" then
                
                end if;
            elsif MemRead = RAM_READ_ENABLE then
                if DstAddr = x"BF00" then
                    
                elsif DstAddr = x"BF01" then
                    
                end if;
            end if;
        END IF;
    END Process;
    


end Behavioral;

