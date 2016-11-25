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
    flash_byte : out STD_LOGIC := '1'; --操作模式,采用字模式，地址为 22 downto 1
    flash_vpen : out STD_LOGIC := '1'; --写保护，置为1
    flash_ce   : out STD_LOGIC := '0'; --使能信号,该模块只负责flash的读，故ce置为0即可
    flash_oe   : out STD_LOGIC := '1'; --读使能
    flash_we   : out STD_LOGIC := '1'; --写使能
    flash_rp   : out STD_LOGIC := '1'; --工作模式，1为工作
    flash_addr : out STD_LOGIC_VECTOR( 22 downto 1 ) := "0000000000000000000000"; --flash内存地址
    flash_data : inout STD_LOGIC_VECTOR( 15 downto 0 ); --flash输出信号
    
    -- used to display debug info
    LED:         OUT   STD_LOGIC_VECTOR(15 downto 0)
);
END CPU;

ARCHITECTURE Behaviour OF CPU IS

    Component PCMUX is
        port(
        clk, rst : in std_logic;
        PCAdd1_data : in std_logic_vector(15 downto 0);
        PCRx_data : in std_logic_vector(15 downto 0);
        PCAddImm_data : in std_logic_vector(15 downto 0);
        PC_choose : in std_logic_vector(1 downto 0);
        PCout: out std_logic_vector(15 downto 0)
        );
    end Component; 

    Component PCReg is
        Port (
            PCSrc : in std_logic_vector(15 downto 0);
            keep : in std_logic;
            PC : out std_logic_vector(15 downto 0)
        );
    end Component;

    Component PCAdd1 is Port (
        PCin  : in   STD_LOGIC_VECTOR (15 downto 0);
        PCout : out  STD_LOGIC_VECTOR (15 downto 0)
    );
    End Component;

    Component IM_RAM2 IS PORT (
        clk         : in    std_logic;
        rst         : in    std_logic;
        PC_i        : in    std_logic_vector(15 downto 0);
        Ram2_Data   : inout std_logic_vector(15 downto 0);
        MemWE       : in    std_logic;
        ALUOut      : in    std_logic_vector(15 downto 0); -- Mem Write Address
        MemWriteData: in    std_logic_vector(15 downto 0); -- Mem Write Data
        Ram2_Addr   : out   std_logic_vector(17 downto 0);
        Instruction : out   std_logic_vector(15 downto 0);
        Ram2_OE     : out   std_logic;
        Ram2_WE     : out   std_logic;
        Ram2_EN     : out   std_logic;
        LedSel      : out   std_logic_vector(15 downto 0);
        LedOut      : out   std_logic_vector(15 downto 0);
        NumOut      : out   std_logic_vector( 7 downto 0)
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
        
        ASrc4       :  out std_logic_vector (3 downto 0);
        BSrc4       :  out std_logic_vector (3 downto 0);

        PCMuxSel    :  OUT STD_LOGIC_VECTOR( 2 downto 0)
    );
    END Component;

    Component ImmExtend is port(
        ImmeSrc     : in  std_logic_vector(2 downto 0);
        inImme      : in  std_logic_vector(10 downto 0);
        ZeroExtend  : in  std_logic;
        Imme        : out std_logic_vector(15 downto 0)
    );
    end Component;

    Component PCAddImm is Port (
        PCin  : in   STD_LOGIC_VECTOR (15 downto 0);
        Imm   : in   STD_LOGIC_VECTOR (15 downto 0);
        PCout : out  STD_LOGIC_VECTOR (15 downto 0));
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
        PCplus1:        IN  std_logic_vector(15 downto 0);
        Read1Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
        Read2Register:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteRegister:  IN  STD_LOGIC_VECTOR(3  downto 0);
        WriteData:      IN  STD_LOGIC_VECTOR(15 downto 0);
        Data1Src:       in std_logic_vector(2 downto 0);
        Data2Src:       in std_logic_vector(2 downto 0);
        RegWE:          in std_logic;
        Data1:          out std_logic_vector(15 downto 0);
        Data2:          out std_logic_vector(15 downto 0)
        );
    END Component;

    component HazardDetectingUnit is 
        port (
        rst,clk: in std_logic;
        MemRead: in std_logic;
        DstReg: in std_logic_vector(3 downto 0);
        ASrc4: in std_logic_vector(3 downto 0);
        BSrc4: in std_logic_vector(3 downto 0);
        ALUOut: in std_logic_vector(15 downto 0);
        MemWE: in std_logic;

        PC_Keep: out std_logic;
        IFID_Keep: out std_logic;
        IDEX_Stall: out std_logic
    );
    end component;

    Component ForwardingUnit is port(
		EXE_MEM_REGWRITE : in std_logic ;  --exe_mem阶段寄存器的写信及
        EXE_MEM_RD       : in std_logic_vector (3 DOWNTO 0) ;  --exe_mem阶段目的寄存器编及
        MEM_WB_REGWRITE  : in std_logic ;  --mem_wb阶段寄存器的写信及
        MEM_WB_RD        : in std_logic_vector (3 downto 0);  --mem_wb阶段寄存器的目的寄存器编及
        ASrc4            : in std_logic_vector (3 downto 0);  -- ALU 操作数A的源寄存器
        BSrc4            : in std_logic_vector (3 downto 0);  -- ALU 操作数B的源寄存器
        FORWARDA         : out std_logic_vector(1 downto 0);  --muxa信号选择
		FORWARDB         : out std_logic_vector(1 downto 0)   --muxb信号选择
	);
    end Component;

    Component Clock is port (
        rst:    in  std_logic;
        clk:    in  std_logic;
        clk11:  in  std_logic;
        clk50:  in  std_logic;
        sel:    in  std_logic_vector(1 downto 0);
        clkout: out std_logic
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
        H_count_out => H_count,
        V_count_out => V_count
    );
    Hs <= t_hsync;
    Vs <= t_vsync;
    
    u_clock: Clock PORT MAP (
        rst => RST,
        clk => CLK,
        clk11 => CLK_11,
        clk50 => CLK_50,
        sel   => "00",
        clkout => clk_sel
    );
    
    u_PCMUX: PCMUX PORT MAP (
        clk => CLK,
        rst => RST,
        PCAdd1_data => PCPlus1_data,
        PCRx_data  => PCRx_data,
        PCAddImm_data => PCAdd_data,
        PC_choose  => PC_choose,
        PCout      => NewPC
    );
    
    u_PC: PCReg PORT MAP (
        PCSrc => NewPC,
        keep => PCKeep,
        PC  => PC
    );
    
    u_PCAdd1: PCAdd1 PORT MAP (
        PCin => PC,
        PCout => PCPlus1_data
    );
    
    

    DrawScreen: PROCESS(clock_25)
    BEGIN
        VGA_R <= background_r;
        VGA_G <= background_g;
        VGA_B <= background_b;
    END PROCESS;

END Behaviour;
