-- ControlUnit.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.COMMON.ALL;

ENTITY ControlUnit IS PORT (
    clk         :  IN  STD_LOGIC;
    rst         :  IN  STD_LOGIC;
    CurPC       :  IN  STD_LOGIC_VECTOR(15 downto 0);
    Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
    Condition   :  IN  STD_LOGIC_VECTOR(15 downto 0);

    InDelayslot :  IN  STD_LOGIC;
    LastPCSel   :  IN  STD_LOGIC_VECTOR( 1 downto 0);

    ImmeSrc     :  OUT STD_LOGIC_VECTOR( 2 downto 0); -- 3, 4, 5, 8, 11 
    ZeroExt     :  OUT STD_LOGIC;                     

    ALUop       :  OUT STD_LOGIC_VECTOR( 3 downto 0);
    ASrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);
    BSrc        :  OUT STD_LOGIC_VECTOR( 1 downto 0);

    MemRead     :  OUT STD_LOGIC;
    MemWE       :  OUT STD_LOGIC;    

    DstReg      :  OUT STD_LOGIC_VECTOR( 3 downto 0);
    RegWE       :  OUT STD_LOGIC;
    
    ASrc4       :  OUT STD_LOGIC_VECTOR(3 downto 0);
    BSrc4       :  OUT STD_LOGIC_VECTOR(3 downto 0);
    
    NextInDelayslot : OUT STD_LOGIC;
    PCMuxSel    :  OUT STD_LOGIC_VECTOR( 1 downto 0);

    NowPC       :  OUT STD_LOGIC_VECTOR(15 downto 0);
    ExceptPC    :  OUT STD_LOGIC_VECTOR(15 downto 0)
);
END ENTITY;

ARCHITECTURE Behaviour OF ControlUnit IS

    SIGNAL tempInsType :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL temp_Rx     :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL temp_Ry     :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL temp_Rz     :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL temp_1_0    :  STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL temp_4_0    :  STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL temp_7_0    :  STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL temp_10_8   :  STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL tempExcept  :  STD_LOGIC;
    SIGNAL tempExceptPC:  STD_LOGIC_VECTOR(15 downto 0);
