-- LedDebug.vhd
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

USE WORK.COMMON.ALL;

ENTITY LedDebug IS PORT (
    rst              : In  STD_LOGIC;
    clk              : IN  STD_LOGIC;
    SW               : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    DebugEnable      : IN  STD_LOGIC;
    LedOut              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    Number           : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);

    if_PCKeep        : IN  STD_LOGIC := '1';
    if_NewPC         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    if_PCToIM        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    if_PCPlus1       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    if_PCRx          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    if_PCAddImm      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    if_Inst          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); --instruction from ram2

    id_Inst          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    id_PCPlus1       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    id_PCAddImm      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    id_Imme          : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
    ext_Imme         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    ctrl_CurPC       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ctrl_ImmeSrc     : IN  STD_LOGIC_VECTOR( 2 DOWNTO 0);
    ctrl_ZeroExt     : IN  STD_LOGIC;
    ctrl_ALUOp       : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    ctrl_ASrc        : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    ctrl_BSrc        : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    ctrl_MemRead     : IN  STD_LOGIC;
    ctrl_MemWE       : IN  STD_LOGIC;
    ctrl_DstReg      : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    ctrl_RegWE       : IN  STD_LOGIC;
    ctrl_ASrc4       : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    ctrl_BSrc4       : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    ctrl_PCMuxSel    : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    ctrl_ExceptPC    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ctrl_NowPC       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ctrl_InDelayslot : IN  STD_LOGIC;

    rf_Data1         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    rf_Data2         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    id_data1         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    id_data2         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    exe_Data1        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    exe_Data2        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    exe_Imme         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    exe_DstReg       : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    exe_RegWE        : IN  STD_LOGIC;
    exe_MemRead      : IN  STD_LOGIC;
    exe_MemWE        : IN  STD_LOGIC;
    exe_ALUOp        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    exe_ASrc         : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    exe_BSrc         : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    exe_BOp          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    exe_ASrc4        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    exe_BSrc4        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    exe_MemWriteData : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    exe_InDelayslot  : IN  STD_LOGIC;
    exe_PCSel        : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);

    alu_F            : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    alu_T            : IN  STD_LOGIC;

    mem_DstReg       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    mem_RegWE        : IN  STD_LOGIC;
    mem_MemWE        : IN  STD_LOGIC;
    mem_MemRead      : IN  STD_LOGIC;
    mem_ALUOut       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    mem_WriteData    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    mem_ReadData     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    mem_DstVal       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    mem_vga_wrn      : IN  STD_LOGIC;
    mem_vga_data     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    mem_vgaR         : IN  STD_LOGIC_VECTOR( 2 DOWNTO 0);
    mem_vgaG         : IN  STD_LOGIC_VECTOR( 2 DOWNTO 0);
    mem_vgaB         : IN  STD_LOGIC_VECTOR( 2 DOWNTO 0);

    wb_DstReg        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    wb_RegWE         : IN  STD_LOGIC;
    wb_DstVal        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);    

    ram1_en          : IN  STD_LOGIC;
    ram1_oe          : IN  STD_LOGIC;
    ram1_we          : IN  STD_LOGIC;
    ram2_en          : IN  STD_LOGIC;
    ram2_oe          : IN  STD_LOGIC;
    ram2_we          : IN  STD_LOGIC;
    ram1_data        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); 
    ram1_addr        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ram2_data        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); 
    ram2_addr        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    ram1_InstRead    : IN  STD_LOGIC;
    ram1_NowPC       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ram1_Except      : IN  STD_LOGIC;
    ram1_ExceptPC    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ram1_LED         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ram1_numout      : IN  STD_LOGIC_VECTOR( 7 DOWNTO 0);
    ram2_LED         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    ram2_numout      : IN  STD_LOGIC_VECTOR( 7 DOWNTO 0);
    

    fwd_ForwardA     : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
    fwd_ForwardB     : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);

    hdu_IFID_Keep    : IN  STD_LOGIC;
    hdu_IDEX_Stall   : IN  STD_LOGIC
);

END LedDebug;

