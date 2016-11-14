-- RegisterFile.vhd

ENTITY RegisterFile IS
PORT (
    CLK      :  IN  STD_LOGIC;
    ReadAddrA:  IN  STD_LOGIC_VECTOR(2  downto 0);
    ReadAddrB:  IN  STD_LOGIC_VECTOR(2  downto 0);
    WriteAddr:  IN  STD_LOGIC_VECTOR(2  downto 0);
    WriteData:  IN  STD_LOGIC_VECTOR(15 downto 0);
    ReadDataA:  OUT STD_LOGIC_VECTOR(15 downto 0);
    ReadDataB:  OUT STD_LOGIC_VECTOR(15 downto 0);
    WriteEn:    OUT STD_LOGIC_VECTOR(15 downto 0)
);
END RegisterFile;

ARCHITECTURE Behaviour OF RegisterFile IS
    SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL SP, IH, T, RA, PC              : STD_LOGIC_VECTOR(15 downto 0);
BEGIN
    

END Behaviour;