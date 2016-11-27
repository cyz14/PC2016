add wave -position end  sim:/testbench/clk
add wave -position end  sim:/testbench/rst
add wave -position end  sim:/testbench/u_cpu/if_PCToIM
add wave -position end  sim:/testbench/u_cpu/if_PCPlus1
add wave -position end  sim:/testbench/u_cpu/if_Inst
add wave -position end  sim:/testbench/u_cpu/u_CtrlUnit/Instruction
add wave -position end  sim:/testbench/u_cpu/ctrl_ImmeSrc
add wave -position end  sim:/testbench/u_cpu/ext_Imme
add wave -position end  sim:/testbench/u_cpu/ctrl_PCMuxSel
add wave -position insertpoint  \
sim:/testbench/u_cpu/ctrl_ALUOp \
sim:/testbench/u_cpu/ctrl_ASrc \
sim:/testbench/u_cpu/ctrl_BSrc \
sim:/testbench/u_cpu/ctrl_MemRead \
sim:/testbench/u_cpu/ctrl_MemWE \
sim:/testbench/u_cpu/ctrl_DstReg \
sim:/testbench/u_cpu/ctrl_RegWE \
sim:/testbench/u_cpu/ctrl_ASrc4 \
sim:/testbench/u_cpu/ctrl_BSrc4
add wave -position end  sim:/testbench/u_cpu/rf_Data1
add wave -position end  sim:/testbench/u_cpu/rf_Data2
add wave -position end  sim:/testbench/u_cpu/u_CtrlUnit/ALUop
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R1
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R2
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R3
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R4
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R5
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R6
add wave -position end  sim:/testbench/u_cpu/u_RegFile/R7
