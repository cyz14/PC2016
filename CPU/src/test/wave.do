onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label if_PCtoIM /testbench/u_cpu/if_PCToIM
add wave -noupdate -label if_Inst /testbench/u_cpu/if_Inst
add wave -noupdate -label ctrl_ImmeSrc /testbench/u_cpu/ctrl_ImmeSrc
add wave -noupdate -label ext_Imme /testbench/u_cpu/ext_Imme
add wave -noupdate -label Condition /testbench/u_cpu/u_CtrlUnit/Condition
add wave -noupdate -label ctrl_PCMuxSel /testbench/u_cpu/ctrl_PCMuxSel
add wave -noupdate -label ctrl_ASrc4 /testbench/u_cpu/ctrl_ASrc4
add wave -noupdate -label ctrl_BSrc4 /testbench/u_cpu/ctrl_BSrc4
add wave -noupdate -label exe_DstReg /testbench/u_cpu/u_ForwardUnit/EXE_DstReg
add wave -noupdate -label mem_DstReg /testbench/u_cpu/u_ForwardUnit/MEM_DstReg
add wave -noupdate -label regFileData1 /testbench/u_cpu/rf_Data1
add wave -noupdate -label regFileData2 /testbench/u_cpu/rf_Data2
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate -label ForwardA /testbench/u_cpu/u_ForwardUnit/FORWARDA
add wave -noupdate -label exe_ALUop /testbench/u_cpu/exe_ALUOp
add wave -noupdate -label alu_A /testbench/u_cpu/u_ALU/A
add wave -noupdate -label alu_B /testbench/u_cpu/u_ALU/B
add wave -noupdate -label alu_F /testbench/u_cpu/alu_F
add wave -noupdate -label exe_ASrc /testbench/u_cpu/exe_ASrc
add wave -noupdate -label exe_BSrc /testbench/u_cpu/exe_BSrc
add wave -noupdate -label wb_RegWE /testbench/u_cpu/wb_RegWE
add wave -noupdate -label wb_DstValue /testbench/u_cpu/wb_DstVal
add wave -noupdate -label wb_DstReg /testbench/u_cpu/wb_DstReg
add wave -noupdate -label R0 /testbench/u_cpu/u_RegFile/R0
add wave -noupdate -label R1 /testbench/u_cpu/u_RegFile/R1
add wave -noupdate -label R2 /testbench/u_cpu/u_RegFile/R2
add wave -noupdate -label R3 /testbench/u_cpu/u_RegFile/R3
add wave -noupdate -label R4 /testbench/u_cpu/u_RegFile/R4
add wave -noupdate -label R5 /testbench/u_cpu/u_RegFile/R5
add wave -noupdate -label R6 /testbench/u_cpu/u_RegFile/R6
add wave -noupdate -label R7 /testbench/u_cpu/u_RegFile/R7
add wave -noupdate -label SP /testbench/u_cpu/u_RegFile/SP
add wave -noupdate -label T /testbench/u_cpu/u_RegFile/T
add wave -noupdate -label IH /testbench/u_cpu/u_RegFile/IH
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 195
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
WaveRestoreZoom {203 ps} {1134 ps}
