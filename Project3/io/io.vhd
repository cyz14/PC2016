----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:46:42 11/01/2016 
-- Design Name: 
-- Module Name:    io - Behavioral 
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

entity io is
	port(
		clk,rst:in STD_LOGIC;  --输入时钟和复原信号
		input: in std_logic_vector(15 downto 0);
		ram_1_addr: out std_logic_vector(17 downto 0);  --ram1地址
		ram_1_data:inout std_logic_vector(15 downto 0);
		ram_1_oe,ram_1_we,ram_1_en: out STD_LOGIC; --RAM1读使能、写使能、使能
		ram_2_addr: out std_logic_vector(17 downto 0);
		ram_2_data:inout std_logic_vector(15 downto 0);
		ram_2_oe,ram_2_we,ram_2_en: out STD_LOGIC; --RAM2读使能、写使能、使能
		led:out std_logic_vector(6 downto 0);   --7位数码管测试输出
		led_out: out STD_LOGIC_VECTOR(15 downto 0); --发光二极管显示地址低8位及数据低8位
		rdn: out STD_LOGIC; --锁住串口
		wrn: out STD_LOGIC --锁住串口
		);
end io;

architecture Behavioral of io is
type States is(st_0,st_1,st_2,st_3,st_4,st_5, st_6,st_7,st_8,st_9,st_10,st_11,st_12);
    signal state: States := st_0; --初态
	 SHARED VARIABLE tempAddr: STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000"; --暂存地址的临时变量
	 SHARED VARIABLE tempData: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; --暂存数据的临时变量
	 SHARED VARIABLE count: INTEGER RANGE 0 TO 10 := 0; --记录读写的次数 10次为上限
	 SHARED VARIABLE temp_1_oe,temp_1_we,temp_2_oe,temp_2_we: STD_LOGIC := '1'; --暂存使能信号
	 SHARED VARIABLE temp_1_en,temp_2_en: STD_LOGIC := '0'; --暂存使能信号
begin
	process(clk,rst)
		begin
			if(rst= '0')then
				tempAddr :="000000000000000000";
				tempData :="0000000000000000";
				count    :=0;
				state    <=st_0;
				temp_1_oe := '1';
				temp_2_oe := '1';
				temp_1_we := '1';
				temp_2_we := '1';
				temp_1_en := '0';
				temp_2_en := '0';
				ram_1_data <= "0000000000000000";
				ram_2_data <= "0000000000100000";
				ram_1_addr <= "000000000000000000";
				ram_2_addr <= "000000000000000000";
			elsif(clk'event and clk ='1') then
				case state is
					when st_0 =>
						 tempAddr(15 downto 0) := input;
					     state <= st_1;
					when st_1 =>
						tempData := input;
						temp_1_we := '0';
						ram_1_addr <= tempAddr;
						ram_1_data <= tempData;
						count := count + 1;
						state <= st_2;
					when st_2 =>
						temp_1_we :='1';
						state <= st_3;
					when st_3 =>
						temp_1_we := '0';
						tempData := tempData+'1';
						tempAddr := tempAddr +'1';
						ram_1_data <=tempData;
						ram_1_addr <=tempAddr;
						count := count + 1;
						if(count <10) then
							state <= st_2;
						elsif(count = 10) then
							state <= st_4;
							count :=0;
						end if;
					when st_4 =>
						ram_1_data <= "ZZZZZZZZZZZZZZZZ";
					   temp_1_we := '1';
						temp_1_oe := '0';
						state <= st_5;
						ram_1_addr <= tempAddr;
				   when st_5 => --第6个状态 读RAM1 需要10次
					   tempData := ram_1_data;
					   count := count + 1;
				   	tempAddr := tempAddr - '1';
						ram_1_addr <= tempAddr;
						if(count = 10) then
						   count := 0;
							ram_1_addr <= tempAddr + '1';
						   state <= st_6;
						end if;
					when st_6 => --第7个状态 切换到RAM2 需要将RAM1的读和写信号拉高 准备写入第一个数据
                    temp_1_oe := '1';
						  temp_1_we := '1';
						  tempData := tempData - '1';
						  tempAddr := tempAddr + '1';
						  state <= st_7;
						  	  
				    when st_7 => --第8个状态 写入剩下的10个数据
					     temp_2_we := '0';
						  ram_2_data <= tempData;
						  ram_2_addr <= tempAddr;
						  count := count + 1;
						  state <= st_8;
						  
				    when st_8 => --第9个状态 拉高写信号
					     temp_2_we := '1';
						  state <= st_9;
						  
				    when st_9 => --第10个状态 拉低写信号 继续写
					     temp_2_we := '0';
					     tempData := tempData + '1';
						  tempAddr := tempAddr + '1';
						  ram_2_data <= tempData;
						  ram_2_addr <= tempAddr;
						  count := count + 1;
						  if(count < 10) then
								state <= st_8;
						  elsif(count = 10) then
						      state <= st_10;
								count := 0;
						  end if;
						  
					 when st_10 => --第11个状态 准备读RAM2 需要拉高写信号 拉低读信号 同时将数据线设置成高阻
						  ram_2_data <= "ZZZZZZZZZZZZZZZZ";
					     temp_2_we := '1';
						  temp_2_oe := '0';
						  state <= st_11;
					 
					 when st_11 => --第12个状态 继续读
					     tempData := ram_2_data;
						  count := count + 1;
						  tempAddr := tempAddr - '1'; 
						  ram_2_addr <= tempAddr;
						  if(count = 10) then
						      count := 0;
								ram_2_addr <= tempAddr + '1';
						      state <= st_12;
						  end if;
				    when others=>
			   end case;
		  end if;
		  
		  led_out(15 downto 8) <= tempAddr(7 downto 0); --输出地址低8位
		  led_out(7 downto 0) <= tempData(7 downto 0); --输出数据低8位
		  
		  ram_1_oe <= temp_1_oe;
		  ram_2_oe <= temp_2_oe;
		  ram_1_we <= temp_1_we;
		  ram_2_we <= temp_2_we;
		  ram_1_en <= temp_1_en;
		  ram_2_en <= temp_2_en;
		  
		  rdn <= '1';
		  wrn <= '1';
		  			
		  --输出状态信息到数码管 数码管a对应DYP0的高位
		  case state is
				when st_0=> led <= "0111111";
				when st_1=> led <= "0000110";
				when st_2=> led <= "1011011";
				when st_3=> led <= "1001111";
				when st_4=> led <= "1100110";
				when st_5=> led <= "1101101";
				when st_6=> led <= "1111101";
				when st_7=> led <= "0000111";
				when st_8=> led <= "1111111";
				when st_9=> led <= "1101111";
				when st_10 => led <= "0111111";
				when st_11 => led <= "0000110";
				when others=> led <= "0000000";
	
		  end case;

	 end process;


end Behavioral;

