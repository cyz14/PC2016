onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label if_PCtoIM -radix hexadecimal /testbench/u_cpu/if_PCToIM
add wave -noupdate -label if_Inst -radix hexadecimal /testbench/u_cpu/if_Inst
add wave -noupdate -label ctrl_ImmeSrc -radix hexadecimal /testbench/u_cpu/ctrl_ImmeSrc
add wave -noupdate -label ext_Imme -radix hexadecimal /testbench/u_cpu/ext_Imme
add wave -noupdate -label Condition -radix hexadecimal /testbench/u_cpu/u_CtrlUnit/Condition
add wave -noupdate -label ctrl_PCMuxSel -radix hexadecimal /testbench/u_cpu/ctrl_PCMuxSel
add wave -noupdate -label PCplus1 -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCAdd1_data
add wave -noupdate -label PCRx -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCRx_data
add wave -noupdate -label PCPlusImme -radix hexadecimal /testbench/u_cpu/u_PCMUX/PCAddImm_data
add wave -noupdate -label ctrl_ASrc4 -radix hexadecimal /testbench/u_cpu/ctrl_ASrc4
add wave -noupdate -label ctrl_BSrc4 -radix hexadecimal /testbench/u_cpu/ctrl_BSrc4
add wave -noupdate -label exe_DstReg -radix hexadecimal /testbench/u_cpu/u_ForwardUnit/EXE_DstReg
add wave -noupdate -label mem_DstReg -radix hexadecimal /testbench/u_cpu/u_ForwardUnit/MEM_DstReg
add wave -noupdate -label regFileData1 -radix hexadecimal /testbench/u_cpu/rf_Data1
add wave -noupdate -label regFileData2 -radix hexadecimal /testbench/u_cpu/rf_Data2
add wave -noupdate -radix hexadecimal /testbench/clk
add wave -noupdate -radix hexadecimal /testbench/rst
add wave -noupdate -label ForwardA -radix hexadecimal /testbench/u_cpu/u_ForwardUnit/FORWARDA
add wave -noupdate -label exe_ALUop -radix hexadecimal /testbench/u_cpu/exe_ALUOp
add wave -noupdate -label alu_A -radix hexadecimal /testbench/u_cpu/u_ALU/A
add wave -noupdate -label alu_B -radix hexadecimal /testbench/u_cpu/u_ALU/B
add wave -noupdate -label alu_F -radix hexadecimal /testbench/u_cpu/alu_F
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
WaveRestoreCursors {{Cursor 1} {600 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {1037 ps}
