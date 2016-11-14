-- InstructionDecoder.vhd

ENTITY InstructionDecoder IS PORT (
    ins:   IN     STD_LOGIC_VECTOR(15 downto 0);
    op:    OUT    STD_LOGIC_VECTOR(4  downto 0);
    rx:    OUT    STD_LOGIC_VECTOR(2  downto 0);
    ry:    OUT    STD_LOGIC_VECTOR(2  downto 0);
    rz:    OUT    STD_LOGIC_VECTOR(2  downto 0);
    func:  OUT    STD_LOGIC_VECTOR(1  downto 0)
);
END InstructionDecoder;

ARCHITECTURE Behaviour OF InstructionDecoder IS

BEGIN
    

END Behaviour;