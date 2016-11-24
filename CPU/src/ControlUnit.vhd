-- ControlUnit.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.common.ALL;

ENTITY ControlUnit IS PORT (
    Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
    Condition   :  IN  STD_LOGIC_VECTOR( 1 downto 0);
    
    Data1Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
    Data2Src    :  OUT STD_LOGIC_VECTOR( 2 downto 0);
    ImmeSrc     :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- 3, 4, 5, 8, 11 
    ZeroExt     :  OUT STD_LOGIC;                     

    ALUop       :  OUT STD_LOGIC_VECTOR( 3 downto 0);
    ASrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);
    BSrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);

    MemRead     :  OUT STD_LOGIC;
    MemWE       :  OUT STD_LOGIC; 

    DstReg      :  OUT STD_LOGIC_VECTOR( 3 downto 0);
    RegWE       :  OUT STD_LOGIC;

    PCMuxSel    :  OUT STD_LOGIC_VECTOR( 2 downto 0)
);
END ENTITY;

ARCHITECTURE Behaviour OF ControlUnit IS

    CONSTANT TYPE_ADD_SUB :  STD_LOGIC_VECTOR(4 downto 0) := "11100";
    CONSTANT TYPE_AND_OR_CMP_MFPC_SLLV_SRLV: STD_LOGIC_VECTOR(4 downto 0) := "11101";
    CONSTANT TYPE_MFIH_MTIH : STD_LOGIC_VECTOR(4 downto 0):= "11110";
    CONSTANT TYPE_MTSP_ADDSP_BTEQZ_BTNEZ :  STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- 01100
    CONSTANT TYPE_SLL_SRA :  STD_LOGIC_VECTOR(4 downto 0) := "00110";
    CONSTANT TYPE_MOVE    :  STD_LOGIC_VECTOR(4 downto 0) := "01111";
    CONSTANT TYPE_ADDIU   :  STD_LOGIC_VECTOR(4 downto 0) := "01001";
    CONSTANT TYPE_ADDIU3  :  STD_LOGIC_VECTOR(4 downto 0) := "01000";
    CONSTANT TYPE_LI      :  STD_LOGIC_VECTOR(4 downto 0) := "01101";
    CONSTANT TYPE_SLTI    :  STD_LOGIC_VECTOR(4 downto 0) := "01010";
    CONSTANT TYPE_LW      :  STD_LOGIC_VECTOR(4 downto 0) := "10011";
    CONSTANT TYPE_LW_SP   :  STD_LOGIC_VECTOR(4 downto 0) := "10010";
    CONSTANT TYPE_SW      :  STD_LOGIC_VECTOR(4 downto 0) := "11011";
    CONSTANT TYPE_SW_SP   :  STD_LOGIC_VECTOR(4 downto 0) := "11010";
    CONSTANT TYPE_B       :  STD_LOGIC_VECTOR(4 downto 0) := "00010";
    CONSTANT TYPE_BEQZ    :  STD_LOGIC_VECTOR(4 downto 0) := "00100";
    CONSTANT TYPE_BNEZ    :  STD_LOGIC_VECTOR(4 downto 0) := "00101";
    CONSTANT TYPE_JR      :  STD_LOGIC_VECTOR(4 downto 0) := "11101";
    CONSTANT TYPE_NOP     :  STD_LOGIC_VECTOR(4 downto 0) := "00001";
    -- CONSTANT InstNop   :  STD_LOGIC_VECTOR(15 downto 0):= "0000100000000000";
    
    CONSTANT FUNCT_ADD    :  STD_LOGIC_VECTOR(1 downto 0) := "01";
    CONSTANT FUNCT_SUB    :  STD_LOGIC_VECTOR(1 downto 0) := "11";
    
    CONSTANT FUNCT_AND    :  STD_LOGIC_VECTOR(4 downto 0) := "01100";
    CONSTANT FUNCT_OR     :  STD_LOGIC_VECTOR(4 downto 0) := "01101";
    CONSTANT FUNCT_CMP    :  STD_LOGIC_VECTOR(4 downto 0) := "01010";
    CONSTANT FUNCT_MFPC   :  STD_LOGIC_VECTOR(4 downto 0) := "00000";
    CONSTANT FUNCT_SLLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00100";
    CONSTANT FUNCT_SRLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00110";
    
    CONSTANT FUNCT_MFIH   :  STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    CONSTANT FUNCT_MTIH   :  STD_LOGIC_VECTOR(7 downto 0) := "00000001";

    CONSTANT FUNCT_MTSP   :  STD_LOGIC_VECTOR(2 downto 0) := "100";
    CONSTANT FUNCT_ADDSP  :  STD_LOGIC_VECTOR(2 downto 0) := "011";
    CONSTANT FUNCT_BTEQZ  :  STD_LOGIC_VECTOR(2 downto 0) := "000";
    CONSTANT FUNCT_BTNEZ  :  STD_LOGIC_VECTOR(2 downto 0) := "001";
    
    CONSTANT FUNCT_SLL    :  STD_LOGIC_VECTOR(1 downto 0) := "00";
    CONSTANT FUNCT_SRA    :  STD_LOGIC_VECTOR(1 downto 0) := "11";
    
    
    TYPE DataSrc IS (DS_NONE, DS_RX, DS_RY, DS_PCplus1, DS_SP, DS_IH, DS_T);
    TYPE ALUSRc  IS (AS_NONE, AS_DATA1, AS_DATA2, AS_IMME);
    TYPE PCMuxSrc IS (PS_PLUS1, PS_ADDI, PS_RX, PS_NONE);

    SIGNAL tempInsType :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL tempRx      :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempRy      :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempRz      :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL temp_1_0    :  STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL temp_4_0    :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL temp_7_0    :  STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL temp_10_8   :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempALUop   :  STD_LOGIC_VECTOR(3 downto 0);
    
