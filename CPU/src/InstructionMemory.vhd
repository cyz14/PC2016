-- InstructionMemory.vhd

ENTITY InstructionMemory IS
PORT (
    CLK      :  IN     STD_LOGIC;
    CE       :  OUT    STD_LOGIC;
    WE       :  OUT    STD_LOGIC;
    OE       :  OUT    STD_LOGIC;
    ReadAddr :  IN     STD_LOGIC_VECTOR(17 downto 0);
    ReadData :  INOUT  STD_LOGIC_VECTOR(15 downto 0)
);
END InstructionMemory;


ARCHITECTURE Behaviour OF InstructionMemory IS

BEGIN


END Behaviour; 