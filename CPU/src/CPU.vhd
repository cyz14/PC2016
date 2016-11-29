-- CPU.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

USE WORK.COMMON.ALL;

ENTITY CPU IS PORT (
    CLK     :    IN    STD_LOGIC; -- 
    CLK_11  :    IN    STD_LOGIC; -- 11M
    CLK_50  :    IN    STD_LOGIC; -- 50M
    RST     :    IN    STD_LOGIC;

    INT     :    IN    STD_LOGIC;
    
    Ram1_en:     OUT   STD_LOGIC;
    Ram1_oe:     OUT   STD_LOGIC;
    Ram1_we:     OUT   STD_LOGIC;
    RAM1_Addr:   OUT   STD_LOGIC_VECTOR(17 downto 0);
    Ram1_Data:   INOUT STD_LOGIC_VECTOR(15 downto 0);
    Ram2_en:     OUT   STD_LOGIC;
    Ram2_oe:     OUT   STD_LOGIC;
    Ram2_we:     OUT   STD_LOGIC;
    RAM2_Addr:   OUT   STD_LOGIC_VECTOR(17 downto 0);
    Ram2_Data:   INOUT STD_LOGIC_VECTOR(15 downto 0);
    
    rdn:         OUT   STD_LOGIC;
    wrn:         OUT   STD_LOGIC;
    data_ready:  IN    STD_LOGIC;
    tbre:        IN    STD_LOGIC;
    tsre:        IN    STD_LOGIC;
    
    ps2clk     : in    STD_LOGIC;
	ps2data    : in    STD_LOGIC;

    VGA_R:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_G:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_B:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    Hs:          OUT   STD_LOGIC;
    Vs:          OUT   STD_LOGIC;
    
    --FLASH
    -- flash_byte : OUT STD_LOGIC := '1'; 
    -- flash_vpen : OUT STD_LOGIC := '1';
    -- flash_ce   : OUT STD_LOGIC := '0';
    -- flash_oe   : OUT STD_LOGIC := '1';
    -- flash_we   : OUT STD_LOGIC := '1';
    -- flash_rp   : OUT STD_LOGIC := '0';
    -- flash_addr : OUT STD_LOGIC_VECTOR( 22 downto 1 ) := "0000000000000000000000";
    -- flash_data : INOUT STD_LOGIC_VECTOR( 15 downto 0 );
    
    -- used to display debug info
    SW         : IN    STD_LOGIC_VECTOR(15 downto 0);
    LED        : OUT   STD_LOGIC_VECTOR(15 downto 0);
    Number1    : OUT   STD_LOGIC_VECTOR( 6 downto 0);
    Number0    : OUT   STD_LOGIC_VECTOR( 6 downto 0)
);
END CPU;

