-- Ctrl_EXE.vhd

ENTITY Ctrl_EXE IS PORT (
    InsType :  In  STD_LOGIC_VECTOR(4 downto 0);  -- Ins(15 downto 11)
    rx      :  IN  STD_LOGIC_VECTOR(2 downto 0);  -- Ins(10 downto  8)
    ry      :  IN  STD_LOGIC_VECTOR(2 downto 0);  -- Ins(7  downto  5)
    rz      :  IN  STD_LOGIC_VECTOR(2 downto 0);  -- Ins(4  downto  2)
    funct   :  IN  STD_LOGIC_VECTOR(4 downto 0);  -- Ins(1  downto  0)
    ALUop   :  OUT STD_LOGIC_VECTOR(3 downto 0)
);
END Ctrl_EXE;

ARCHITECTURE Behaviour OF Ctrl_EXE IS

    CONSTANT TYPE_R_ADDU   : STD_LOGIC_VECTOR(4 downto 0) := "11100"; -- ADDU_SUBU
    CONSTANT TYPE_R_AND    : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- AND_OR_CMP_MFPC_SLLV_SRLV
    CONSTANT TYPE_R_MFIH   : STD_LOGIC_VECTOR(4 downto 0) := "11110"; -- MFIH_MTIH
    CONSTANT TYPE_R_MTSP   : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- MTSP_ADDSP_BTEQZ_BTNEZ, MTSP:01100100
    CONSTANT TYPE_R_SLL    : STD_LOGIC_VECTOR(4 downto 0) := "00110"; -- SLL_SRA
    CONSTANT TYPE_R_MOVE   : STD_LOGIC_VECTOR(4 downto 0) := "01111"; -- MOVE
    CONSTANT TYPE_R_ADDIU  : STD_LOGIC_VECTOR(4 downto 0) := "01001";
    CONSTANT TYPE_R_ADDIU3 : STD_LOGIC_VECTOR(4 downto 0) := "01000";
    CONSTANT TYPE_R_LI     : STD_LOGIC_VECTOR(4 downto 0) := "01101";
    CONSTANT TYPE_R_LW     : STD_LOGIC_VECTOR(4 downto 0) := "10011";
    CONSTANT TYPE_R_LW_SP  : STD_LOGIC_VECTOR(4 downto 0) := "10010";
    CONSTANT TYPE_R_SW     : STD_LOGIC_VECTOR(4 downto 0) := "11011";
    CONSTANT TYPE_R_SW_SP  : STD_LOGIC_VECTOR(4 downto 0) := "11010"; 
    CONSTANT TYPE_R_SLTI   : STD_LOGIC_VECTOR(4 downto 0) := "01010"; -- LessThanImmediate
    CONSTANT TYPE_R_B      : STD_LOGIC_VECTOR(4 downto 0) := "00010";
    CONSTANT TYPE_R_BEQZ   : STD_LOGIC_VECTOR(4 downto 0) := "00100";
    CONSTANT TYPE_R_BNEZ   : STD_LOGIC_VECTOR(4 downto 0) := "00101";
    CONSTANT TYPE_R_JR     : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    CONSTANT TYPE_R_NOP    : STD_LOGIC_VECTOR(4 downto 0) := "00001";

    CONSTANT TYPE_I_ADDIU  : STD_LOGIC_VECTOR(4 downto 0) := "01001";
    CONSTANT TYPE_I_ADDIU3 : STD_LOGIC_VECTOR(4 downto 0) := "01000";
    CONSTANT TYPE_I_ADDSP  : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- "01100011", rx = "011"
    CONSTANT TYPE_I_LI     : STD_LOGIC_VECTOR(4 downto 0) := "01101";
    CONSTANT TYPE_I_LW     : STD_LOGIC_VECTOR(4 downto 0) := "10011";
    CONSTANT TYPE_I_LW_SP  : STD_LOGIC_VECTOR(4 downto 0) := "10010";
    CONSTANT TYPE_I_SW     : STD_LOGIC_VECTOR(4 downto 0) := "11011";
    CONSTANT TYPE_I_SW_SP  : STD_LOGIC_VECTOR(4 downto 0) := "11010";
    CONSTANT TYPE_I_SLTI   : STD_LOGIC_VECTOR(4 downto 0) := "01010";

    CONSTANT TYPE_J_B      : STD_LOGIC_VECTOR(4 downto 0) := "00010";
    CONSTANT TYPE_J_BEQZ   : STD_LOGIC_VECTOR(4 downto 0) := "00100";
    CONSTANT TYPE_J_BNEZ   : STD_LOGIC_VECTOR(4 downto 0) := "00101";
    CONSTANT TYPE_J_BTEQZ  : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- "01100000", rx = "000"
    CONSTANT TYPE_J_JR     : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    CONSTANT TYPE_J_BTNEZ  : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- "01101001", rx = "001"
    CONSTANT TYPE_J_NOP    : STD_LOGIC_VECTOR(4 downto 0) := "00001"; -- "0000100000000000"
    

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

    -- CONSTANT OP_ADD      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    -- CONSTANT OP_SUB      : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    -- CONSTANT OP_AND      : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    -- CONSTANT OP_OR       : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    -- CONSTANT OP_CMP      : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    -- CONSTANT OP_SLL      : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    -- CONSTANT OP_SRL      : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    -- CONSTANT OP_SRA      : STD_LOGIC_VECTOR(3 downto 0) := "0111";

    SIGNAL tempALUop     : ALUOP := "0000";

