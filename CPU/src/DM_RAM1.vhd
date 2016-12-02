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
    MemSignal:     in  std_logic_vector( 2 downto 0);
    WriteData:     in  std_logic_vector(15 downto 0);
    ReadWriteAddr: in  std_logic_vector(15 downto 0);

    DstVal:        out std_logic_vector(15 downto 0);

    Ram1OE:        out std_logic;
    Ram1WE:        out std_logic;
    Ram1EN:        out std_logic;
    Ram1Addr:      out std_logic_vector(17 downto 0);
    Ram1Data:      inout std_logic_vector(15 downto 0);

    rdn:           out std_logic;
    wrn:           out std_logic;
    data_ready:    in  std_logic;
    tbre:          in  std_logic;
    tsre:          in  std_logic;


    vga_wrn:       out std_logic;
    vga_data:      out std_logic_vector(15 downto 0);
    
    LedSel:        in  std_logic_vector(15 downto 0);
    LedOut:        out std_logic_vector(15 downto 0);
    NumOut:        out std_logic_vector( 7 downto 0)
);
end DM_RAM1;

architecture Behavioral of DM_RAM1 is

begin
    
    Process(ReadWriteAddr, WriteData, MemSignal)
    BEGIN
        Ram1OE <= '1';
        Ram1EN <= '1';
        Ram1WE <= '1';
        rdn <= '1';
        wrn <= '1';

        case MemSignal is
            when DM_READ => 
                Ram1Data <= (others => 'Z');
				Ram1Addr <= "00" & ReadWriteAddr;
				Ram1EN <= '0';
				Ram1OE <= '0';
				Ram1WE <= '1';
            when DM_WRITE =>
                Ram1Data <= WriteData;
				Ram1Addr <= "00" & ReadWriteAddr;
				Ram1EN <= '0';
				Ram1OE <= '1';
				Ram1WE <= '0';
            when SerialDataWrite =>
                Ram1Data <= WriteData;
                wrn <= '0';
            when SerialDataRead => 
                Ram1Data <= "ZZZZZZZZZZZZZZZZ";
				rdn <= '0';
            when others =>
                null;
        end case;
    END Process;

    process(Ram1Data, MemSignal, tbre, tsre, data_ready)
    begin
        if (MemSignal = DM_READ) or (MemSignal = SerialDataRead) then
            DstVal <= Ram1Data;
        elsif MemSignal = SerialStateRead then
            DstVal <= "00000000000000" & data_ready & (tbre and tsre);
        else
            DstVal <= ZERO16;
        end if;
    end process;

end Behavioral;

