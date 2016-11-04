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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestSerial is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1oe : out  STD_LOGIC;
           ram1we : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           data_ready : out  STD_LOGIC;
           rdn : out  STD_LOGIC;
           tbre : out  STD_LOGIC;
           tsre : out  STD_LOGIC;
           wrn : out  STD_LOGIC);
end TestSerial;

architecture Behavioral of TestSerial is
	type ControlState is (c_st0, c_st1, c_st2);
	type ReadState is (r_st0, r_st1, r_st2, r_st3, r_st4);
	type WriteState is (w_st0, w_st1, w_st2, w_st3);

    signal st_top : ControlState := c_st0;
    signal st_read : ReadState := r_st0;
    signal st_write : WriteState := w_st0;
    
    signal temp_led : STD_LOGIC_VECTOR(7 downto 0);
begin
	ram1en <= '1';
    
    top_control: process(clk, rst)
    begin
        if (rst = '0') then
            st_top <= c_st0;
            st_write <= w_st0;
            led <= "0000000";
            
        elsif rising_edge(clk) then
            case st_top is
                when c_st0 => 
                    st_top <= c_st1;
                when c_st1 =>
                    st_top <= c_st2;
                when others =>
                    st_top <= c_st0;
            end case;
        end if;
    end process;
    
    read_control: process(clk, rst)
    begin
        if (rst = '0') then
            rdn <= '1';
            ram1data <= "ZZZZZZZZ";
            st_read <= r_st0;
        elsif rising_edge(clk) then
            case st_read is
                when r_st0 =>
                    st_read <= r_st1;
                when r_st1 =>
                    if data_ready = '1' then
                        rdn <= '0';
                        st_read <= r_st2;
                    end if;
                when r_st2 =>
                    temp_led <= ram1data;
                    st_read <= r_st0; 
                when others =>
                    st_read <= r_st0;
            end case;
        end if;
    end process;

    write_control: process(clk, rst)
    begin
        if (rst = '0') then
            st_write <= w_st0;
        elsif rising_edge(clk) then

        end if;
    end process;

    led <= temp_led;

end Behavioral;

