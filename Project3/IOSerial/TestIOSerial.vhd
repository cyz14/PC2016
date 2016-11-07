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
    Port ( clk : in  STD_LOGIC;   -- hand clk
           comclk : in STD_LOGIC; -- 11.9MHz
           rst : in  STD_LOGIC;   -- hand reset
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
           dyp0 : out  STD_LOGIC_VECTOR (6 downto 0);
           dyp1 : out  STD_LOGIC_VECTOR (6 downto 0);
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
        TStateReadCom,
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

    type ComReadState is (
        CStateRead0,
        CStateRead1,
        CStateRead2,
        CStateRead3
    );
    
    signal stateTop : TopState := TStateStart;
    signal stateComRead : ComReadState := CStateRead0;

    signal tempLed  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal tempAddr : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
    signal tempData : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal readData : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal temp1oe, temp1en, temp1we : STD_LOGIC := '1';
    signal tempWrn  : STD_LOGIC := '1';
    signal tempRdn  : STD_LOGIC := '1';
    signal comReadStart : STD_LOGIC := '0';
    signal comReadValid : STD_LOGIC := '0';

begin
    top: process (clk, rst)
    begin
        if (rst = '0') then
            temp1en <= '1';
            temp1oe <= '1';
            temp1we <= '1';
            dyp0 <= (others => '0');
            dyp1 <= (others => '0');
            stateTop <= TStateStart;
            tempLed <= (others => '0');
        elsif rising_edge(clk) then
            case stateTop is
                when TStateStart =>
                    stateTop <= TStateGetAddr;
                when TStateGetAddr =>
                    tempAddr(15 downto 0) <= sw;
                    tempLed <= sw;
                    stateTop <= TStateReadCom;
                    temp1en <= '1';
                    comReadStart <= '1';
                when TStateReadCom =>
                    if comReadValid = '1' then
                        tempLed(7 downto 0) <= readData(7 downto 0);
                        tempData <= readData;
                        comReadStart <= '0';
                        stateTop <= TStateWriteRam0;
                        temp1en <= '0';
                    end if;
                when TStateWriteRam0 =>
                    temp1we <= '1';
                    ram1data <= tempData;
                    ram1addr <= tempAddr;
                    stateTop <= TStateWriteRam1;
                when TStateWriteRam1 =>
                    temp1we <= '0';
                    tempLed <= tempAddr(7 downto 0) & tempData(7 downto 0);
                    stateTop <= TStateReadRam0;
                when TStateReadRam0 =>
                    ram1data <= (others => 'Z');
                    temp1we <= '1';
                    temp1oe <= '0';
                    ram1addr <= tempAddr;
                    stateTop <= TStateReadRam1;
                when TStateReadRam1 =>
                    tempData <= ram1data;
                    tempLed <= tempAddr(7 downto 0) & ram1data(7 downto 0);
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
                    tempLed <= (others => '0');
                    stateTop <= TStateStart;
                when others =>
                    stateTop <= TStateStart;
            end case;
        end if;
        
        case stateTop is
            when TStateStart => 
                dyp0 <= "0111111";
            when TStateGetAddr =>
                dyp0 <= "0000110";
            when TStateReadCom =>
                dyp0 <= "1011011";
            when TStateWriteRam0 =>
                dyp0 <= "1001111";
            when TStateWriteRam1 =>
                dyp0 <= "1100110";
            when TStateReadRam0 =>
                dyp0 <= "1101101";
            when TStateReadRam1 =>
                dyp0 <= "1111101";
            when TStateWriteCom0 =>
                dyp0 <= "0000111";
            when TStateWriteCom1 =>
                dyp0 <= "0000111";
            when TStateWriteCom2 =>
                dyp0 <= "0000111";
            when TStateWriteCom3 =>
                dyp0 <= "0000111";
            when TStateWriteCom4 =>
                dyp0 <= "0000111";
            when TStateDone =>
                dyp0 <= "1111111";
            when others =>
                dyp0 <= "0111111";
        end case;
    end process;
    
    comread: process (comclk, rst)
    begin
        if rst = '0' then
            comReadValid <= '0';
            tempRdn <= '1';
            readData <= (others => '0');
            stateComRead <= CStateRead0;
        elsif rising_edge(comclk) then
            if stateTop = TStateReadCom and comReadStart = '1' then
                case stateComRead is
                    when CStateRead0 =>
                        stateComRead <= CStateRead1;
                    when CStateRead1 =>
                        tempRdn <= '1';
                        ram1data <= (Others => 'Z');
                        stateComRead <= CStateRead2;
                    when CStateRead2 =>
                        if data_ready = '1' then
                            tempRdn <= '0';
                            stateComRead <= CStateRead3;
                        else
                            stateComRead <= CStateRead1;
                        end if;
                    when CStateRead3 =>
                        readData(7 downto 0) <= ram1data(7 downto 0);
                        tempRdn <= '1';
                        comReadValid <= '1';
                        stateComRead <= CStateRead0;
                    when others =>
                        comReadValid <= '0';
                        stateComRead <= CStateRead0;
                end case;
            else
                comReadValid <= '0';
                stateComRead <= CStateRead0;
            end if;
        end if;
    end process;

    ram1en <= temp1en;
    ram1oe <= temp1oe;
    ram1we <= temp1we;
    wrn <= tempWrn;
    rdn <= tempRdn;
    led <= tempLed;

end Behavioral;

