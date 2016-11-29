library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use WORK.COMMON.ALL;

entity ForwardingUnit is     -- 
	port(
        EXE_REGWRITE: in std_logic ;  --exe阶段的写信号
        EXE_DstReg:   in std_logic_vector (3 DOWNTO 0) ;  --exe阶段目的寄存器
        MEM_REGWRITE: in std_logic ;  --mem 阶段的写信号
        MEM_DstReg:   in std_logic_vector (3 downto 0);  --mem阶段的目的寄存器
        ASrc4:        in std_logic_vector (3 downto 0);  -- ALU 操作数A的源寄存器
        BSrc4:        in std_logic_vector (3 downto 0);  -- ALU 操作数B的源寄存器
        FORWARDA:     out std_logic_vector(1 downto 0);  --muxa信号选择
        FORWARDB:     out std_logic_vector(1 downto 0)   --muxb信号选择
	);
end ForwardingUnit;

architecture behaviour of ForwardingUnit is

signal temp_FORWARDA : STD_LOGIC_VECTOR (1 downto 0);
signal temp_FORWARDB : STD_LOGIC_VECTOR (1 downto 0);
        
begin
	FORWARDA <= temp_FORWARDA;
	FORWARDB <= temp_FORWARDB;

	process(EXE_REGWRITE,EXE_DstReg,MEM_REGWRITE,MEM_DstReg,ASrc4,BSrc4)
	begin
		temp_FORWARDA <= FWD_NONE;   --正常赋值
		temp_FORWARDB <= FWD_NONE;
		if (EXE_REGWRITE = RAM_WRITE_ENABLE) then      --取alu计算结束那个寄存器数
			if (EXE_DstReg = ASrc4)  then   
				temp_FORWARDA <= FWD_MEM;
			elsif (EXE_DstReg = BSrc4)  then
				temp_FORWARDB <= FWD_MEM;
			end if;
		end if;
		if (MEM_REGWRITE = RAM_WRITE_ENABLE) THEN   --取写回的那个寄存器数
			if(MEM_DstReg = ASrc4 and not (EXE_DstReg = ASrc4) ) then
				temp_FORWARDA <= FWD_WB;
			elsif(MEM_DstReg = BSrc4 and not (EXE_DstReg = BSrc4) ) then
				temp_FORWARDB <= FWD_WB;
			end if;
		end if;

	end process;
	
end behaviour;
		