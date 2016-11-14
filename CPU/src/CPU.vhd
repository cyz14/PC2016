-- CPU.vhd

ENTITY CPU IS PORT (
    CLK :  IN  STD_LOGIC;
    RST :  IN  STD_LOGIC;
    INT :  IN  STD_LOGIC;
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
    DebugInfo:   OUT   STD_LOGIC_VECTOR(15 downto 0)
);
END CPU;

ARCHITECTURE Behaviour OF CPU IS
    Component ALU IS PORT (
        CLK:  IN  STD_LOGIC;
        RST:  IN  STD_LOGIC;
        A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        OP :  IN  STD_LOGIC_VECTOR(4  downto 0);
        F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
        Zero: OUT STD_LOGIC
    );
    END Component;

    Component RegisterFile IS PORT (
        CLK      :  IN  STD_LOGIC;
        ReadAddrA:  IN  STD_LOGIC_VECTOR(2  downto 0);
        ReadAddrB:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteAddr:  IN  STD_LOGIC_VECTOR(2  downto 0);
        WriteData:  IN  STD_LOGIC_VECTOR(15 downto 0);
        ReadDataA:  OUT STD_LOGIC_VECTOR(15 downto 0);
        ReadDataB:  OUT STD_LOGIC_VECTOR(15 downto 0);
        WriteEn:    OUT STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

    Component InstructionMemory IS PORT (
        CLK      :  IN     STD_LOGIC;
        CE       :  OUT    STD_LOGIC;
        WE       :  OUT    STD_LOGIC;
        OE       :  OUT    STD_LOGIC;
        ReadAddr :  IN     STD_LOGIC_VECTOR(17 downto 0);
        ReadData :  INOUT  STD_LOGIC_VECTOR(15 downto 0)
    );
    END Component;

BEGIN

END Behaviour;