BEGIN

    tempInsType <= Instruction(15 downto 11);
    temp_Rx     <= Instruction(10 downto  8);
    temp_Ry     <= Instruction( 7 downto  5);
    temp_Rz     <= Instruction( 4 downto  2);
    temp_10_8   <= Instruction(10 downto  8);
    temp_7_0    <= Instruction( 7 downto  0);
    temp_4_0    <= Instruction( 4 downto  0);
    temp_1_0    <= Instruction( 1 downto  0);

    PROCESS(clk, rst, Instruction, Condition, temp_1_0, temp_4_0, temp_7_0, temp_10_8, temp_Rz, temp_Ry, temp_Rx, tempInsType) -- with clk in the list, it will calculate again in falling edge
    BEGIN
        if rst = '0' THEN
            ImmeSrc     <= IMM_NONE;
            ZeroExt     <= ZERO_EXTEND_DISABLE;
            ALUop       <= OP_NONE;
            ASrc        <= AS_NONE;
            BSrc        <= AS_NONE;
            MemRead     <= RAM_READ_DISABLE;
            MemWE       <= RAM_WRITE_DISABLE;
            DstReg      <= Dst_NONE;
            RegWE       <= REG_WRITE_DISABLE;
            ASrc4       <= Dst_NONE;
            BSrc4       <= Dst_NONE;
            PCMuxSel    <= PC_Add1;
            NextInDelayslot <= IN_SLOT_FALSE;
            NowPC       <= CurPC;
            ExceptPC    <= ZERO16;
        else
            ImmeSrc     <= IMM_NONE;
            ZeroExt     <= ZERO_EXTEND_DISABLE;
            ALUop       <= OP_NONE;
            ASrc        <= AS_NONE;
            BSrc        <= AS_NONE;
            MemRead     <= RAM_READ_DISABLE;
            MemWE       <= RAM_WRITE_DISABLE;
            DstReg      <= Dst_NONE;
            RegWE       <= REG_WRITE_DISABLE;
            ASrc4       <= Dst_NONE;
            BSrc4       <= Dst_NONE;
            PCMuxSel    <= PC_Add1;
            NextInDelayslot <= IN_SLOT_FALSE;

            Case tempInsType IS
                WHEN TYPE_ADD_SUB =>
                    CASE temp_1_0 IS
                        WHEN FUNCT_ADD =>
                            ImmeSrc  <= IMM_NONE;                
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_ADD;
                            DstReg   <= "0" & temp_Rz;
                            RegWE    <= REG_WRITE_ENABLE;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= "0" & temp_Ry;

                        WHEN FUNCT_SUB =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_SUB;
                            DstReg   <= "0" & temp_Rz;
                            RegWE    <= REG_WRITE_ENABLE;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= "0" & temp_Ry;

                        WHEN others => 
                            tempExcept <= '1';
                            tempExceptPC <= CurPC;
                    END CASE;
                WHEN TYPE_AND_OR_CMP_MFPC_SLLV_SRLV_JR =>
                    CASE Instruction(4 downto 0) IS 
                        WHEN FUNCT_AND  =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_AND;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Rx;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= "0" & temp_Ry;
                            
                        WHEN FUNCT_OR   =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_OR;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Rx;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= "0" & temp_Ry;
                            
                        WHEN FUNCT_CMP  =>
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_CMP;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= Dst_T;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= "0" & temp_Ry;
                            
                        WHEN FUNCT_MFPC_JR =>
                            CASE temp_Ry IS 
                                WHEN FUNCT_MFPC => 
                                    ImmeSrc  <= IMM_NONE;
                                    ASrc4    <= Dst_PC;
                                    ASrc     <= AS_DATA1;
                                    BSrc     <= AS_NONE;
                                    ALUop    <= OP_POS;
                                    RegWE    <= REG_WRITE_ENABLE;
                                    DstReg   <= "0" & temp_Rx;
                                    
                                WHEN FUNCT_JR   => 
                                    ImmeSrc  <= IMM_EIGHT;
                                    RegWE    <= REG_WRITE_DISABLE;
                                    ASrc4    <= "0" & temp_Rx;
                                    DstReg   <= Dst_NONE;
                                    NextInDelayslot <= IN_SLOT_TRUE;
                                    PCMuxSel <= PC_Rx;
                                WHEN others =>
                                    null;
                            END CASE;
                            
                        WHEN FUNCT_SLLV =>
                            ImmeSrc   <= IMM_NONE;
                            ASrc      <= AS_DATA1;
                            BSrc      <= AS_DATA2;
                            ALUop     <= OP_SLL;
                            RegWE     <= REG_WRITE_ENABLE;
                            DstReg    <= "0" & temp_Ry;
                            ASrc4     <= "0" & temp_Ry;
                            BSrc4     <= "0" & temp_Rx;
                            
                        WHEN FUNCT_SRLV =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_DATA2;
                            ALUop    <= OP_SRL;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Ry;
                            ASrc4    <= "0" & temp_Ry;
                            BSrc4    <= "0" & temp_Rx;
                            
                        WHEN others => 
                            null;
                    END CASE;
                WHEN TYPE_MFIH_MTIH =>
                    CASE temp_7_0 IS
                        WHEN FUNCT_MFIH =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_NONE;
                            ALUop    <= OP_POS;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Rx;
                            ASrc4    <= Dst_IH;
                            BSrc4    <= Dst_NONE;
                            
                        WHEN FUNCT_MTIH =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_NONE;
                            ALUop    <= OP_POS;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= Dst_IH;
                            ASrc4    <= "0" & temp_Rx;
                            BSrc4    <= Dst_NONE;
                            
                        WHEN others => 
                            null;
                    END CASE;
                WHEN TYPE_MTSP_ADDSP_BTEQZ_BTNEZ =>
                    CASE temp_10_8 IS
                        WHEN FUNCT_MTSP =>
                            ImmeSrc  <= IMM_NONE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_NONE;
                            ALUop    <= OP_POS;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= Dst_SP;
                            ASrc4    <= "0" & temp_Ry;
                            BSrc4    <= Dst_NONE;
                        
                        WHEN FUNCT_ADDSP =>
                            ImmeSrc  <= IMM_EIGHT;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_IMME;
                            ALUop    <= OP_ADD;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= Dst_SP;
                            ASrc4    <= Dst_SP;
                            BSrc4    <= Dst_NONE;
                            
                        WHEN FUNCT_BTEQZ =>
                            ImmeSrc  <= IMM_EIGHT;
                            RegWE    <= REG_WRITE_DISABLE;
                            DstReg   <= Dst_NONE;
                            ASrc4    <= Dst_T;
                            BSrc4    <= Dst_NONE;
                            if(condition = ZERO16) THEN
                                PCMuxSel <= PC_AddImm;
                                NextInDelayslot <= IN_SLOT_TRUE;
                            else
                                PCMuxSel <= PC_Add1;
                            end if;
                            
                        WHEN FUNCT_BTNEZ =>
                            ImmeSrc  <= IMM_EIGHT;
                            RegWE    <= REG_WRITE_DISABLE;
                            DstReg   <= Dst_NONE;
                            ASrc4    <= Dst_T;
                            BSrc4    <= Dst_NONE;
                            if(not (condition = ZERO16)) THEN
                                PCMuxSel <= PC_AddImm;
                                NextInDelayslot <= IN_SLOT_TRUE;
                            else
                                PCMuxSel <= PC_Add1;
                            end if;
                        WHEN others =>
                            null;
                    END CASE;
                WHEN TYPE_SLL_SRA =>
                    CASE temp_1_0 IS
                        WHEN FUNCT_SLL =>
                            ImmeSrc  <= IMM_THREE;
                            ZeroExt  <= ZERO_EXTEND_ENABLE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_IMME;
                            ALUop    <= OP_SLL;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Rx;
                            ASrc4    <= "0" & temp_Ry;
                            BSrc4    <= Dst_NONE;
                            
                        WHEN FUNCT_SRA =>
                            ImmeSrc  <= IMM_THREE;
                            ZeroExt  <= ZERO_EXTEND_ENABLE;
                            ASrc     <= AS_DATA1;
                            BSrc     <= AS_IMME;
                            ALUop    <= OP_SRA;
                            RegWE    <= REG_WRITE_ENABLE;
                            DstReg   <= "0" & temp_Rx;
                            ASrc4    <= "0" & temp_Ry;
                            BSrc4    <= Dst_NONE;
                            
                        WHEN others =>
                            null;
                    END CASE;
                
                WHEN TYPE_MOVE =>
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_NONE;
                    ALUop    <= OP_POS;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Rx;
                    ASrc4    <= "0" & temp_Ry;
                    BSrc4    <= Dst_NONE;    
                                            
                WHEN TYPE_ADDIU =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Rx;
                    ASrc4    <= "0" & temp_Rx;
                    BSrc4    <= Dst_NONE;
                    
                WHEN TYPE_ADDIU3 =>
                    ImmeSrc  <= IMM_FOUR;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Ry;
                    ASrc4    <= "0" & temp_Rx;
                    BSrc4    <= Dst_NONE;
                    
                WHEN TYPE_LI =>
                    ImmeSrc  <= IMM_EIGHT;
                    ZeroExt  <= ZERO_EXTEND_ENABLE;
                    ASrc     <= AS_IMME;
                    ALUop    <= OP_POS;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Rx;
                    
                WHEN TYPE_SLTI =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_LT;       
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= Dst_T;
                    ASrc4    <= "0" & temp_Rx;
                    BSrc4    <= Dst_NONE;
                    
                WHEN TYPE_LW =>
                    ImmeSrc  <= IMM_FIVE;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    MemRead  <= RAM_READ_ENABLE;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Ry;
                    ASrc4    <= "0" & temp_Rx;
                    BSrc4    <= Dst_NONE;
                    
                WHEN TYPE_LW_SP =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    MemRead  <= RAM_READ_ENABLE;
                    RegWE    <= REG_WRITE_ENABLE;
                    DstReg   <= "0" & temp_Rx;
                    ASrc4    <= Dst_SP;
                    BSrc4    <= Dst_NONE;
                    
                WHEN TYPE_SW =>
                    ImmeSrc  <= IMM_FIVE;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    MemWE    <= RAM_WRITE_ENABLE;
                    -- RegWE    <= REG_WRITE_DISABLE;
                    -- DstReg   <= Dst_NONE;
                    ASrc4    <= "0" & temp_Rx;
                    BSrc4    <= "0" & temp_Ry;
                    
                WHEN TYPE_SW_SP =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc     <= AS_DATA1;
                    BSrc     <= AS_IMME;
                    ALUop    <= OP_ADD;
                    MemWE    <= RAM_WRITE_ENABLE;
                    RegWE    <= REG_WRITE_DISABLE;
                    DstReg   <= Dst_NONE;
                    ASrc4    <= Dst_SP;
                    BSrc4    <= "0" & temp_Rx;
                    
                WHEN TYPE_B =>
                    ImmeSrc  <= IMM_ELEVEN;
                    ASrc     <= AS_NONE;
                    BSrc     <= AS_NONE;
                    RegWE    <= REG_WRITE_DISABLE;
                    DstReg   <= Dst_NONE;
                    ASrc4    <= Dst_NONE;
                    BSrc4    <= Dst_NONE;
                    PCMuxSel <= PC_AddImm;
                    NextInDelayslot <= IN_SLOT_TRUE;
                WHEN TYPE_BEQZ =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc4    <= '0' & temp_Rx;
                    ASrc     <= AS_NONE;
                    BSrc     <= AS_NONE;
                    RegWE    <= REG_WRITE_DISABLE;
                    DstReg   <= Dst_NONE;
                    if (condition = ZERO16) THEN
                        PCMuxSel <= PC_AddImm;
                        NextInDelayslot <= IN_SLOT_TRUE;
                    else
                        PCMuxSel <= PC_Add1;
                    end if;
                WHEN TYPE_BNEZ =>
                    ImmeSrc  <= IMM_EIGHT;
                    ASrc4    <= '0' & temp_Rx;
                    RegWE    <= REG_WRITE_DISABLE;
                    DstReg   <= Dst_NONE;
					ASrc4    <= '0' & temp_Rx;
                    if (not (condition = ZERO16)) THEN
                        PCMuxSel <= PC_AddImm;
                        NextInDelayslot <= IN_SLOT_TRUE;
                    else
                        PCMuxSel <= PC_Add1;
                    end if;
                WHEN TYPE_NOP =>
                    ImmeSrc  <= IMM_NONE;
                    ASrc     <= AS_NONE;
                    BSrc     <= AS_NONE;
                    RegWE    <= REG_WRITE_DISABLE;
                    DstReg   <= Dst_NONE;
                    ASrc4    <= Dst_NONE;
                    BSrc4    <= Dst_NONE;
                    
                WHEN others =>
                    null;
            END CASE;
        end if;
    END PROCESS;

END ARCHITECTURE;
