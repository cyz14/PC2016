----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:56:57 11/23/2016 
-- Design Name: 
-- Module Name:    Clock - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock is port (
    rst:    in  std_logic;
    clk:    in  std_logic;
    clk11:  in  std_logic;
    clk50:  in  std_logic;
    sel:    in  std_logic_vector(1 downto 0);
    clkout: out std_logic
);
end Clock;

architecture Behavioral of Clock is
    
    signal clk25 : std_logic;
    signal tmp   : std_logic;
    signal clk17 : std_logic;
    signal clk12 : std_logic;
    signal clk6  : std_logic;
    
begin

    with sel select clkout <= 
        not(clk25 and clk50) when "11", -- clk25
        not clk17 when "10",
        clk12 when "00",
        clk6 when others;

    PROCESS(rst, clk50)
    Begin
        if rst = '0' then
            clk25 <= '1';
            clk17 <= '1';
        elsif clk50'event and clk50 = '0' then
            clk25 <= not clk25;
            tmp <= clk17;
            if clk17 = '1' then
                clk17 <= '0';
            elsif tmp = '0' then
                clk17 <= '1';
            end if;
        end if;
    END PROCESS;


    PROCESS(rst, clk25) -- 25M to 12.5M
    BEGIN
        if rst = '0' then
            clk12 <= '1';
        elsif clk25'event and clk25 = '0' then
            clk12 <= not clk12;
        end if;
    END PROCESS;
    
    PROCESS(rst, clk12)
    BEGIN
        if rst = '0' then
            clk6 <= '1';
        elsif clk12'event and clk12 = '0' then
            clk6 <= clk6;
        end if;
    END PROCESS;
end Behavioral;

