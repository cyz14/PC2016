----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:01:52 11/07/2016 
-- Design Name: 
-- Module Name:    TestIOSerial - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestIOSerial is
    Port (
           comclk : in STD_LOGIC; -- 11.9MHz
           rst : in  STD_LOGIC;   -- hand reset
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
           ram1oe : out  STD_LOGIC;
           ram1we : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC);
end TestIOSerial;

architecture Behavioral of TestIOSerial is

    type TopState is (
        TStateStart,
        TStateGetAddr,
        TStateReadCom0,
        TStateReadCom1,
        TStateReadCom2,
        TStateReadCom3,
        TStateWriteRam0,
        TStateWriteRam1,
        TStateReadRam0,
        TStateReadRam1,
        TStateWriteCom0,
        TStateWriteCom1,
        TStateWriteCom2,
        TStateWriteCom3,
        TStateWriteCom4,
        TStateDone
    );
    
    signal stateTop : TopState := TStateStart;

    signal tempAddr : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
    signal tempData : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal readData : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal temp1oe, temp1en, temp1we : STD_LOGIC := '1';
    signal tempWrn  : STD_LOGIC := '1';
    signal tempRdn  : STD_LOGIC := '1';

begin
    top: process (comclk, rst)
    begin
        if (rst = '0') then
            temp1en <= '1';
            temp1oe <= '1';
            temp1we <= '1';
            stateTop <= TStateStart;
        elsif rising_edge(comclk) then
            case stateTop is
                when TStateStart =>
                    stateTop <= TStateGetAddr;
                when TStateGetAddr =>
                    tempAddr(15 downto 0) <= sw;
                    stateTop <= TStateReadCom0;
                    temp1en <= '1';

                when TStateReadCom0 =>
                    stateTop <= TStateReadCom1;
                when TStateReadCom1 =>
                    tempRdn <= '1';
                    ram1data <= (Others => 'Z');
                    stateTop <= TStateReadCom2;
                when TStateReadCom2 =>
                    if data_ready = '1' then
                        tempRdn <= '0';
                        stateTop <= TStateReadCom3;
                    else
                        stateTop <= TStateReadCom1;
                    end if;
                when TStateReadCom3 =>  
                    readData(7 downto 0) <= ram1data(7 downto 0);
                    tempRdn <= '1';
                    tempData <= ram1Data;
                    stateTop <= TStateWriteRam0;

                when TStateWriteRam0 =>
                    temp1en <= '0';
                    temp1we <= '1';
                    ram1data <= tempData;
                    ram1addr <= tempAddr;
                    stateTop <= TStateWriteRam1;
                when TStateWriteRam1 =>
                    temp1we <= '0';
                    stateTop <= TStateReadRam0;
                when TStateReadRam0 =>
                    ram1data <= (others => 'Z');
                    temp1we <= '1';
                    temp1oe <= '0';
                    ram1addr <= tempAddr;
                    stateTop <= TStateReadRam1;
                when TStateReadRam1 =>
                    tempData <= ram1data;
                    stateTop <= TStateWriteCom0;
                when TStateWriteCom0 =>
                    ram1data <= readData + 1;
                    stateTop <= TStateWriteCom1;
                when TStateWriteCom1 =>
                    tempWrn <= '0';
                    stateTop <= TStateWriteCom2;
                when TStateWriteCom2 =>
                    tempWrn <= '1';
                    stateTop <= TStateWriteCom3;
                when TStateWriteCom3 =>
                    if tbre = '1' then
                        stateTop <= TStateWriteCom4;
                    end if;
                when TStateWriteCom4 =>
                    if tsre = '1' then
                        stateTop <= TStateDone;
                    end if;
                when TStateDone =>
                    stateTop <= TStateStart;
                when others =>
                    stateTop <= TStateStart;
            end case;
        end if;
        
    end process;

    ram1en <= temp1en;
    ram1oe <= temp1oe;
    ram1we <= temp1we;
    wrn <= tempWrn;
    rdn <= tempRdn;

end Behavioral;

