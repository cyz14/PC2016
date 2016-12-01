onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label if_PCtoIM -radix hexadecimal /testbench/u_cpu/if_PCToIM
add wave -noupdate -label if_Inst -radix hexadecimal /testbench/u_cpu/if_Inst
add wave -noupdate -label id_Inst -radix hexadecimal /testbench/u_cpu/id_Inst
add wave -noupdate -label ctrl_ImmeSrc -radix hexadecimal /testbench/u_cpu/ctrl_ImmeSrc
add wave -noupdate -label ext_Imme -radix hexadecimal /testbench/u_cpu/ext_Imme
add wave -noupdate -label Condition -radix hexadecimal /testbench/u_cpu/u_CtrlUnit/Condition
add wave -noupdate -label hzd_Asrc4 /testbench/u_cpu/u_HazardDetectingUnit/ASrc4
add wave -noupdate -label hzd_BSrc4 /testbench/u_cpu/u_HazardDetectingUnit/BSrc4
add wave -noupdate -label ForwardA /testbench/u_cpu/u_ForwardUnit/FORWARDA
add wave -noupdate -label ForwardB /testbench/u_cpu/u_ForwardUnit/FORWARDB
add wave -noupdate -label DM_DstVal -radix hexadecimal /testbench/u_cpu/u_DataMemory/DstVal
add wave -noupdate -label exe_DstReg -radix hexadecimal /testbench/u_cpu/u_ForwardUnit/EXE_DstReg
add wave -noupdate -label mem_DstReg /testbench/u_cpu/mem_DstReg
add wave -noupdate -label alu_A -radix hexadecimal /testbench/u_cpu/u_ALU/A
add wave -noupdate -label alu_B -radix hexadecimal /testbench/u_cpu/u_ALU/B
add wave -noupdate -label alu_F -radix hexadecimal /testbench/u_cpu/alu_F
add wave -noupdate -label ctrl_PCMuxSel -radix hexadecimal /testbench/u_cpu/ctrl_PCMuxSel
add wave -noupdate -radix hexadecimal /testbench/clk
add wave -noupdate -label mem_MemWE /testbench/u_cpu/mem_MemWE
add wave -noupdate -label ctrl_ASrc4 -radix hexadecimal /testbench/u_cpu/ctrl_ASrc4
add wave -noupdate -label ctrl_BSrc4 -radix hexadecimal /testbench/u_cpu/ctrl_BSrc4
add wave -noupdate -label ram1en /testbench/Ram1_en
add wave -noupdate -label ram1oe /testbench/Ram1_oe
add wave -noupdate -label ram1we /testbench/Ram1_we
add wave -noupdate -label rdn /testbench/u_cpu/u_DataMemory/rdn
add wave -noupdate -label wrn /testbench/u_cpu/u_DataMemory/wrn
add wave -noupdate -label PCplus1 -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCAdd1_data
add wave -noupdate -label PCRx -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCRx_data
add wave -noupdate -label PCPlusImme -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCAddImm_data
add wave -noupdate -label regFileData1 -radix hexadecimal /testbench/u_cpu/rf_Data1
add wave -noupdate -label regFileData2 -radix hexadecimal /testbench/u_cpu/rf_Data2
add wave -noupdate -label memWriteData -radix hexadecimal /testbench/u_cpu/u_Mux_Write_Data/WriteData
add wave -noupdate -radix hexadecimal /testbench/rst
add wave -noupdate -label ForwardA -radix hexadecimal /testbench/u_cpu/u_ForwardUnit/FORWARDA
add wave -noupdate -label mem_DstVal -radix hexadecimal /testbench/u_cpu/mem_DstVal
add wave -noupdate -label exe_ALUop -radix hexadecimal /testbench/u_cpu/exe_ALUOp
add wave -noupdate -label exe_ASrc -radix hexadecimal /testbench/u_cpu/exe_ASrc
add wave -noupdate -label exe_BSrc -radix hexadecimal /testbench/u_cpu/exe_BSrc
add wave -noupdate -label wb_RegWE -radix hexadecimal /testbench/u_cpu/wb_RegWE
add wave -noupdate -label wb_DstValue -radix hexadecimal /testbench/u_cpu/wb_DstVal
add wave -noupdate -label wb_DstReg -radix hexadecimal /testbench/u_cpu/wb_DstReg
add wave -noupdate -label R0 -radix hexadecimal /testbench/u_cpu/u_RegFile/R0
add wave -noupdate -label R1 -radix hexadecimal /testbench/u_cpu/u_RegFile/R1
add wave -noupdate -label R2 -radix hexadecimal /testbench/u_cpu/u_RegFile/R2
add wave -noupdate -label R3 -radix hexadecimal /testbench/u_cpu/u_RegFile/R3
add wave -noupdate -label R4 -radix hexadecimal /testbench/u_cpu/u_RegFile/R4
add wave -noupdate -label R5 -radix hexadecimal /testbench/u_cpu/u_RegFile/R5
add wave -noupdate -label R6 -radix hexadecimal /testbench/u_cpu/u_RegFile/R6
add wave -noupdate -label R7 -radix hexadecimal /testbench/u_cpu/u_RegFile/R7
add wave -noupdate -label SP -radix hexadecimal /testbench/u_cpu/u_RegFile/SP
add wave -noupdate -label T -radix hexadecimal /testbench/u_cpu/u_RegFile/T
add wave -noupdate -label IH -radix hexadecimal /testbench/u_cpu/u_RegFile/IH
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 126
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2116 ps}
