-- ControlUnit.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.common.ALL;

ENTITY ControlUnit IS PORT (
    Instruction :  IN  STD_LOGIC_VECTOR(15 downto 0); 
    Condition   :  IN  STD_LOGIC_VECTOR(15 downto 0);
    
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
    
    ASrc4       :  out std_logic_vector (3 downto 0);
    BSrc4       :  out std_logic_vector (3 downto 0);

    PCMuxSel    :  OUT STD_LOGIC_VECTOR( 2 downto 0)
);
END ENTITY;

ARCHITECTURE Behaviour OF ControlUnit IS

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
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_ADD;
                        MemRead  <= '1';
                        MemWE    <= '0';
                        DstReg   <= "0" & tempRz;
                        RegWE    <= '1';
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_SUB =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SUB;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        DstReg   <= "0" & tempRz;
                        RegWE    <= '1';
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
						PCMuxSel <= PC_Add1;
                        --PCMuxSel <= ;
                END CASE;
            WHEN TYPE_AND_OR_CMP_MFPC_SLLV_SRLV =>
                CASE temp_4_0 IS 
                    WHEN FUNCT_AND  =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_AND;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_OR   =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_OR;
                        MemRead  <= '0';
                        MemWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_CMP  =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_AND;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_MFPC =>
                        Data1Src <= DS_PCplus1;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_POS;
                        MemRead  <= '0';
                        MemwWE   <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= Dst_NONE;
						BSrc4    <= Dst_NONE;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_SLLV =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SLL;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRy;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_SRLV =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_RY;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_DATA2;
                        ALUop    <= OP_SRL;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRy;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= "0" & tempRy;
                        PCMuxSel <= PC_Add1;
                END CASE;
            WHEN TYPE_MFIH_MTIH =>
                CASE temp_7_0 IS
                    WHEN FUNCT_MFIH =>
                        Data1Src <= DS_IH;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_NONE;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= Dst_IH;
						BSrc4    <= Dst_NONE;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_MTIH =>
                        Data1Src <= DS_RX;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_POS;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= Dst_IH;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= Dst_NONE;
                        PCMuxSel <= PC_Add1;
                    WHEN others =>
                    
                END CASE;
            WHEN TYPE_MTSP_ADDSP_BTEQZ_BTNEZ =>
                CASE temp_10_8 IS
                    WHEN FUNCT_MTSP =>
						Data1Src <= DS_RX;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_NONE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_POS;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= Dst_SP;
						ASrc4    <= "0" & tempRx;
						BSrc4    <= Dst_NONE;
                        PCMuxSel <= PC_Add1;
                    
                    WHEN FUNCT_ADDSP =>
						Data1Src <= DS_SP;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_EIGHT;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_IMME;
                        ALUop    <= OP_ADD;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= Dst_SP;
						ASrc4    <= Dst_SP;
						BSrc4    <= Dst_NONE;
                        PCMuxSel <= PC_Add1;
                    WHEN FUNCT_BTEQZ =>
						Data1Src <= DS_T;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_EIGHT;
                        ZeroExt  <= '0';
                        ASrc     <= AS_NONE;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_NONE;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= Dst_NONE;
						ASrc4    <= Dst_NONE;
						BSrc4    <= Dst_NONE;
						if(condition = ZERO16) THEN
							PCMuxSel <= PCAddImm;
						else
							PCMuxSel <= PCAdd1;
						end if;
                        
                    WHEN FUNCT_BTNEZ =>
						Data1Src <= DS_T;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_EIGHT;
                        ZeroExt  <= '0';
                        ASrc     <= AS_NONE;
                        BSrc     <= AS_NONE;
                        ALUop    <= OP_NONE;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= Dst_NONE;
						ASrc4    <= Dst_NONE;
						BSrc4    <= Dst_NONE;
						if(not (condition = ZERO16)) THEN
							PCMuxSel <= PCAddImm;
						else
							PCMuxSel <= PCAdd1;
						end if;
                    WHEN others =>
                    
                END CASE;
            WHEN TYPE_SLL_SRA =>
                CASE temp_1_0 IS
                    WHEN FUNCT_SLL =>
						Data1Src <= DS_RY;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_THREE;
                        ZeroExt  <= '1';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_IMME;
                        ALUop    <= OP_SLL;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= "0" & tempRy;
						BSrc4    <= Dst_NONE;
						PCMuxSel <= PCAdd1;
                    WHEN FUNCT_SRA =>
						Data1Src <= DS_RY;
                        Data2Src <= DS_NONE;
                        ImmeSrc  <= IMM_THREE;
                        ZeroExt  <= '0';
                        ASrc     <= AS_DATA1;
                        BSrc     <= AS_IMME;
                        ALUop    <= OP_SRA;
                        MemRead  <= '0';
                        MemWE    <= '0';
                        RegWE    <= '1';
                        DstReg   <= "0" & tempRx;
						ASrc4    <= "0" & tempRy;
						BSrc4    <= Dst_NONE;
						PCMuxSel <= PCAdd1;
                    WHEN others =>
                        
                END CASE;
            
            WHEN TYPE_MOVE =>
				Data1Src <= DS_RY;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_NONE;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_NONE;
                ALUop    <= OP_POS;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRx;
				ASrc4    <= "0" & tempRy;
				BSrc4    <= Dst_NONE;	
				PCMuxSel <= PCAdd1;						
            WHEN TYPE_ADDIU =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRx;
				ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_ADDIU3 =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_FOUR;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRy;
				ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_LI =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '1';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_POS;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRx;
				ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_SLTI =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_T;
				ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_LW =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRy;
				ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_LW_SP =>
				Data1Src <= DS_SP;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= "0" & tempRx;
				ASrc4    <= Dst_SP;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_SW =>
				Data1Src <= DS_RX;
                Data2Src <= DS_RY;
                ImmeSrc  <= IMM_FIVE;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
	            ASrc4    <= "0" & tempRx;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_SW_SP =>
				Data1Src <= DS_SP;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_DATA1;
                BSrc     <= AS_IMME;
                ALUop    <= OP_ADD;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_SP;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAdd1;
            WHEN TYPE_B =>
				Data1Src <= DS_NONE;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_ELEVEN;
                ZeroExt  <= '0';
                ASrc     <= AS_NONE;
                BSrc     <= AS_NONE;
                ALUop    <= OP_NONE;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_NONE;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PCAddImm;
            WHEN TYPE_BEQZ =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_NONE;
                BSrc     <= AS_NONE;
                ALUop    <= OP_NONE;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_NONE;
				BSrc4    <= Dst_NONE;
				if (condition = ZERO16) THEN
					PCMuxSel <= PCAddImm;
				else
					PCMuxSel <= PCAdd1;
				end if;
            WHEN TYPE_BNEZ =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_NONE;
                BSrc     <= AS_NONE;
                ALUop    <= OP_NONE;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_NONE;
				BSrc4    <= Dst_NONE;
				if (not (condition = ZERO16)) THEN
					PCMuxSel <= PCAddImm;
				else
					PCMuxSel <= PCAdd1;
				end if;
            WHEN TYPE_JR =>
				Data1Src <= DS_RX;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_EIGHT;
                ZeroExt  <= '0';
                ASrc     <= AS_NONE;
                BSrc     <= AS_NONE;
                ALUop    <= OP_NONE;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_NONE;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PC_Rx;
            WHEN TYPE_NOP =>
				Data1Src <= DS_none;
                Data2Src <= DS_NONE;
                ImmeSrc  <= IMM_NONE;
                ZeroExt  <= '0';
                ASrc     <= AS_NONE;
                BSrc     <= AS_NONE;
                ALUop    <= OP_NONE;
                MemRead  <= '0';
                MemWE    <= '0';
                RegWE    <= '1';
                DstReg   <= Dst_NONE;
				ASrc4    <= Dst_NONE;
				BSrc4    <= Dst_NONE;
				PCMuxSel <= PC_Add1;
            WHEN others =>
            
        END CASE;
    END PROCESS;


END ARCHITECTURE;
