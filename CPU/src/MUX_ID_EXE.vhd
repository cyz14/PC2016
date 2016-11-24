-- MUX_ID_EXE.vhd

ENTITY MUX_ID_EXE IS PORT (
    Clk:        IN     STD_LOGIC;
    Rst:        IN     STD_LOGIC;
    
    Data1:      IN     STD_LOGIC_VECTOR(15 downto 0);
    Data2:      IN     STD_LOGIC_VECTOR(15 downto 0);
    Immediate:  IN     STD_LOGIC_VECTOR(15 downto 0);

    DstReg:     IN     STD_LOGIC_VECTOR( 2 downto 0);
    RegWE:      IN     STD_LOGIC;

    MemRead:    IN     STD_LOGIC;
    MemWE:      IN     STD_LOGIC;

    ALUOp:      IN     STD_LOGIC_VECTOR( 3 downto 0);
    ASrc:       IN     STD_LOGIC_VECTOR( 1 downto 0);
    BSrc:       IN     STD_LOGIC_VECTOR( 1 downto 0);

    ASrc4:      IN     STD_LOGIC_VECTOR( 3 downto 0);
    BSrc4:      IN     STD_LOGIC_VECTOR( 3 downto 0);

    Stall:      IN     STD_LOGIC; -- whether stop for a stage from HazardDetectingUnit

    outData1:      OUT    STD_LOGIC_VECTOR(15 downto 0);
    outData2:      OUT    STD_LOGIC_VECTOR(15 downto 0);
    outImmediate:  OUT    STD_LOGIC_VECTOR(15 downto 0);
    outDstReg:     OUT    STD_LOGIC_VECTOR( 2 downto 0);
    outRegWE:      OUT    STD_LOGIC;

    outMemRead:    OUT    STD_LOGIC;
    outMemWE:      OUT    STD_LOGIC;

    outALUOp:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    outASrc:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
    outBSrc:       OUT    STD_LOGIC_VECTOR( 1 downto 0);
    outASrc4:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    outBSrc4:      OUT    STD_LOGIC_VECTOR( 3 downto 0);
    MemWriteData:  OUT    STD_LOGIC_VECTOR(15 downto 0)
);
END MUX_ID_EXE;

ARCHITECTURE Behaviour OF MUX_ID_EXE IS

    CONSTANT ZERO1 : STD_LOGIC := '0';
    CONSTANT ZERO2 : STD_LOGIC_VECTOR(1 downto 0) := "00";
    CONSTANT ZERO3 : STD_LOGIC_VECTOR(2 downto 0) := "000";
    CONSTANT ZERO4 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    CONSTANT ZERO16: STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);

BEGIN

    PROCESS(Stall, Clk, Rst)
    BEGIN
        IF (Rst = '0') THEN
            outDstReg <= ZERO3;
            outRegWE  <= ZERO1;
            outMemRead<= ZERO1;
            outMemWE  <= ZERO1;
            outALUOp  <= ZERO4;
            outASrc   <= ZERO2;
            outBSrc   <= ZERO2;
            outData1  <= ZERO16;
            outData2  <= ZERO16;
            outImmediate <= ZERO16;
            outRx     <= ZERO3;
            outRy     <= ZERO3;
        ELSIF (rising_edge(Clk)) THEN
            IF Stall = '1' THEN
                 -- do nothing, wait for a period until Stall is 0
            ELSE
                outDstReg <= DstReg;
                outRegWE  <= RegWE;
                outMemRead<= MemRead;
                outMemWE  <= MemWE;
                outALUOp  <= ALUOp;
                outASrc   <= ASrc;
                outBSrc   <= BSrc;
                outData1  <= Data1;
                outData2  <= Data2;
                outImmediate <= Immediate;
                outRx     <= Rx;
                outRy     <= Ry;
            END IF;
        END IF;
    END PROCESS;

END Behaviour;