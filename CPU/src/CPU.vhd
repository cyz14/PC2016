-- CPU.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CPU IS PORT (
    CLK     :    IN    STD_LOGIC;
    CLK_50  :    IN    STD_LOGIC;
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
    VGA_R:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_G:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    VGA_B:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
    Hs:          OUT   STD_LOGIC;
    Vs:          OUT   STD_LOGIC;
    DebugInfo:   OUT   STD_LOGIC_VECTOR(15 downto 0)
);
END CPU;

ARCHITECTURE Behaviour OF CPU IS

    Component PCMUX is
        port(
            PCPlus1_data : in std_logic_vector(15 downto 0);
            PCRx_data : in std_logic_vector(15 downto 0);
            PCAdd_data : in std_logic_vector(15 downto 0);
            PC_choose : in std_logic_vector(1 downto 0);
            PCout: out std_logic_vector(15 downto 0)
        );
    end Component; 

    Component PCReg is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            PCSrc : in std_logic_vector(15 downto 0);
            keep : in std_logic;
            PC : out std_logic_vector(15 downto 0)
        );
    end Component;

    Component PCAdd1 is
        Port (
            PCin : in  STD_LOGIC_VECTOR (15 downto 0);
            PCout : out  STD_LOGIC_VECTOR (15 downto 0));
    end Component;

    Component MUX_IF_ID IS PORT (
        InsType :  OUT    STD_LOGIC_VECTOR(4  downto 0);
        rx      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
        ry      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
        rz      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
        funct   :  OUT    STD_LOGIC_VECTOR(1  downto 0);
        imme    :  OUT    STD_LOGIC_VECTOR(7  downto 0)
    );
    END Component;

    Component ImmExtend is 
        port 
        (
            ImmeSrc: in std_logic_vector(2 downto 0);
            inImme: in std_logic_vector(10 downto 0);
            ZeroExtend: in std_logic;
            Imme: out std_logic_vector(15 downto 0)
        );
    end Component;

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
        CLK:  IN  STD_LOGIC;
        RST:  IN  STD_LOGIC;
        A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        OP :  IN  STD_LOGIC_VECTOR(4  downto 0);
        F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
        Zero: OUT STD_LOGIC);
    END Component;

    Component RegisterFile IS PORT (
        CLK      :  IN  STD_LOGIC;
        ReadAddrA:  IN  STD_LOGIC_VECTOR(2  downto 0);
        ReadAddrB:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteAddr:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteData:  IN  STD_LOGIC_VECTOR(15 downto 0);
        ReadDataA:  OUT STD_LOGIC_VECTOR(15 downto 0);
        ReadDataB:  OUT STD_LOGIC_VECTOR(15 downto 0);
        WriteEn:    OUT STD_LOGIC_VECTOR(15 downto 0));
    END Component;

    Component InstructionMemory IS PORT (
        CLK      :  IN     STD_LOGIC;
        CE       :  OUT    STD_LOGIC;
        WE       :  OUT    STD_LOGIC;
        OE       :  OUT    STD_LOGIC;
        ReadAddr :  IN     STD_LOGIC_VECTOR(17 downto 0);
        ReadData :  INOUT  STD_LOGIC_VECTOR(15 downto 0));
    END Component;

    Component video_sync IS PORT (
        clock:                              IN STD_LOGIC;	-- should be 25M Hz
        video_on, Horiz_Sync, Vert_Sync:    OUT STD_LOGIC;
        H_count_out, V_count_out:			OUT STD_LOGIC_VECTOR(9 downto 0));
    END Component;

    SIGNAL clock_25 :                       STD_LOGIC;
    SIGNAL video_on:                        STD_LOGIC;
    SIGNAL t_hsync, t_vsync:                STD_LOGIC;
    SIGNAL H_count, V_count:                STD_LOGIC_VECTOR(9 downto 0);
    
    CONSTANT zero3:         STD_LOGIC_VECTOR(2 downto 0) := "000";
    CONSTANT background_r:  STD_LOGIC_VECTOR(2 downto 0) := zero3;
    CONSTANT background_g:  STD_LOGIC_VECTOR(2 downto 0) := zero3;
    CONSTANT background_b:  STD_LOGIC_VECTOR(2 downto 0) := zero3;


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

    DrawScreen: PROCESS(clock_25)
    BEGIN
        VGA_R <= background_r;
        VGA_G <= background_g;
        VGA_B <= background_b;
    END PROCESS;

END Behaviour;