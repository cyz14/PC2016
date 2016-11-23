-- ControlUnit.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Control IS PORT (
    Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
    Condition   :  IN  STD_LOGIC_VECTOR( 1 downto 0);
    
    Data1Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
    Data2Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
    ImmeSrc     :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- 3, 4, 5, 8, 11 
    ZeroExt     :  OUT STD_LOGIC;                     -- 是否ZeroExt 

    ALUop       :  OUT STD_LOGIC_VECTOR( 3 downto 0); -- ALU 的操作类
    ASrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0); -- ALU 前面 A 数据选择器选择信号
    BSrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0); -- ALU 前面 B 数据选择器选择信号

    MemRead     :  OUT STD_LOGIC; -- 是否读数 WB阶段的数据选择来源 ALUOut 还是 MemDout 的数据。若读，则为 MemDout, 否则 ALUOut
    MemWE       :  OUT STD_LOGIC; -- 是否写内 

    DstReg      :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- WB阶段的目的寄存器
    RegWE       :  OUT STD_LOGIC; -- WB阶段的写使能

    PCMuxSel    :  OUT STD_LOGIC_VECTOR( 2 downto 0)
);
END ENTITY;

ARCHITECTURE Behaviour OF Control IS

    CONSTANT TYPE_ADD_SUB :  STD_LOGIC_VECTOR(4 downto 0) := "11100";
    CONSTANT FUNCT_ADD    :  STD_LOGIC_VECTOR(1 downto 0) := "01";
    CONSTANT FUNCT_SUB    :  STD_LOGIC_VECTOR(1 downto 0) := "11";

    CONSTANT TYPE_AND_OR_CMP_MFPC_SLLV_SRLV: STD_LOGIC_VECTOR(4 downto 0) := "11101";
    CONSTANT FUNCT_AND    :  STD_LOGIC_VECTOR(4 downto 0) := "01100";
    CONSTANT FUNCT_OR     :  STD_LOGIC_VECTOR(4 downto 0) := "01101";
    CONSTANT FUNCT_CMP    :  STD_LOGIC_VECTOR(4 downto 0) := "01010";
    CONSTANT FUNCT_MFPC   :  STD_LOGIC_VECTOR(4 downto 0) := "00000";
    CONSTANT FUNCT_SLLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00100";
    CONSTANT FUNCT_SRLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00110";

    TYPE DataSrc IS (DS_NONE, DS_RX, DS_RY, DS_SP, DS_IH, DS_T);
    TYPE ALUSRc  IS (AS_NONE, AS_DATA1, AS_DATA2, AS_IMME);
    Type ALUOP IS (
        OP_NONE,-- No operation 
        OP_ADD, -- F <= A  +  B
        OP_SUB, -- F <= A  -  B
        OP_AND, -- F <= A  &  B
        OP_OR,  -- F <= A  |  B
        OP_XOR, -- F <= A xor B
        OP_CMP, -- F <= A !=  B, not equal
        OP_LT,  -- F <= A  <  B
        OP_POS, -- F <= A
        OP_SLL, -- F <= A <<  B
        OP_SRL, -- F <= A >>  B(logical)
        OP_SRA -- F <= A >>  B(arith)
        );

    SIGNAL tempInsType :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL tempRx      :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempRy      :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempRz      :  STD_LOGIC_VECTOR(2 downto 0); 
    SIGNAL temp_1_0    :  STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL temp_4_0    :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL temp_7_0    :  STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL tempALUop   :  STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    tempInsType <= Instruction(15 downto 11);
    tempRx      <= Instruction(10 downto  8);
    tempRy      <= Instruction( 7 downto  5);
    tempRz      <= Instruction( 4 downto  2);
    temp_7_0    <= Instruction( 7 downto  0);
    temp_4_0    <= Instruction( 4 downto  0);
    temp_1_0    <= Instruction( 1 downto  0);
    
    ALUop <= tempALUop;
    
    PROCESS(Instruction, Condition)
    BEGIN
        CASE tempInsType IS
            WHEN TYPE_ADD_SUB =>
                CASE temp_1_0 IS
                    WHEN FUNCT_ADD =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_ADD;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        DstReg   <= tempRz;
                        RegWE    <= '1';
                        PCMuxSel <= "00";
                    WHEN FUNCT_SUB =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SUB;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        DstReg   <= tempRz;
                        RegWE    <= '1';
                        --PCMuxSel <= ;
                END CASE;
            WHEN TYPE_AND_OR_CMP_MFPC_SLLV_SRLV =>
                CASE temp_4_0 IS 
                    WHEN FUNCT_AND  =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_AND;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRx;
                        --PCMuxSel <= ;
                    WHEN FUNCT_OR   =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_OR;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRx;
                        --PCMuxSel <= ";
                    WHEN FUNCT_CMP  =>
                    WHEN FUNCT_MFPC =>
                    WHEN FUNCT_SLLV =>
                    WHEN FUNCT_SRLV => 
                END CASE;
        END CASE;
    END PROCESS;


END ARCHITECTURE;