ARCHITECTURE Behaviour OF CPU IS

    Component PCMUX IS PORT (
        clk, rst:      IN STD_LOGIC;
        PCAdd1_data:   IN STD_LOGIC_VECTOR(15 downto 0);
        PCRx_data:     IN STD_LOGIC_VECTOR(15 downto 0);
        PCAddImm_data: IN STD_LOGIC_VECTOR(15 downto 0);
        PC_choose:     IN STD_LOGIC_VECTOR(1 downto 0);
        PCout:         out STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component; 

    Component PCReg IS Port (
        PCSrc : IN STD_LOGIC_VECTOR(15 downto 0);
        keep : IN STD_LOGIC;
        PC : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component PCAdd1 IS Port (
        PCin  : IN   STD_LOGIC_VECTOR (15 downto 0);
        PCOUT : OUT  STD_LOGIC_VECTOR (15 downto 0)
    );
    End Component;

    Component IM_RAM2 IS PORT (
        clk:           IN    STD_LOGIC;
        rst:           IN    STD_LOGIC;
        PC_i:          IN    STD_LOGIC_VECTOR(15 downto 0);
        mem_MemRead:   IN    STD_LOGIC;
        mem_MemWE:     IN    STD_LOGIC;
        mem_ALUOut:    IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Address
        mem_WriteData: IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Data
        Ram2_Addr:     OUT   STD_LOGIC_VECTOR(17 downto 0);
        Ram2_Data:     inout STD_LOGIC_VECTOR(15 downto 0);
        Ram2_OE:       OUT   STD_LOGIC;
        Ram2_WE:       OUT   STD_LOGIC;
        Ram2_EN:       OUT   STD_LOGIC;
        Ram2_Inst:     OUT   STD_LOGIC_VECTOR(15 downto 0)
        -- ;

        -- LedSel:        IN    STD_LOGIC_VECTOR(15 downto 0);
        -- LedOut:        OUT   STD_LOGIC_VECTOR(15 downto 0);
        -- NumOut:        OUT   STD_LOGIC_VECTOR( 7 downto 0)
        );
    End Component;

    Component MUX_IF_ID IS PORT (
        clk          :  IN  STD_LOGIC;
        rst          :  IN  STD_LOGIC;
        if_Keep      :  IN  STD_LOGIC;
        if_PCPlus1   :  IN  STD_LOGIC_VECTOR(15 downto 0);
        if_Inst      :  IN  STD_LOGIC_VECTOR(15 downto 0);
        id_PCPlus1   :  OUT STD_LOGIC_VECTOR(15 downto 0);
        id_Inst      :  OUT STD_LOGIC_VECTOR(15 downto 0);
        id_Imme      :  OUT STD_LOGIC_VECTOR(10 downto 0)
    );
    END Component;

    Component ControlUnit IS PORT (
        clk         :  IN  STD_LOGIC;
        rst         :  IN  STD_LOGIC;
        CurPC       :  IN  STD_LOGIC_VECTOR(15 downto 0);
        Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
        Condition   :  IN  STD_LOGIC_VECTOR(15 downto 0);
        InDelayslot :  IN  STD_LOGIC;
        LastPCSel   :  IN  STD_LOGIC_VECTOR( 1 downto 0);
        ImmeSrc     :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- 3, 4, 5, 8, 11 
        ZeroExt     :  OUT STD_LOGIC;                     

        ALUop       :  OUT STD_LOGIC_VECTOR( 3 downto 0);
        ASrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);
        BSrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);

        MemRead     :  OUT STD_LOGIC;
        MemWE       :  OUT STD_LOGIC;    

        DstReg      :  OUT STD_LOGIC_VECTOR( 3 downto 0);
        RegWE       :  OUT STD_LOGIC;
        
        ASrc4       :  out std_logic_vector (3 downto 0);
        BSrc4       :  out std_logic_vector (3 downto 0);
        NextInDelayslot : OUT STD_LOGIC;
        PCMuxSel    :  OUT STD_LOGIC_VECTOR( 1 downto 0)
        -- ;

        -- NowPC       :  OUT STD_LOGIC_VECTOR(15 downto 0);
        -- ExceptPC    :  OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component ImmExtend IS port(
        ImmeSrc     : IN  STD_LOGIC_VECTOR(2 downto 0);
        inImme      : IN  STD_LOGIC_VECTOR(10 downto 0);
        ZeroExtend  : IN  STD_LOGIC;
        Imme        : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component PCAddImm IS Port (
        PCin  : IN   STD_LOGIC_VECTOR (15 downto 0);
        Imm   : IN   STD_LOGIC_VECTOR (15 downto 0);
        PCout : OUT  STD_LOGIC_VECTOR (15 downto 0));
    END Component;
    
    Component MUX_ID_EXE IS PORT (
        clk:          IN     STD_LOGIC;
        rst:          IN     STD_LOGIC;
        Data1:        IN     STD_LOGIC_VECTOR(15 downto 0);
        Data2:        IN     STD_LOGIC_VECTOR(15 downto 0);
        Immediate:    IN     STD_LOGIC_VECTOR(15 downto 0);
        DstReg:       IN     STD_LOGIC_VECTOR( 3 downto 0);
        RegWE:        IN     STD_LOGIC;
        MemRead:      IN     STD_LOGIC;
        MemWE:        IN     STD_LOGIC;
        ALUOp:        IN     STD_LOGIC_VECTOR( 3 downto 0);
        ASrc:         IN     STD_LOGIC_VECTOR( 1 downto 0);
        BSrc:         IN     STD_LOGIC_VECTOR( 1 downto 0);
        ASrc4:        IN     STD_LOGIC_VECTOR( 3 downto 0);
        BSrc4:        IN     STD_LOGIC_VECTOR( 3 downto 0);
        InDelayslot:  IN     STD_LOGIC;
        PCSel:        IN     STD_LOGIC_VECTOR( 1 downto 0);  
        InDelayslot_o:OUT    STD_LOGIC;
        PCSel_o:      OUT    STD_LOGIC_VECTOR( 1 downto 0);
        Stall:        IN     STD_LOGIC; -- whether stop for a stage from HazardDetectingUnit
        Data1_o:      OUT    STD_LOGIC_VECTOR(15 downto 0);
        Data2_o:      OUT    STD_LOGIC_VECTOR(15 downto 0);
        Immediate_o:  OUT    STD_LOGIC_VECTOR(15 downto 0);
        DstReg_o:     OUT    STD_LOGIC_VECTOR( 3 downto 0);
        RegWE_o:      OUT    STD_LOGIC;
        MemRead_o:    OUT    STD_LOGIC;
        MemWE_o:      OUT    STD_LOGIC;
        ALUOp_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
        ASrc_o:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
        BSrc_o:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
        ASrc4_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
        BSrc4_o:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
        MemWriteData: OUT    STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_Write_Data IS PORT (
        MemRead:   IN  STD_LOGIC;
        MemALUOut: IN  STD_LOGIC_VECTOR(15 downto 0);
        MemData:   IN  STD_LOGIC_VECTOR(15 downto 0);
        WriteData: OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_ALU_A IS PORT (
        ASrc:        IN  STD_LOGIC_VECTOR( 1 downto 0);
        ForwardingA: IN  STD_LOGIC_VECTOR( 1 downto 0);
        Data1:       IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate:   IN  STD_LOGIC_VECTOR(15 downto 0);
        ALUOut:      IN  STD_LOGIC_VECTOR(15 downto 0);
        MemDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
        AOp:         OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    End Component;

    Component MUX_Data2 IS PORT (
        ForwardingB: IN  STD_LOGIC_VECTOR( 1 downto 0);
        Data2:       IN  STD_LOGIC_VECTOR(15 downto 0);
        ALUOut:      IN  STD_LOGIC_VECTOR(15 downto 0);
        MemDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
        BOp:         OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_ALU_B IS PORT (
        BSrc:      IN  STD_LOGIC_VECTOR( 1 downto 0);
        Data2:     IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate: IN  STD_LOGIC_VECTOR(15 downto 0);
        BOp:       OUT STD_LOGIC_VECTOR(15 downto 0) := ZERO16
    );
    END Component;

    Component ALU IS PORT (
        A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        OP :  IN  STD_LOGIC_VECTOR( 3 downto 0);
        F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
        T  :  OUT STD_LOGIC
    );
    END Component;

    Component RegisterFile IS PORT (
        rst:           IN  STD_LOGIC;
        clk:           IN  STD_LOGIC;
        PCplus1:       IN  STD_LOGIC_VECTOR(15 downto 0);
        RegWE:         IN  STD_LOGIC;
        WriteRegister: IN  STD_LOGIC_VECTOR( 3 downto 0);
        WriteData:     IN  STD_LOGIC_VECTOR(15 downto 0);
        ASrc4:         IN  STD_LOGIC_VECTOR( 3 downto 0);
        BSrc4:         IN  STD_LOGIC_VECTOR( 3 downto 0);
        Data1:         OUT STD_LOGIC_VECTOR(15 downto 0);
        Data2:         OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_EXE_MEM IS PORT (
        rst             : IN  STD_LOGIC;
        clk             : IN  STD_LOGIC;
        DstReg          : IN  STD_LOGIC_VECTOR(3 downto 0);
        RegWE           : IN  STD_LOGIC;
        MemRead         : IN  STD_LOGIC;
        MemWE           : IN  STD_LOGIC;
        MemWriteData    : IN  STD_LOGIC_VECTOR(15 downto 0);
        ALUOut          : IN  STD_LOGIC_VECTOR(15 downto 0);
        T               : IN  STD_LOGIC;
        Stall           : IN  STD_LOGIC;
        o_DstReg        : OUT STD_LOGIC_VECTOR(3 downto 0);
        o_RegWE         : OUT STD_LOGIC;
        o_MemRead       : OUT STD_LOGIC;
        o_MemWE         : OUT STD_LOGIC;
        o_MemWriteData  : OUT STD_LOGIC_VECTOR(15 downto 0);
        o_ALUOut        : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component DM_RAM1 IS port (
        CLK           : IN   STD_LOGIC;
        RST           : IN   STD_LOGIC;
        
        MemWE         : IN   STD_LOGIC;
        WriteData     : IN   STD_LOGIC_VECTOR(15 downto 0);
        MemRead       : IN   STD_LOGIC;
        ALUOut        : IN   STD_LOGIC_VECTOR(15 downto 0); -- if MemWE, this is Address
        
        InstRead      : IN   STD_LOGIC;
        InstVal       : IN   STD_LOGIC_VECTOR(15 downto 0);
        
        DstVal        : OUT  STD_LOGIC_VECTOR(15 downto 0);
        
        Ram1OE        : OUT   STD_LOGIC;
        Ram1WE        : OUT   STD_LOGIC;
        Ram1EN        : OUT   STD_LOGIC;
        Ram1Addr      : OUT   STD_LOGIC_VECTOR(17 downto 0);
        Ram1Data      : INOUT STD_LOGIC_VECTOR(15 downto 0);
        
        rdn           : OUT  STD_LOGIC;
        wrn           : OUT  STD_LOGIC;
        data_ready    : IN   STD_LOGIC;
        tbre          : IN   STD_LOGIC;
        tsre          : IN   STD_LOGIC;
        
        keyboard_val  : IN   STD_LOGIC_VECTOR(15 downto 0);
        vga_wrn       : OUT  STD_LOGIC;
        vga_data      : OUT  STD_LOGIC_VECTOR(15 downto 0);
        
        NowPC         : IN   STD_LOGIC_VECTOR(15 downto 0);
        Exception     : OUT  STD_LOGIC;
        ExceptPC      : OUT  STD_LOGIC_VECTOR(15 downto 0);
        
        LedSel        : IN   STD_LOGIC_VECTOR(15 downto 0);
        LedOut        : OUT  STD_LOGIC_VECTOR(15 downto 0);
        NumOut        : OUT  STD_LOGIC_VECTOR(7 downto 0)
    );
    END Component;

    Component MUX_MEM_WB IS PORT (
        rst, clk: in std_logic;
        RegWE:    in std_logic;
        DstReg:   in std_logic_vector( 3 downto 0);
        DstVal:   in std_logic_vector(15 downto 0);
        RegWE_o:  out std_logic;
        DstReg_o: out std_logic_vector( 3 downto 0);
        DstVal_o: out std_logic_vector(15 downto 0)
    );
    END Component;

    component HazardDetectingUnit IS PORT (
        rst,clk:    in std_logic;
        MemRead:    in std_logic;
        DstReg:     in std_logic_vector(3 downto 0);
        ASrc4:      in std_logic_vector(3 downto 0);
        BSrc4:      in std_logic_vector(3 downto 0);
        ALUOut:     in std_logic_vector(15 downto 0);
        MemWE:      in std_logic;

        PC_Keep:    out std_logic;
        IFID_Keep:  out std_logic;
        IDEX_Stall: out std_logic
    );
    END component;

    Component ForwardingUnit IS port(
		EXE_REGWRITE: in std_logic ;  --exe阶段的写信号
        EXE_DstReg:   in std_logic_vector (3 DOWNTO 0) ;  --exe阶段目的寄存��
        MEM_REGWRITE: in std_logic ;  --mem 阶段的写信号
        MEM_DstReg:   in std_logic_vector (3 downto 0);  --mem阶段的目的寄存器
        ASrc4:        in std_logic_vector (3 downto 0);  -- ALU 操作数A的源寄存��
        BSrc4:        in std_logic_vector (3 downto 0);  -- ALU 操作数B的源寄存��
        FORWARDA:     out std_logic_vector(1 downto 0);  --muxa信号选择
        FORWARDB:     out std_logic_vector(1 downto 0)   --muxb信号选择
	);
    END Component;

    Component Clock IS port (
        rst:    IN  STD_LOGIC;
        clk:    IN  STD_LOGIC;
        clk11:  IN  STD_LOGIC;
        clk50:  IN  STD_LOGIC;
        sel:    IN  STD_LOGIC_VECTOR(1 downto 0);
        clkout: OUT STD_LOGIC
    );
    END Component;

    Component Keyboard IS PORT (
        rst: in STD_LOGIC;
        clk50M: in STD_LOGIC;
        
        ps2clk: in STD_LOGIC;
        ps2data: in STD_LOGIC;

        data_ready: out STD_LOGIC;
        key_value: out STD_LOGIC_vector(15 downto 0) -- 总是保持前一次的结果
    );
    END Component;
    
    Component video_sync IS PORT (
        clock:                              IN  STD_LOGIC;	-- should be 25M Hz
        video_on, Horiz_Sync, Vert_Sync:    OUT STD_LOGIC;
        H_count_out, V_count_out:			OUT STD_LOGIC_VECTOR(9 downto 0)
        );
    END Component;

    Component BCDto7Seg is port (
        bcd:    IN  STD_LOGIC_VECTOR(3 downto 0);
        seg:    OUT STD_LOGIC_VECTOR(6 downto 0)
    );
    END Component;

    Component LedDebug IS PORT (
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
    END Component;

    SIGNAL clk_sel  :        STD_LOGIC;

    SIGNAL clock_25 :        STD_LOGIC;
    SIGNAL video_on:         STD_LOGIC;
    SIGNAL t_hsync, t_vsync : STD_LOGIC;
    SIGNAL H_count, V_count : STD_LOGIC_VECTOR(9 downto 0);

    SIGNAL if_PCKeep        : STD_LOGIC := '1';
    SIGNAL if_NewPC         : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_PCToIM        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_PCPlus1       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_PCRx          : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_PCAddImm      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_Inst          : STD_LOGIC_VECTOR(15 DOWNTO 0); --instruction from ram2

    SIGNAL id_Inst          : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL id_PCPlus1       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL id_PCAddImm      : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL id_Imme          : STD_LOGIC_VECTOR(10 downto 0);
    SIGNAL ext_Imme         : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL ctrl_CurPC       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ctrl_ImmeSrc     : STD_LOGIC_VECTOR( 2 downto 0);
    SIGNAL ctrl_ZeroExt     : STD_LOGIC;
    SIGNAL ctrl_ALUOp       : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL ctrl_ASrc        : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL ctrl_BSrc        : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL ctrl_MemRead     : STD_LOGIC;
    SIGNAL ctrl_MemWE       : STD_LOGIC;
    SIGNAL ctrl_DstReg      : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL ctrl_RegWE       : STD_LOGIC;
    SIGNAL ctrl_ASrc4       : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL ctrl_BSrc4       : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL ctrl_PCMuxSel    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    SIGNAL ctrl_ExceptPC    : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ctrl_NowPC       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ctrl_InDelayslot : STD_LOGIC;

    SIGNAL rf_Data1         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL rf_Data2         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL id_data1         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL id_data2         : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL exe_Data1        : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_Data2        : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_Imme         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_DstReg       : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_RegWE        : STD_LOGIC;
    SIGNAL exe_MemRead      : STD_LOGIC;
    SIGNAL exe_MemWE        : STD_LOGIC;
    SIGNAL exe_ALUOp        : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_ASrc         : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL exe_BSrc         : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL exe_BOp          : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_ASrc4        : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_BSrc4        : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_MemWriteData : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_InDelayslot  : STD_LOGIC;
    SIGNAL exe_PCSel        : STD_LOGIC_VECTOR( 1 downto 0);

    SIGNAL alu_F            : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL alu_T            : STD_LOGIC;

    SIGNAL mem_DstReg       : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL mem_RegWE        : STD_LOGIC;
    SIGNAL mem_MemWE        : STD_LOGIC;
    SIGNAL mem_MemRead      : STD_LOGIC;
    SIGNAL mem_ALUOut       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_WriteData    : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_ReadData     : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_DstVal       : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL mem_vga_wrn      : STD_LOGIC;
    SIGNAL mem_vga_data     : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_vgaR         : STD_LOGIC_VECTOR( 2 downto 0);
    SIGNAL mem_vgaG         : STD_LOGIC_VECTOR( 2 downto 0);
    SIGNAL mem_vgaB         : STD_LOGIC_VECTOR( 2 downto 0);

    SIGNAL wb_DstReg        : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL wb_RegWE         : STD_LOGIC;
    SIGNAL wb_DstVal        : STD_LOGIC_VECTOR(15 downto 0);    

    SIGNAL ram1_InstRead    : STD_LOGIC;

    SIGNAL ram1_en_o        : STD_LOGIC;
    SIGNAL ram1_oe_o        : STD_LOGIC;
    SIGNAL ram1_we_o        : STD_LOGIC;
    SIGNAL ram2_en_o        : STD_LOGIC;
    SIGNAL ram2_oe_o        : STD_LOGIC;
    SIGNAL ram2_we_o        : STD_LOGIC;
    SIGNAL ram1_data_o      : STD_LOGIC_VECTOR(15 DOWNTO 0); 
    SIGNAL ram1_addr_o      : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL ram2_data_o      : STD_LOGIC_VECTOR(15 DOWNTO 0); 
    SIGNAL ram2_addr_o      : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL ram1_NowPC       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ram1_Except      : STD_LOGIC;
    SIGNAL ram1_ExceptPC    : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ram1_LED         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ram1_numout      : STD_LOGIC_VECTOR( 7 downto 0);
    SIGNAL ram2_LED         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ram2_numout      : STD_LOGIC_VECTOR( 7 downto 0);
    

    SIGNAL fwd_ForwardA     : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL fwd_ForwardB     : STD_LOGIC_VECTOR( 1 downto 0);

    SIGNAL hdu_IFID_Keep    : STD_LOGIC;
    SIGNAL hdu_IDEX_Stall   : STD_LOGIC;

    signal keyboard_data_ready: STD_LOGIC;
    signal keyboard_key_value: STD_LOGIC_vector(15 downto 0);

    SIGNAL led_out          : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL num_out          : STD_LOGIC_VECTOR( 7 downto 0);    
BEGIN

    PROCESS --  50M to 25M
    BEGIN
        WAIT UNTIL CLK_50'Event AND CLK_50 = '1';    
        clock_25 <= NOT clock_25;
    END PROCESS;

    u_Number1: BCDto7Seg PORT MAP (
        bcd => num_out(7 downto 4),
        seg => Number1
    );

    u_Number0: BCDto7Seg PORT MAP (
        bcd => num_out(3 downto 0),
        seg => Number0
    );

    sync: Video_Sync PORT MAP (
        clock => clock_25,
        horiz_sync => t_hsync,
        vert_sync => t_vsync,
        video_on => video_on,
        H_count_OUT => H_count,
        V_count_OUT => V_count
    );
    Hs <= t_hsync;
    Vs <= t_vsync;
    
    u_clock: Clock PORT MAP (
        rst => RST,
        clk => CLK,
        clk11 => CLK_11,
        clk50 => CLK_50,
        sel   => SW(15 downto 14),
        clkOUT => clk_sel
    );
    
    if_PCRx <= id_Data1;
    if_PCAddImm <= id_PCAddImm;
    u_PCMUX: PCMUX PORT MAP (
        clk           => CLK,
        rst           => RST,
        PCAdd1_data   => if_PCPlus1,
        PCRx_data     => if_PCRx,
        PCAddImm_data => id_PCAddImm,
        PC_choose     => ctrl_PCMuxSel,
        PCOUT         => if_NewPC
    );
    
    u_PC: PCReg PORT MAP (
        PCSrc => if_NewPC,
        keep  => if_PCKeep,
        PC    => if_PCToIM
    );
    
    u_PCAdd1: PCAdd1 PORT MAP (
        PCin  => if_PCToIM,
        PCOUT => if_PCPlus1
    );
    
    u_InstMemory: IM_RAM2 PORT MAP (
        clk          => clk_sel,
        rst          => RST,
        PC_i         => if_PCToIM,
        Ram2_Data    => Ram2_Data,
        mem_MemRead  => mem_MemRead,
        mem_MemWE    => mem_MemWE,
        mem_ALUOut   => mem_ALUOut,
        mem_WriteData=> mem_WriteData,
        Ram2_Addr    => Ram2_Addr,
        Ram2_Inst    => if_Inst,
        Ram2_OE      => Ram2_OE,
        Ram2_WE      => Ram2_WE,
        Ram2_EN      => Ram2_EN
        -- ,
        -- LedSel       => SW,
        -- LedOut       => ram2_LED,
        -- NumOut       => ram2_numout
    );
    
    u_MUX_IF_ID: MUX_IF_ID PORT MAP (
        clk        => clk_sel,
        rst        => RST,
        if_Keep    => hdu_IFID_Keep,
        if_PCPlus1 => if_PCPlus1,
        if_Inst    => if_Inst,
        id_PCPlus1 => id_PCPlus1,
        id_Inst    => id_Inst,
        id_Imme    => id_Imme
    );

    u_CtrlUnit: ControlUnit PORT MAP (
        clk         => clk_sel,
        rst         => RST,
        CurPC       => id_PCPlus1,
        Instruction => id_Inst,
        Condition   => id_Data1,
        InDelayslot => exe_InDelayslot,
        LastPCSel   => exe_PCSel,
        ImmeSrc     => ctrl_ImmeSrc,
        ZeroExt     => ctrl_ZeroExt,
        ALUOp       => ctrl_ALUOp,
        ASrc        => ctrl_ASrc,
        BSrc        => ctrl_BSrc,
        MemRead     => ctrl_MemRead,
        MemWE       => ctrl_MemWE,
        DstReg      => ctrl_DstReg,
        RegWE       => ctrl_RegWE,
        ASrc4       => ctrl_ASrc4,
        BSrc4       => ctrl_BSrc4,
        NextInDelayslot => ctrl_InDelayslot, 
        PCMuxSel    => ctrl_PCMuxSel
        -- ,
        -- NowPC       => ctrl_NowPC,
        -- ExceptPC    => ctrl_ExceptPC
    );

    u_AddImme: PCAddImm PORT MAP (
        PCin  => id_PCPlus1,
        Imm   => ext_Imme,
        PCout => id_PCAddImm
    );

    u_RegFile: RegisterFile Port MAP (
        rst             => RST,
        clk             => clk_sel,
        PCplus1         => id_PCPlus1,
        RegWE           => wb_RegWE,
        WriteRegister   => wb_DstReg,
        WriteData       => wb_DstVal,
        ASrc4           => ctrl_ASrc4,
        BSrc4           => ctrl_BSrc4,
        Data1           => rf_Data1,
        Data2           => rf_Data2
    );

    u_ImmExtend: ImmExtend PORT MAP (
        ImmeSrc     => ctrl_ImmeSrc,
        inImme      => id_Imme,
        ZeroExtend  => ctrl_ZeroExt,
        Imme        => ext_Imme
    );

    u_Mux_ALU_A: MUX_ALU_A PORT MAP (
        ASrc         => ctrl_ASrc,
        ForwardingA  => fwd_ForwardA,
        Data1        => rf_Data1,
        Immediate    => ext_Imme,
        ALUOut       => alu_F,
        MemDstVal    => mem_DstVal,
        AOp          => id_data1
    );

    u_Mux_Data2: MUX_Data2 PORT MAP (
        ForwardingB  => fwd_ForwardB,
        Data2        => rf_Data2,
        ALUOut       => alu_F,
        MemDstVal    => mem_DstVal,
        BOp          => id_data2
    );

    u_MUX_ID_EXE: MUX_ID_EXE PORT MAP (
        clk           => clk_sel,
        rst           => RST,
        Data1         => id_data1,
        Data2         => id_data2,
        Immediate     => ext_Imme,
        DstReg        => ctrl_DstReg,
        RegWE         => ctrl_RegWE,
        MemRead       => ctrl_MemRead,
        MemWE         => ctrl_MemWE,
        ALUOp         => ctrl_ALUOp,
        ASrc          => ctrl_ASrc,
        BSrc          => ctrl_BSrc,
        ASrc4         => ctrl_ASrc4,
        BSrc4         => ctrl_BSrc4,
        InDelayslot   => ctrl_InDelayslot,
        PCSel         => ctrl_PCMuxSel,
        InDelayslot_o => exe_InDelayslot,
        PCSel_o       => exe_PCSel,
        Stall         => hdu_IDEX_Stall, -- whether stop for a stage from HazardDetectingUnit
        Data1_o       => exe_Data1,
        Data2_o       => exe_Data2,
        Immediate_o   => exe_Imme,
        DstReg_o      => exe_DstReg,
        RegWE_o       => exe_RegWE,
        MemRead_o     => exe_MemRead,
        MemWE_o       => exe_MemWE,
        ALUOp_o       => exe_ALUOp,
        ASrc_o        => exe_ASrc,
        BSrc_o        => exe_BSrc,
        ASrc4_o       => exe_ASrc4,
        BSrc4_o       => exe_BSrc4,
        MemWriteData  => exe_MemWriteData
    );

    u_Mux_ALU_B: MUX_ALU_B PORT MAP (
        BSrc       => exe_BSrc,
        Data2      => exe_Data2,
        Immediate  => exe_Imme,
        BOp        => exe_BOp
    );

    u_ALU: ALU PORT MAP (
        A  => exe_Data1,
        B  => exe_BOp,
        OP => exe_ALUOp,
        F  => alu_F,
        T  => alu_T
    );

    u_MUX_EXE_MEM: MUX_EXE_MEM PORT MAP (
        rst            => RST,
        clk            => clk_sel,
        DstReg         => exe_DstReg,
        RegWE          => exe_RegWE,
        MemRead        => exe_MemRead,
        MemWE          => exe_MemWE,
        MemWriteData   => exe_MemWriteData,
        ALUOut         => alu_F,
        T              => alu_T,
        Stall          => '1', -- not stop
        o_DstReg       => mem_DstReg,
        o_RegWE        => mem_RegWE,
        o_MemRead      => mem_MemRead,
        o_MemWE        => mem_MemWE,
        o_MemWriteData => mem_WriteData,
        o_ALUOut       => mem_ALUOut
    );

    u_DataMemory: DM_RAM1 PORT MAP (
        CLK           => clk_sel,
        RST           => RST,
        
        MemWE         => mem_MemWE,
        WriteData     => mem_WriteData,
        MemRead       => mem_MemRead,
        ALUOut        => mem_ALUOut,
        
        InstRead      => ram1_InstRead,
        InstVal       => mem_WriteData,
        
        DstVal        => mem_ReadData,
        
        Ram1OE        => Ram1_OE,
        Ram1WE        => Ram1_we,
        Ram1EN        => Ram1_en,
        Ram1Addr      => RAM1_Addr,
        Ram1Data      => Ram1_Data,
        
        rdn           => rdn,
        wrn           => wrn,
        data_ready    => data_ready,
        tbre          => tbre,
        tsre          => tsre,
        
        keyboard_val  => keyboard_key_value,
        vga_wrn       => mem_vga_wrn,
        vga_data      => mem_vga_data,
        
        NowPC         => ram1_NowPC,
        Exception     => ram1_Except,
        ExceptPC      => ram1_ExceptPC,
        
        LedSel        => SW,
        LedOut        => ram1_LED,
        NumOut        => ram1_numout
    );  

    u_Mux_Write_Data: MUX_Write_Data PORT MAP (
        MemRead   => mem_MemRead,
        MemALUOut => mem_ALUOut,
        MemData   => mem_ReadData,
        WriteData => mem_DstVal
    );

    u_Mux_MEM_WB: MUX_MEM_WB PORT MAP (
        rst      => RST,
        clk      => clk_sel,
        RegWE    => mem_RegWE,
        DstReg   => mem_DstReg,
        DstVal   => mem_DstVal,
        RegWE_o  => wb_RegWE,
        DstReg_o => wb_DstReg,
        DstVal_o => wb_DstVal
    );

    u_ForwardUnit: ForwardingUnit PORT MAP (
        EXE_REGWRITE => exe_RegWE,
        EXE_DstReg   => exe_DstReg,
        MEM_REGWRITE => mem_RegWE,
        MEM_DstReg   => mem_DstReg,
        ASrc4        => ctrl_ASrc4,
        BSrc4        => ctrl_BSrc4,
        FORWARDA     => fwd_ForwardA,
		FORWARDB     => fwd_ForwardB
    );

    u_HazardDetectingUnit: HazardDetectingUnit PORT MAP (
        rst => RST,
        clk => clk_sel,
        MemRead => exe_MemRead,
        DstReg  => exe_DstReg,
        ASrc4   => ctrl_ASrc4,
        BSrc4   => ctrl_BSrc4,
        ALUOut  => alu_F,
        MemWE   => mem_MemWE,
        PC_Keep => if_PCKeep,
        IFID_Keep => hdu_IFID_Keep,
        IDEX_Stall => hdu_IDEX_Stall
    );

    u_keyboard: Keyboard PORT MAP (
        rst         => RST,
        clk50M      => CLK_50,
        
        ps2clk      => ps2clk,
        ps2data     => ps2data,

        data_ready  => keyboard_data_ready,
        key_value   => keyboard_key_value
    );

    DrawScreen: PROCESS(clock_25)
    BEGIN
        VGA_R <= background_r;
        VGA_G <= background_g;
        VGA_B <= background_b;
    END PROCESS;

    u_LedDebug: LedDebug PORT MAP (
        rst              => rst,
        clk              => clk_sel,
        SW               => SW,
        DebugEnable      => '1',
        LedOut           => LED,
        Number           => num_out, 

        if_PCKeep        => if_PCKeep,
        if_NewPC         => if_NewPC,
        if_PCToIM        => if_PCToIM,
        if_PCPlus1       => id_PCPlus1,
        if_PCRx          => if_PCRx,
        if_PCAddImm      => if_PCAddImm,
        if_Inst          => if_Inst, --instruction from ram2

        id_Inst          => id_Inst,
        id_PCPlus1       => id_PCPlus1,
        id_PCAddImm      => id_PCAddImm,
        id_Imme          => id_Imme,
        ext_Imme         => ext_Imme,

        ctrl_CurPC       => ctrl_CurPC,
        ctrl_ImmeSrc     => ctrl_ImmeSrc,
        ctrl_ZeroExt     => ctrl_ZeroExt,
        ctrl_ALUOp       => ctrl_ALUOp,
        ctrl_ASrc        => ctrl_ASrc,
        ctrl_BSrc        => ctrl_BSrc,
        ctrl_MemRead     => ctrl_MemRead,
        ctrl_MemWE       => ctrl_MemWE,
        ctrl_DstReg      => ctrl_DstReg,
        ctrl_RegWE       => ctrl_RegWE,
        ctrl_ASrc4       => ctrl_ASrc4,
        ctrl_BSrc4       => ctrl_BSrc4,
        ctrl_PCMuxSel    => ctrl_PCMuxSel,
        ctrl_ExceptPC    => ctrl_ExceptPC,
        ctrl_NowPC       => ctrl_NowPC,
        ctrl_InDelayslot => ctrl_InDelayslot,

        rf_Data1         => rf_Data1,
        rf_Data2         => rf_Data2,
        id_data1         => id_data1,
        id_data2         => id_data2,

        exe_Data1        => exe_Data1,
        exe_Data2        => exe_Data2,
        exe_Imme         => exe_Imme,
        exe_DstReg       => exe_DstReg,
        exe_RegWE        => exe_RegWE,
        exe_MemRead      => exe_MemRead,
        exe_MemWE        => exe_MemWE,
        exe_ALUOp        => exe_ALUOp,
        exe_ASrc         => exe_ASrc,
        exe_BSrc         => exe_BSrc,
        exe_BOp          => exe_BOp, 
        exe_ASrc4        => exe_ASrc4,
        exe_BSrc4        => exe_BSrc4,
        exe_MemWriteData => exe_MemWriteData,
        exe_InDelayslot  => exe_InDelayslot,
        exe_PCSel        => exe_PCSel,

        alu_F            => alu_F,
        alu_T            => alu_T,

        mem_DstReg       => mem_DstReg,
        mem_RegWE        => mem_RegWE,
        mem_MemWE        => mem_MemWE,
        mem_MemRead      => mem_MemRead,
        mem_ALUOut       => mem_ALUOut,
        mem_WriteData    => mem_WriteData,
        mem_ReadData     => mem_ReadData,
        mem_DstVal       => mem_DstVal,

        mem_vga_wrn      => '1',
        mem_vga_data     => (others => '0'),
        mem_vgaR         => (others => '0'),
        mem_vgaG         => (others => '0'),
        mem_vgaB         => (others => '0'),

        wb_DstReg        => (others => '0'),
        wb_RegWE         => wb_RegWE,
        wb_DstVal        => wb_DstVal,

        ram1_en          => '0',
        ram1_oe          => '0',
        ram1_we          => '0',
        ram2_en          => '0',
        ram2_oe          => '0',
        ram2_we          => '0',
        ram1_data        => (others => '0'),
        ram1_addr        => (others => '0'),
        ram2_data        => (others => '0'),
        ram2_addr        => (others => '0'),

        ram1_InstRead    => ram1_InstRead,
        ram1_NowPC       => ram1_NowPC,
        ram1_Except      => ram1_Except,
        ram1_ExceptPC    => ram1_ExceptPC,
        ram1_LED         => ram1_LED,
        ram1_numout      => ram1_numout,
        ram2_LED         => ram2_LED,
        ram2_numout      => ram2_numout,
        
        fwd_ForwardA     => fwd_ForwardA,
        fwd_ForwardB     => fwd_ForwardB,

        hdu_IFID_Keep    => hdu_IFID_Keep,
        hdu_IDEX_Stall   => hdu_IDEX_Stall
    );

END Behaviour;
