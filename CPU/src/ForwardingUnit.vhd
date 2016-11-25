library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ForwardingUnit is     -- 
	port(
		EXE_MEM_REGWRITE : in std_logic ;  --exe_mem�׶μĴ�����д�ź�
        EXE_MEM_RD       : in std_logic_vector (3 DOWNTO 0) ;  --exe_mem�׶�Ŀ�ļĴ���
        MEM_WB_REGWRITE  : in std_logic ;  --mem_wb �׶μĴ�����д�ź�
        MEM_WB_RD        : in std_logic_vector (3 downto 0);  --mem_wb�׶μĴ�����Ŀ�ļĴ������
        ASrc4            : in std_logic_vector (3 downto 0);  -- ALU ������A��Դ�Ĵ���
        BSrc4            : in std_logic_vector (3 downto 0);  -- ALU ������B��Դ�Ĵ���
        FORWARDA         : out std_logic_vector(1 downto 0);  --muxa�ź�ѡ��
		FORWARDB         : out std_logic_vector(1 downto 0)   --muxb�ź�ѡ��
	);
end ForwardingUnit;

architecture behaviour of ForwardingUnit is

signal temp_FORWARDA : STD_LOGIC_VECTOR (1 downto 0);
signal temp_FORWARDB : STD_LOGIC_VECTOR (1 downto 0);
        
begin
	FORWARDA <= temp_FORWARDA;
	FORWARDB <= temp_FORWARDB;

	process(EXE_MEM_REGWRITE,EXE_MEM_RD,MEM_WB_REGWRITE,MEM_WB_RD,ASrc4,BSrc4)
	begin
		temp_FORWARDA <= "00";   --������ֵ
		temp_FORWARDB <= "00";
		if (EXE_MEM_REGWRITE = '1') then      --ȡalu��������Ǹ��Ĵ�����
			if (EXE_MEM_RD = ASrc4)  then   
				temp_FORWARDA <= "01";
			elsif (EXE_MEM_RD = BSrc4)  then
				temp_FORWARDB <= "01";
			end if;
		end if;
		
		if (MEM_WB_REGWRITE = '1' ) THEN      --ȡд�ص��Ǹ��Ĵ�����
			if(MEM_WB_RD = ASrc4) then
				temp_FORWARDA <= "10";
			elsif(MEM_WB_RD = BSrc4) then
				temp_FORWARDB <= "10";
			end if;
		end if;

	end process;
	
end behaviour;
		