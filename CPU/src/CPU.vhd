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

    Component PCMUX IS
        port(
        clk, rst : IN STD_LOGIC;
        PCAdd1_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PCRx_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PCAddImm_data : IN STD_LOGIC_VECTOR(15 downto 0);
        PC_choose : IN STD_LOGIC_VECTOR(1 downto 0);
        PCout: OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    END Component; 

    Component PCReg IS
        Port (
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
        Ram2_Inst:     OUT   STD_LOGIC_VECTOR(15 downto 0);

        LedSel:        IN    STD_LOGIC_VECTOR(15 downto 0);
        LedOut:        OUT   STD_LOGIC_VECTOR(15 downto 0);
        NumOut:        OUT   STD_LOGIC_VECTOR( 7 downto 0)
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

        PCMuxSel    :  OUT STD_LOGIC_VECTOR( 1 downto 0);

        NowPC       :  OUT STD_LOGIC_VECTOR(15 downto 0);
        ExceptPC    :  OUT STD_LOGIC_VECTOR(15 downto 0)
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
        Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
        ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
        ForwardingB:    IN  STD_LOGIC_VECTOR( 1 downto 0);
        WriteData:      OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_ALU_A IS PORT (
        Data1:         IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate:     IN  STD_LOGIC_VECTOR(15 downto 0);
        ExeMemALUOut:  IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:   IN  STD_LOGIC_VECTOR(15 downto 0);
        ASrc:          IN  STD_LOGIC_VECTOR( 1 downto 0);
        ForwardingA:   IN  STD_LOGIC_VECTOR( 1 downto 0);
        AOp:           OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component MUX_ALU_B IS PORT (
        Data2:          IN  STD_LOGIC_VECTOR(15 downto 0);
        Immediate:      IN  STD_LOGIC_VECTOR(15 downto 0);
        ExeMemALUOut:   IN  STD_LOGIC_VECTOR(15 downto 0);
        MemWbDstVal:    IN  STD_LOGIC_VECTOR(15 downto 0);
        BSrc:           IN  STD_LOGIC_VECTOR( 1 downto 0);
        ForwardingB:    IN  STD_LOGIC_VECTOR( 1 downto 0);
        BOp:            OUT STD_LOGIC_VECTOR(15 downto 0)
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
        rst : in std_logic;
        PCplus1:    in std_logic_vector(15 downto 0);
        RegWE:      in std_logic;
        WriteRegister:  IN  STD_LOGIC_VECTOR(3  downto 0);
        WriteData:  IN  STD_LOGIC_VECTOR(15 downto 0);
        ASrc4:      in std_logic_vector(3 downto 0);
        BSrc4:      in std_logic_vector(3 downto 0);
        Data1:  out std_logic_vector(15 downto 0);
        Data2:  out std_logic_vector(15 downto 0)
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
        ALUOut: in std_logic_vector(15 downto 0);
        MemData: in std_logic_vector(15 downto 0);
        MemRead: in std_logic;
        DstReg: in std_logic_vector(3 downto 0);
        RegWE: in std_logic;

        DstReg_o: out std_logic_vector(3 downto 0);
        RegWE_o: out std_logic;
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
		EXE_MEM_REGWRITE : in STD_LOGIC;
        EXE_MEM_RD       : in STD_LOGIC_vector (3 DOWNTO 0);
        MEM_WB_REGWRITE  : in STD_LOGIC;
        MEM_WB_RD        : in STD_LOGIC_vector (3 downto 0);
        ASrc4            : in STD_LOGIC_vector (3 downto 0);
        BSrc4            : in STD_LOGIC_vector (3 downto 0);
        FORWARDA         : out STD_LOGIC_vector(1 downto 0);
		FORWARDB         : out STD_LOGIC_vector(1 downto 0) 
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

    SIGNAL rf_Data1         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL rf_Data2         : STD_LOGIC_VECTOR(15 downto 0);
    
    SIGNAL exe_Data1_o      : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_Data2_o      : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_Immediate_o  : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_DstReg_o     : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_RegWE_o      : STD_LOGIC;
    SIGNAL exe_MemRead_o    : STD_LOGIC;
    SIGNAL exe_MemWE_o      : STD_LOGIC;
    SIGNAL exe_ALUOp_o      : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_ASrc_o       : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL exe_BSrc_o       : STD_LOGIC_VECTOR( 1 downto 0);
    SIGNAL exe_ASrc4_o      : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_BSrc4_o      : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL exe_MemWriteData : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mux_MemWriteData : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL exe_OP_A         : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL exe_OP_B         : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL alu_F            : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL alu_T            : STD_LOGIC;

    SIGNAL mem_DstReg       : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL mem_RegWE        : STD_LOGIC;
    SIGNAL mem_MemWE        : STD_LOGIC;
    SIGNAL mem_MemRead      : STD_LOGIC;
    SIGNAL mem_ALUOut       : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_WriteData    : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_ReadData     : STD_LOGIC_VECTOR(15 downto 0);

    SIGNAL mem_vga_wrn      : STD_LOGIC;
    SIGNAL mem_vga_data     : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL mem_vgaR         : STD_LOGIC_VECTOR( 2 downto 0);
    SIGNAL mem_vgaG         : STD_LOGIC_VECTOR( 2 downto 0);
    SIGNAL mem_vgaB         : STD_LOGIC_VECTOR( 2 downto 0);

    SIGNAL wb_DstReg        : STD_LOGIC_VECTOR( 3 downto 0);
    SIGNAL wb_RegWE         : STD_LOGIC;
    SIGNAL wb_DstVal        : STD_LOGIC_VECTOR(15 downto 0);    

    SIGNAL ram1_InstRead    : STD_LOGIC;

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
        sel   => "00",
        clkOUT => clk_sel
    );
    
    if_PCRx <= rf_Data1;
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
    
    u_Ram2: IM_RAM2 PORT MAP (
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
        Ram2_EN      => Ram2_EN,
        LedSel       => SW,
        LedOut       => ram2_LED,
        NumOut       => ram2_numout
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
        CurPC       => ctrl_CurPC,
        Instruction => id_Inst,
        Condition   => rf_Data1,
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
        PCMuxSel    => ctrl_PCMuxSel,
        NowPC       => ctrl_NowPC,
        ExceptPC    => ctrl_ExceptPC
    );

    u_AddImme: PCAddImm PORT MAP (
        PCin  => id_PCPlus1,
        Imm   => ext_Imme,
        PCout => id_PCAddImm
    );

    u_RegFile: RegisterFile Port MAP (
        rst             => RST,
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

    u_MUX_ID_EXE: MUX_ID_EXE PORT MAP (
        clk           => clk_sel,
        rst           => RST,
        Data1         => rf_Data1,
        Data2         => rf_Data2,
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
        Stall         => hdu_IDEX_Stall, -- whether stop for a stage from HazardDetectingUnit
        Data1_o       => exe_Data1_o,
        Data2_o       => exe_Data2_o,
        Immediate_o   => exe_Immediate_o,
        DstReg_o      => exe_DstReg_o,
        RegWE_o       => exe_RegWE_o,
        MemRead_o     => exe_MemRead_o,
        MemWE_o       => exe_MemWE_o,
        ALUOp_o       => exe_ALUOp_o,
        ASrc_o        => exe_ASrc_o,
        BSrc_o        => exe_BSrc_o,
        ASrc4_o       => exe_ASrc4_o,
        BSrc4_o       => exe_BSrc4_o,
        MemWriteData  => exe_MemWriteData
    );

    u_Mux_Write_Data: MUX_Write_Data PORT MAP (
        Data2 =>    exe_MemWriteData,
        ExeMemALUOut => mem_ALUOut,
        MemWbDstVal => wb_DstVal,
        ForwardingB => fwd_ForwardB,
        WriteData => mux_MemWriteData
    ); 

    u_Mux_ALU_A: MUX_ALU_A PORT MAP (
        Data1         => exe_Data1_o,
        Immediate     => exe_Immediate_o,
        ExeMemALUOut  => mem_ALUOut,
        MemWbDstVal   => wb_DstVal,
        ASrc          => exe_ASrc_o,
        ForwardingA   => fwd_ForwardA,
        AOp           => exe_OP_A
    );

    u_Mux_ALU_B: MUX_ALU_B PORT MAP (
        Data2        => exe_Data2_o,
        Immediate    => exe_Immediate_o,
        ExeMemALUOut => mem_ALUOut,
        MemWbDstVal  => wb_DstVal,
        BSrc         => exe_BSrc_o,
        ForwardingB  => fwd_ForwardB,
        BOp          => exe_OP_B
    );

    u_ALU: ALU PORT MAP (
        A  => exe_OP_A,
        B  => exe_OP_B,
        OP => exe_ALUOp_o,
        F  => alu_F,
        T  => alu_T
    );

    u_MUX_EXE_MEM: MUX_EXE_MEM PORT MAP (
        rst            => RST,
        clk            => clk_sel,
        DstReg         => exe_DstReg_o,
        RegWE          => exe_RegWE_o,
        MemRead        => exe_MemRead_o,
        MemWE          => exe_MemWE_o,
        MemWriteData   => mux_MemWriteData,
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
        
        Ram1OE        => Ram1_oe,
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

    u_Mux_MEM_WB: MUX_MEM_WB PORT MAP (
        rst      => RST,
        clk      => clk_sel,
        ALUOut   => mem_ALUOut,
        MemData  => mem_ReadData,
        MemRead  => mem_MemRead,
        DstReg   => mem_DstReg,
        RegWE    => mem_RegWE,
        DstReg_o => wb_DstReg,
        RegWE_o  => wb_RegWE,
        DstVal_o => wb_DstVal
    );

    u_ForwardUnit: ForwardingUnit PORT MAP (
        EXE_MEM_REGWRITE => mem_RegWE,
        EXE_MEM_RD       => mem_DstReg,
        MEM_WB_REGWRITE  => wb_RegWE,
        MEM_WB_RD        => wb_DstReg,
        ASrc4            => exe_ASrc4_o,
        BSrc4            => exe_BSrc4_o,
        FORWARDA         => fwd_ForwardA,
		FORWARDB         => fwd_ForwardB
    );

    u_HazardDetectingUnit: HazardDetectingUnit PORT MAP (
        rst => RST,
        clk => clk_sel,
        MemRead => exe_MemRead_o,
        DstReg  => exe_DstReg_o,
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

END Behaviour;