ARCHITECTURE Bhv OF LedDebug IS
    
    SubType InfoLine IS STD_LOGIC_VECTOR(15 DOWNTO 0);
    Type DebugInfos IS array(natural range<>) of InfoLine;

    SIGNAL infos : DebugInfos(0 to 63);
BEGIN
    infos( 0) <= if_PCToIM;
    infos( 1) <= ZERO15 & if_PCKeep;
    infos( 2) <= if_PCRx;
    infos( 3) <= if_PCAddImm;
    infos( 4) <= if_Inst; 
    infos( 5) <= ZERO16;
    infos( 6) <= ZERO16;
    infos( 7) <= ZERO16;

    infos( 8) <= id_Inst;
    infos( 9) <= id_PCPlus1;
    infos(10) <= id_PCAddImm;
    infos(11) <= ZERO5 & id_Imme;
    infos(12) <= ext_Imme;
    infos(13) <= ZERO8 & fwd_ForwardA & ZERO2 & fwd_ForwardB & ZERO2;
    infos(14) <= ZERO15 & hdu_IFID_Keep;
    infos(15) <= ZERO16;

    infos(16) <= ZERO8 & ctrl_ImmeSrc & ctrl_ZeroExt & ctrl_PCMuxSel & ctrl_InDelayslot & hdu_IDEX_Stall;
    infos(17) <= ctrl_ASrc4 & ctrl_ASrc & ctrl_BSrc4 & ctrl_BSrc & ctrl_ALUOp;
    infos(18) <= rf_Data1;
    infos(19) <= rf_Data2;
    infos(20) <= id_data1;
    infos(21) <= id_data2;
    infos(22) <= ZERO16;
    infos(23) <= ZERO16;

    infos(24) <= exe_Data1;
    infos(25) <= exe_Data2;
    infos(26) <= exe_Imme;
    infos(27) <= ZERO9 & exe_MemRead & exe_MemWE & exe_DstReg & exe_RegWE;
    infos(28) <= exe_ASrc4 & exe_ASrc & exe_BSrc4 & exe_BSrc & exe_ALUOp;
    infos(29) <= exe_BOp; -- ALU_B
    infos(30) <= exe_MemWriteData;
    infos(31) <= ZERO14 & exe_PCSel;

    infos(32) <= alu_F;
    infos(33) <= ZERO8 & ram1_en & ram1_oe & ram1_we & ZERO1 & ram2_en & ram2_oe & ram2_we & ZERO1;
    infos(34) <= ram1_data;
    infos(35) <= ram1_addr;
    infos(36) <= ram2_data;
    infos(37) <= ram2_addr;
    infos(38) <= ZERO16;
    infos(39) <= ZERO16;

    infos(40) <= ZERO9 & mem_MemRead & mem_MemWE & mem_DstReg & mem_RegWE;
    infos(41) <= mem_ALUOut;
    infos(42) <= mem_WriteData;
    infos(43) <= mem_ReadData;
    infos(44) <= mem_DstVal;
    infos(45) <= ZERO16;
    infos(46) <= wb_RegWE & ZERO11 & wb_DstReg;
    infos(47) <= wb_DstVal;
    
    infos(48) <= ZERO16;
    infos(49) <= ZERO16;
    infos(50) <= ZERO16;
    infos(51) <= ZERO16;
    infos(52) <= ZERO16;
    infos(53) <= ZERO16;
    infos(54) <= ZERO16;
    infos(55) <= ZERO16;
    infos(56) <= ZERO16;
    infos(57) <= ZERO16;
    infos(58) <= ZERO16;
    infos(59) <= ZERO16;
    infos(60) <= ZERO16;
    infos(61) <= ZERO16;
    infos(62) <= ZERO16;
    infos(63) <= ZERO16;

    PROCESS(clk, rst, SW, DebugEnable)
        Variable index : integer range 0 to 63;
    BEGIN
        if rst = '0' then
            LedOut <= ZERO16;
        elsif clk'event and clk = '1' then
            index := conv_integer(SW(5 DOWNTO 0));
            LedOut <= infos(index);
        end if;
    END PROCESS;
END Bhv;