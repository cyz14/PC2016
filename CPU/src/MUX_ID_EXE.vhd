-- MUX_ID_EXE.vhd

ENTITY MUX_ID_EXE IS PORT (
    clk:          IN     STD_LOGIC;
    rst:          IN     STD_LOGIC;
    Data1:        IN     STD_LOGIC_VECTOR(15 downto 0);
    Data2:        IN     STD_LOGIC_VECTOR(15 downto 0);
    Immediate:    IN     STD_LOGIC_VECTOR(15 downto 0);
    DstReg:       IN     STD_LOGIC_VECTOR( 2 downto 0);
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
    DstReg_o:     OUT    STD_LOGIC_VECTOR( 2 downto 0);
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
END MUX_ID_EXE;

ARCHITECTURE Behaviour OF MUX_ID_EXE IS

    CONSTANT ZERO1 : STD_LOGIC := '0';
    CONSTANT ZERO2 : STD_LOGIC_VECTOR(1 downto 0) := "00";
    CONSTANT ZERO3 : STD_LOGIC_VECTOR(2 downto 0) := "000";
    CONSTANT ZERO4 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    CONSTANT ZERO16: STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);

BEGIN

    PROCESS(Stall, clk, rst)
    BEGIN
        IF (rst = '0') THEN
            DstReg_o <= ZERO3;
            RegWE_o  <= ZERO1;
            MemRead_o<= ZERO1;
            MemWE_o  <= ZERO1;
            ALUOp_o  <= ZERO4;
            ASrc_o   <= ZERO2;
            BSrc_o   <= ZERO2;
            Data1_o  <= ZERO16;
            Data2_o  <= ZERO16;
            Immediate_o <= ZERO16;
            outRx     <= ZERO3;
            outRy     <= ZERO3;
        ELSIF (rising_edge(clk)) THEN
            IF Stall = '1' THEN
                 -- do nothing, wait for a period until Stall is 0
            ELSE
                DstReg_o <= DstReg;
                RegWE_o  <= RegWE;
                MemRead_o<= MemRead;
                MemWE_o  <= MemWE;
                ALUOp_o  <= ALUOp;
                ASrc_o   <= ASrc;
                BSrc_o   <= BSrc;
                Data1_o  <= Data1;
                Data2_o  <= Data2;
                Immediate_o <= Immediate;
                outRx     <= Rx;
                outRy     <= Ry;
            END IF;
        END IF;
    END PROCESS;

END Behaviour;