library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ForwardingUnit is     -- 
	port(
		EXE_MEM_REGWRITE : in std_logic ;  --exe_mem阶段寄存器的写信号
		EXE_MEM_RD      : in std_logic_vector (3 DOWNTO 0) ;  --exe_mem阶段目的寄存器编号
		MEM_WB_REGWRITE : in std_logic ;  --mem_wb阶段寄存器的写信号
		MEM_WB_RD       : in std_logic_vector (3 downto 0);  --mem_wb阶段寄存器的目的寄存器编号
		ID_EX_RX        : in std_logic_vector (3 downto 0);  --rx寄存器编号
		ID_EX_RY        : in std_logic_vector (3 downto 0);  --ry寄存器编号
		FORWARDA        : out std_logic_vector(1 downto 0);  --muxa信号选择
		FORWARDB        : out std_logic_vector(1 downto 0);   --muxb信号选择

	    temp_FORWARDA : INOUT STD_LOGIC_VECTOR (1 downto 0);
        temp_FORWARDB : INOUT std_logic_vector (1 downto 0)
		
	);
end ForwardingUnit;

architecture behaviour of ForwardingUnit is

begin
	process(EXE_MEM_REGWRITE,EXE_MEM_RD,MEM_WB_REGWRITE,MEM_WB_RD,ID_EX_RX,ID_EX_RY)
	begin
		temp_FORWARDA <= "00";   --正常赋值
		temp_FORWARDB <= "00";
		if (EXE_MEM_REGWRITE = '1') then      --取alu计算结束那个寄存器数据
			if (EXE_MEM_RD = ID_EX_RX)  then   
				temp_FORWARDA <= "01";
			END IF;
			if (EXE_MEM_RD = ID_EX_RY)  then
				temp_FORWARDB <= "01";
			end if;
		END IF;
		
		if (MEM_WB_REGWRITE = '1' ) THEN      --取写会的那个寄存器数据
			if(MEM_WB_RD = ID_EX_RX) then
				temp_FORWARDA <= "10";
			end if;		
			if(MEM_WB_RD = ID_EX_RY) then
				temp_FORWARDB <= "10";
			end if;
		end if;
		
		
		
		FORWARDA <= temp_FORWARDA;
		FORWARDB <= temp_FORWARDB;
		
	end process;
	
end behaviour;
		