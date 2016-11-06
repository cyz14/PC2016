----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:23:49 11/04/2016 
-- Design Name: 
-- Module Name:    TestSerial - Behavioral 
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

entity TestSerial is
    Port ( clk :        in     STD_LOGIC;
           rst :        in     STD_LOGIC;
           -- sw :         in     STD_LOGIC_VECTOR (15 downto 8); -- not used in the expriment
           led :        out    STD_LOGIC_VECTOR (7 downto 0);
           ram1data :   inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1oe :     out    STD_LOGIC;
           ram1we :     out    STD_LOGIC;
           ram1en :     out    STD_LOGIC;
           data_ready : in     STD_LOGIC;
           rdn :        out    STD_LOGIC;
           tbre :       in     STD_LOGIC;
           tsre :       in     STD_LOGIC;
           wrn :        out    STD_LOGIC);
end TestSerial;

architecture Behavioral of TestSerial is
    type State is (st0, r_st1, r_st2, r_st3, w_st0, w_st1, w_st2, w_st3, w_st4);

    signal cur_st : State := st0;
    
    signal temp_led   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal temp_data  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 
begin
    ram1en <= '1';
    
    top_control: process(clk, rst)
    begin
        if (rst = '0') then
            temp_led <= "00000000";
            ram1en <= '1';
            ram1we <= '1';
            ram1oe <= '1';
            wrn <= '1';
			cur_st <= st0;
        elsif rising_edge(clk) then
            case cur_st is
                when st0 =>
                    cur_st <= r_st1;
                when r_st1 =>
                    rdn <= '1';
                    ram1data <= (Others => 'Z');
                    cur_st <= r_st2;
                when r_st2 =>
                    if data_ready = '1' then
                        rdn <= '0';
                        cur_st <= r_st3;
                    else
                        cur_st <= r_st1;
                    end if;
                when r_st3 =>
                    temp_led <= ram1data;
                    temp_data <= ram1data;
                    cur_st <= w_st0;
                    rdn <= '1';
                when w_st0 =>
                    ram1data <= temp_data + 1; -- may overflow here , but doesn't matter in test
                    cur_st <= w_st1;
                when w_st1 =>
                    wrn <= '0';
                    cur_st <= w_st2;
                when w_st2 =>
                    wrn <= '1';
                    cur_st <= w_st3;
                when w_st3 =>
                    if tbre = '1' then
                        cur_st <= w_st4;
                    else
                        cur_st <= w_st3;
                    end if;
                when w_st4 =>
                    if tsre = '1' then
                        cur_st <= st0;
                    else
                        cur_st <= w_st4;
                    end if;
                when others =>
                    cur_st <= st0;
            end case;
        end if;
    end process;

    led <= temp_led;

end Behavioral;

