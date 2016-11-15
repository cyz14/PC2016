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

    Type ALUOP IS (OP_NONE, 
        OP_ADD, -- C <= A +  B
        OP_SUB, -- C <= A -  B
        OP_AND, -- C <= A &  B
        OP_OR,  -- C <= A |  B
        OP_CMP, -- C <= A != B 
        OP_LT,  -- C <= A <  B
        OP_SLL, -- C <= A << B
        OP_SRL, -- C <= A >> B(logical)
        OP_SRA  -- C <= A >> B(arith)
        );

    SIGNAL tempAdd: STD_LOGIC_VECTOR(16 downto 0);
    SIGNAL tempSub: STD_LOGIC_VECTOR(16 downto 0);
    SIGNAL tempAnd: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempOr : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempSLL: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempSRL: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempSRA: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL tempCMP: STD_LOGIC;
    SIGNAL tempLT : STD_LOGIC;
BEGIN
    tempAdd <= ('0' & A) + ('0' & B);
    tempSub <= ('0' & A) - ('0' & B);
    tempAnd <= A and B;
    tempOr  <= A or  B;
    tempSLL <= A SLL B;
    tempSRL <= A SRL B;
    tempSRA <= A SRA B;
    
    if A < B then
        tempLT <= '1';
    else 
        tempLT <= '0';
    end if;

    


END Behaviour;
