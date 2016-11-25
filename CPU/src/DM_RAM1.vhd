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
    
    InstRead:       IN   STD_LOGIC;
    InstVal:        IN   STD_LOGIC_VECTOR(15 downto 0);
    
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

    SIGNAL LastALUOut: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ALUOutMask: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL MemOutMask: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL InstOutMask: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL UartOutMask: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL KeyboardOutMask: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL UartOut: STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL IsWriteMode : STD_LOGIC;
    SIGNAL IsUartWrite : STD_LOGIC;
    SIGNAL IsVGAWrite  : STD_LOGIC;
    
    SIGNAL UartReadyLoad : STD_LOGIC;
    SIGNAL UartUpRead    : STD_LOGIC;
    
    SIGNAL LastException : STD_LOGIC;
    
    SIGNAL SyncClk : STD_LOGIC;
    SIGNAL SyncClkWorking : STD_LOGIC;
    SIGNAL SyncClkA : STD_LOGIC;
    SIGNAL SyncClkB : STD_LOGIC;
    
begin

    SyncClk <= SyncClkA xor SyncClkB;
    
    Ram1EN <= '0';
    Ram1Addr(17 downto 16) <= (others => '0');
    Ram1WE <= not IsWriteMode or SyncClk;
    wrn <= not IsUartWrite or SyncClk;
    vga_wrn <= not IsVGAWrite or SyncClk;
    vga_data <= MemWriteData;
    rdn <= UartUpRead or not UartReadyLoad;
    DstVal <= (LastALUOut and ALUOutMask) 
            or (Ram1Data and MemOutMask) 
            or (InstVal and InstOutMask) 
            or (UartOut and UartOutMask) 
            or (keyboard_val and KeyboardOutMask);
    
    UartOut(15 downto 2) <= (others => '0');
    with data_ready select UartOut(1) <=
        '1' when '1',
        '0' when others;
    with tbre and tsre select UartOut(0) <= 
        '1' when '1',
        '0' when others;
        
    Exception <= LastException;
    
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
            LastException <= '0';
            SyncClkWorking <= '0';
            SyncClkA <= '1';
            SyncClkB <= '0';
        ELSIF CLK'event and CLK = '1' THEN
            SyncClkWorking <= '1';
            SyncClkA <= not SyncClkA;
            LastALUOut <= ALUOut;
            Ram1OE <= not MemWE;
            Ram1Addr(15 downto 0) <= ALUOut;
            IsUartWrite <= '0';
            IsVGAWrite  <= '0';
            UartReadyLoad <= '0';
            IsWriteMode <= not MemWE;
            LastException <= '0';
            if MemWE = RAM_WRITE_ENABLE then
                Ram1Data <= MemWriteData;
                Ram1Addr(15 downto 0) <= ALUOut;
            else
                Ram1Data <= (others => 'Z');
            end if;
            
            KeyboardOutMask <= (others => '0');
            if InstRead = '1' then -- read InstructionMemory
                InstOutMask <= (others => '1');
                ALUOutMask <= (others => '0');
                MemOutMask <= (others => '0');
                UartOutMask <= (others => '0');
            elsif MemRead = RAM_READ_ENABLE then -- Read DataMemory
                InstOutMask <= (others => '0');
                ALUOutMask <= (others => '0');
                MemOutMask <= (others => '1');
                UartOutMask <= (others => '0');
                if ALUOut = x"BF00" then -- read from Uart
                    Ram1OE <= '1';
                    UartReadyLoad <= '1';
                    Ram1Data(15 downto 8) <= (others => '0');
                    if not (data_ready = '1') then
                        LastException <= '1';
                        ExceptPC <= NowPC;
                        UartReadyLoad <= '0';
                    end if;
                elsif ALUOut = x"BF01" then -- Read Uart Flag
                    MemOutMask <= (others => '0');
                    UartOutMask <= (others => '1');
                elsif ALUOut = x"BF04" then -- Read Keyboard Input Key
                    MemOutMask <= (others => '0');
                    KeyboardOutMask <= (others => '1');
                end if;
            else -- Write Mem or do nothing
                InstOutMask <= (others => '0');
                ALUOutMask <= (others => '1');
                MemOutMask <= (others => '0');
                UartOutMask <= (others => '0');
                if MemWE = RAM_WRITE_ENABLE and ALUOut = x"BF00" then -- write uart
                    IsWriteMode <= '0';
                    IsUartWrite <= '1';
                    if not((tbre and tsre) = '1') then
                        LastException <= '1';
                        ExceptPC <= NowPC;
                        IsUartWrite <= '0';
                    end if;
                elsif MemWE = RAM_WRITE_ENABLE and ALUOut = x"BF06" then -- write VGA
                    IsWriteMode <= '0';
                    IsVGAWrite <= '1';
                end if;
            end if;
            
            -- if LastException = '1' then
                -- UartReadyLoad <= '0';
                -- IsWriteMode <= '0';
                -- IsUartWrite <= '0';
                -- LastException <= '0';
            -- end if;
        END IF;
    END Process;
    


end Behavioral;

