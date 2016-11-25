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
    
    VGA_R:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_G:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_B:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    Hs:          OUT   STD_LOGIC;
    Vs:          OUT   STD_LOGIC;
    
    --FLASH
    flash_byte : OUT STD_LOGIC := '1'; --操作模式,采用字模式，地址为 22 downto 1
    flash_vpen : OUT STD_LOGIC := '1'; --写保护，置为1
    flash_ce   : OUT STD_LOGIC := '0'; --使能信号,该模块只负责flash的读，故ce置为0即可
    flash_oe   : OUT STD_LOGIC := '1'; --读使能
    flash_we   : OUT STD_LOGIC := '1'; --写使能
    flash_rp   : OUT STD_LOGIC := '1'; --工作模式，1为工作
    flash_addr : OUT STD_LOGIC_VECTOR( 22 downto 1 ) := "0000000000000000000000"; --flash内存地址
    flash_data : INOUT STD_LOGIC_VECTOR( 15 downto 0 ); --flash输出信号
    
    -- used to display debug info
    LED:         OUT   STD_LOGIC_VECTOR(15 downto 0)
);
END CPU;

ARCHITECTURE Behaviour OF CPU IS

    Component PCMUX is
        port(
        clk, rst : IN STD_LOGIC;
        PCAdd1_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PCRx_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PCAddImm_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PC_choose : IN STD_LOGIC_VECTOR(1 downto 0);
        PCout: OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    end Component; 

    Component PCReg is
        Port (
            PCSrc : IN STD_LOGIC_VECTOR(15 downto 0);
            keep : IN STD_LOGIC;
            PC : OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    end Component;

    Component PCAdd1 is Port (
        PCin  : IN   STD_LOGIC_VECTOR (15 downto 0);
        PCOUT : OUT  STD_LOGIC_VECTOR (15 downto 0)
    );
    End Component;

    Component IM_RAM2 IS PORT (
        clk         : IN    STD_LOGIC;
        rst         : IN    STD_LOGIC;
        PC_i        : IN    STD_LOGIC_VECTOR(15 downto 0);
        Ram2_Data   : INOUT STD_LOGIC_VECTOR(15 downto 0);
        MemWE       : IN    STD_LOGIC;
        ALUOut      : IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Address
        MemWriteData: IN    STD_LOGIC_VECTOR(15 downto 0); -- Mem Write Data
        Ram2_Addr   : OUT   STD_LOGIC_VECTOR(17 downto 0);
        Instruction : OUT   STD_LOGIC_VECTOR(15 downto 0);
        Ram2_OE     : OUT   STD_LOGIC;
        Ram2_WE     : OUT   STD_LOGIC;
        Ram2_EN     : OUT   STD_LOGIC;
        LedSel      : OUT   STD_LOGIC_VECTOR(15 downto 0);
        LedOut      : OUT   STD_LOGIC_VECTOR(15 downto 0);
        NumOut      : OUT   STD_LOGIC_VECTOR( 7 downto 0)
        );
    End Component;

    Component MUX_IF_ID IS PORT (
        clk     :  IN  STD_LOGIC;
        rst     :  IN  STD_LOGIC;
        if_Keep :  IN  STD_LOGIC;
        if_PC   :  IN  STD_LOGIC_VECTOR(15 downto 0);
        if_Inst :  IN  STD_LOGIC_VECTOR(15 downto 0);
        id_PC   :  OUT STD_LOGIC_VECTOR(15 downto 0);
        id_Inst :  OUT STD_LOGIC_VECTOR( 4 downto 0);
        id_Imme :  OUT STD_LOGIC_VECTOR(10 downto 0)
    );
    END Component;

    Component ControlUnit IS PORT (
        Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
        Condition   :  IN  STD_LOGIC_VECTOR(15 downto 0);
        
        Data1Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
        Data2Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
        ImmeSrc     :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- 3, 4, 5, 8, 11 
        ZeroExt     :  OUT STD_LOGIC;                     

        ALUop       :  OUT STD_LOGIC_VECTOR( 3 downto 0);
        ASrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);
        BSrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);

        MemRead     :  OUT STD_LOGIC;
        MemWE       :  OUT STD_LOGIC;    

        DstReg      :  OUT STD_LOGIC_VECTOR( 3 downto 0);
        RegWE       :  OUT STD_LOGIC;
        
        ASrc4       :  OUT STD_LOGIC_VECTOR (3 downto 0);
        BSrc4       :  OUT STD_LOGIC_VECTOR (3 downto 0);

        PCMuxSel    :  OUT STD_LOGIC_VECTOR( 2 downto 0)
    );
    END Component;

    Component ImmExtend is port(
        ImmeSrc     : IN  STD_LOGIC_VECTOR(2 downto 0);
        inImme      : IN  STD_LOGIC_VECTOR(10 downto 0);
        ZeroExtend  : IN  STD_LOGIC;
        Imme        : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    end Component;

    Component PCAddImm is Port (
        PCin  : IN   STD_LOGIC_VECTOR (15 downto 0);
        Imm   : IN   STD_LOGIC_VECTOR (15 downto 0);
        PCout : OUT  STD_LOGIC_VECTOR (15 downto 0));
    end Component;
    
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

    Component MUX_ALU_A IS PORT (
        Data1:         IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate:     IN  STD_LOGIC_VECTOR(15 downto 0);
        ExeMemALUOut:  IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
        ASrc:          IN  STD_LOGIC_VECTOR( 1 downto 0);
        ForwardingA:   IN  STD_LOGIC_VECTOR( 2 downto 0);
        AOp:           OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_ALU_B IS PORT (
        Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate:      IN  STD_LOGIC_VECTOR(15 downto 0);
        ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
        BSrc:           IN  STD_LOGIC_VECTOR( 1 downto 0);
        ForwardingB:    IN  STD_LOGIC_VECTOR( 2 downto 0);
        BOp:            OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component ALU IS PORT (
        A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        OP :  IN  STD_LOGIC_VECTOR(4  downto 0);
        F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
        T  :  OUT STD_LOGIC
        );
    END Component;

    Component RegisterFile IS PORT (
        PCplus1:        IN  STD_LOGIC_VECTOR(15 downto 0);
        Read1Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
        Read2Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteRegister:  IN  STD_LOGIC_VECTOR(3  downto 0);
        WriteData:      IN  STD_LOGIC_VECTOR(15 downto 0);
        Data1Src:       IN  STD_LOGIC_VECTOR(2 downto 0);
        Data2Src:       IN  STD_LOGIC_VECTOR(2 downto 0);
        RegWE:          IN  STD_LOGIC;
        Data1:          OUT STD_LOGIC_VECTOR(15 downto 0);
        Data2:          OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    END Component;

    component HazardDetectingUnit is 
        port (
        rst,clk: IN STD_LOGIC;
        MemRead: IN STD_LOGIC;
        DstReg: IN STD_LOGIC_VECTOR(3 downto 0);
        ASrc4: IN STD_LOGIC_VECTOR(3 downto 0);
        BSrc4: IN STD_LOGIC_VECTOR(3 downto 0);
        ALUOut: IN STD_LOGIC_VECTOR(15 downto 0);
        MemWE: IN STD_LOGIC;

        PC_Keep: OUT STD_LOGIC;
        IFID_Keep: OUT STD_LOGIC;
        IDEX_Stall: OUT STD_LOGIC
    );
    end component;

    Component ForwardingUnit is port(
		EXE_MEM_REGWRITE : IN STD_LOGIC ;  --exe_mem阶段寄存器的写信号
        EXE_MEM_RD       : IN STD_LOGIC_VECTOR (3 DOWNTO 0) ;  --exe_mem阶段目的寄存器
        MEM_WB_REGWRITE  : IN STD_LOGIC ;  --mem_wb阶段寄存器的写信号
        MEM_WB_RD        : IN STD_LOGIC_VECTOR (3 downto 0);  --mem_wb阶段寄存器的目的寄存器
        ASrc4            : IN STD_LOGIC_VECTOR (3 downto 0);  -- ALU 操作数A的源寄存器
        BSrc4            : IN STD_LOGIC_VECTOR (3 downto 0);  -- ALU 操作数B的源寄存器
        FORWARDA         : OUT STD_LOGIC_VECTOR(1 downto 0);  --muxa信号选择
		FORWARDB         : OUT STD_LOGIC_VECTOR(1 downto 0)   --muxb信号选择
	);
    end Component;

    Component Clock is port (
        rst:    IN  STD_LOGIC;
        clk:    IN  STD_LOGIC;
        clk11:  IN  STD_LOGIC;
        clk50:  IN  STD_LOGIC;
        sel:    IN  STD_LOGIC_VECTOR(1 downto 0);
        clkout: OUT STD_LOGIC
    );
    end Component;
    
    Component video_sync IS PORT (
        clock:                              IN  STD_LOGIC;	-- should be 25M Hz
        video_on, Horiz_Sync, Vert_Sync:    OUT STD_LOGIC;
        H_count_out, V_count_out:			OUT STD_LOGIC_VECTOR(9 downto 0)
        );
    END Component;

    SIGNAL clk_sel  :        STD_LOGIC;

    SIGNAL clock_25 :        STD_LOGIC;
    SIGNAL video_on:         STD_LOGIC;
    SIGNAL t_hsync, t_vsync: STD_LOGIC;
    SIGNAL H_count, V_count: STD_LOGIC_VECTOR(9 downto 0);

    SIGNAL PCKeep       : STD_LOGIC;
    SIGNAL PC           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PCPlus1_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PCRx_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PCAdd_data   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_choose    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
    SIGNAL NewPC        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Instruct     : STD_LOGIC_VECTOR(15 DOWNTO 0); --instruction from ram2
    
BEGIN

    PROCESS --  50M to 25M
    BEGIN
        WAIT UNTIL CLK_50'Event AND CLK_50 = '1';    
        clock_25 <= NOT clock_25;
    END PROCESS;

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
        sel   => "00",
        clkOUT => clk_sel
    );
    
    u_PCMUX: PCMUX PORT MAP (
        clk => CLK,
        rst => RST,
        PCAdd1_data => PCPlus1_data,
        PCRx_data  => PCRx_data,
        PCAddImm_data => PCAdd_data,
        PC_choose  => PC_choose,
        PCOUT      => NewPC
    );
    
    u_PC: PCReg PORT MAP (
        PCSrc => NewPC,
        keep => PCKeep,
        PC  => PC
    );
    
    u_PCAdd1: PCAdd1 PORT MAP (
        PCin => PC,
        PCOUT => PCPlus1_data
    );
    
    

    DrawScreen: PROCESS(clock_25)
    BEGIN
        VGA_R <= background_r;
        VGA_G <= background_g;
        VGA_B <= background_b;
    END PROCESS;

END Behaviour;