BEGIN
    tempInsType <= Instruction(15 downto 11);
    tempRx      <= Instruction(10 downto  8);
    tempRy      <= Instruction( 7 downto  5);
    tempRz      <= Instruction( 4 downto  2);
    temp_10_8   <= Instruction(10 downto  8);
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
                        PCMuxSel <= "00";
                    WHEN FUNCT_OR   =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_OR;
                        MemRead  <= '0';
                        MemWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRx;
                        PCMuxSel <= "00";
                    WHEN FUNCT_CMP  =>
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
                        PCMuxSel <= "00";
                    WHEN FUNCT_MFPC =>
                        Data1Src <= DS_PCplus1;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_POS;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRx;
                        PCMuxSel <= "00";
                    WHEN FUNCT_SLLV =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SLL;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRy;
                        PCMuxSel <= "00";
                    WHEN FUNCT_SRLV =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SRL;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRy;
                        PCMuxSel <= "00";
                END CASE;
            WHEN TYPE_MFIH_MTIH =>
                CASE temp_1_0 IS
                    WHEN FUNCT_MFIH =>
                        Data1Src <= DS_IH;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_NONE;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= tempRx;
                        PCMuxSel <= "00";
                    WHEN FUNCT_MTIH =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= "000";
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_POS;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= RegIH;
                        PCMuxSel <= "00";
                    WHEN others =>
                    
                END CASE;
            WHEN TYPE_MTSP_ADDSP_BTEQZ_BTNEZ =>
                CASE temp_10_8 IS
                    WHEN FUNCT_MTSP =>
                    
                    WHEN FUNCT_ADDSP =>
                    
                    WHEN FUNCT_BTEQZ =>
                    
                    WHEN FUNCT_BTNEZ =>
                    
                    WHEN others =>
                    
                END CASE;
            WHEN TYPE_SLL_SRA =>
                CASE temp_1_0 IS
                    WHEN FUNCT_SLL =>
                    
                    WHEN FUNCT_SRA =>
                    
                    WHEN others =>
                        
                END CASE;
            
            WHEN TYPE_MOVE =>
            
            WHEN TYPE_ADDIU =>
            
            WHEN TYPE_ADDIU3 =>
            
            WHEN TYPE_LI =>
            
            WHEN TYPE_SLTI =>
            
            WHEN TYPE_LW =>
            
            WHEN TYPE_LW_SP =>
            
            WHEN TYPE_SW =>
            
            WHEN TYPE_SW_SP =>
            
            WHEN TYPE_B =>
            
            WHEN TYPE_BEQZ =>
            
            WHEN TYPE_BNEZ =>
            
            WHEN TYPE_JR =>
            
            WHEN TYPE_NOP =>
            
            WHEN others =>
            
        END CASE;
    END PROCESS;


END ARCHITECTURE;