BEGIN
    PROCESS (InsType, funct, ALUop)
    BEGIN
        CASE InsType IS
            WHEN TYPE_R_ADDU    =>
                tempALUop <= OP_ADD;

            WHEN TYPE_R_AND     => -- AND_OR_CMP_MFPC_SLLV_SRLV
                CASE rz IS
                    WHEN "011" => 
                        CASE funct IS
                            WHEN "00" =>
                                tempALUop <= OP_AND;
                            WHEN "01" =>
                                tempALUop <= OP_OR;
                            WHEN others =>
                                tempALUop <= OP_NONE;
                        END CASE;
                    WHEN "010" => 
                        tempALUop <= OP_CMP;
                    WHEN "001" => 
                        CASE funct IS
                            WHEN "00" =>
                                tempALUop <= OP_SLL;
                            WHEN "10" =>
                                tempALUop <= OP_SRL;
                            WHEN others =>
                                tempALUop <= OP_NONE;
                        END CASE;
                    WHEN others => 
                            tempALUop <= OP_NONE;
                END CASE;

            WHEN TYPE_R_MFIH    => -- MFIH_MTIH
                tempALUop <= OP_NONE;

            WHEN TYPE_R_MTSP    => -- MTSP_ADDSP_BTEQZ_BTNEZ
                CASE rx IS
                    WHEN "100" => -- MTSP
                        tempALUop <= OP_NONE;
                    WHEN "011" => -- ADDSP
                        tempALUop <= OP_ADD;
                    WHEN "000" => -- BTEQZ
                        tempALUop <= OP_CMP;
                    WHEN "001" => -- BTNEZ
                        tempALUop <= OP_CMP;
                    WHEN others => 
                END CASE;

            WHEN TYPE_R_SLL     =>
                CASE funct IS
                    WHEN "00" =>
                        tempALUop <= OP_SLL;
                    WHEN "11" => 
                        tempALUop <= OP_SRA;
                    WHEN others =>
                END CASE;
                

            WHEN TYPE_R_MOVE    =>
                tempALUop <= OP_NONE;

            WHEN TYPE_R_ADDIU   =>
            WHEN TYPE_R_ADDIU3  =>
            WHEN TYPE_R_LI      =>
            WHEN TYPE_R_LW      => 
            WHEN TYPE_R_LW_SP   =>
            WHEN TYPE_R_SW      =>
            WHEN TYPE_R_SW_SP   =>
            WHEN TYPE_R_SLTI    =>
            WHEN TYPE_R_B       =>
            WHEN TYPE_R_BEQZ    =>
            WHEN TYPE_R_BNEZ    => 
            WHEN TYPE_R_JR      =>
            WHEN TYPE_R_NOP     =>
            WHEN others       =>
            ;
        END CASE:
    END PROCESS;

END Behaviour;