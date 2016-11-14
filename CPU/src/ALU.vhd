-- ALU.vhd

ENTITY ALU IS
PORT (
    CLK:  IN  STD_LOGIC;
    RST:  IN  STD_LOGIC;
    A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
    B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
    OP :  IN  STD_LOGIC_VECTOR(4  downto 0);
    F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
    Zero: OUT STD_LOGIC  
);
END ALU;

ARCHITECTURE Behaviour OF ALU IS
    SIGNAL tempAdd: STD_LOGIC_VECTOR(16 downto 0);
    SIGNAL tempSub: STD_LOGIC_VECTOR(16 downto 0);
    
    SIGNAL tempAnd: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempXor: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempSLL: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempSRL: STD_LOGIC_VECTOR(15 downto 0);
BEGIN


END Behaviour;
