# CPU
THCO MIPS 

## ToDO 11-17
ALU给出运算的所有结果标志位
T ,Z , 

设计完CPU：
1. 检查数据通路，
2. 解决冲突，数据，结构，控制冲突
3. 仿真测试 MEM 阶段时间，确定CPU大致频率 

PC 是否移位？否。SRAM的读写是根据地址读16bit。SRAM大小为 256*1024*16b。


## Basic Instructions	
|Number|Instruction 
|:-----|-----------
|1     |ADDIU 
|2     |ADDIU3
|3     |ADDSP
|4     |ADDU
|5     |AND
|6     |B
|7     |BEQZ
|8     |BNEZ
|9     |BTEQZ
|10    |CMP
|11    |JR
|12    |LI
|13    |LW
|14    |LW_SP
|15    |MFIH
|16    |MFPC
|17    |MTIH
|18    |MTSP
|19    |NOP
|20    |OR
|21    |SLL
|22    |SRA
|23    |SUBU
|24    |SW
|25    |SW_SP

## Extended Instructions
|组号| 指令1 | 指令2 | 指令3 | 指令4 | 指令5
|:---|------|-------|-------|------|-----
|108 |SLLV|SRLV|BTNEZ|MOVE|SLTI

## Instruction Classification
### Type R
|Instruction | OP    | rx | ry | rz |func|Function
|:-----------|-------|--- |----|----|----|---------
|ADDU        | 11100 | rx | ry | rz | 01 | R[z] <- R[x] + R[y]
|SUBU        | 11100 | rx | ry | rz | 11 | R[z] <- R[x] - R[y]
|AND         | 11101 | rx | ry | 011| 00 | R[x] <- R[x] & R[y]
|OR          | 11101 | rx | ry | 011| 01 | R[x] <- R[y] \| R[x]
|SLLV        | 11101 | rx | ry | 001| 00 | ry   <- ry << rx
|SRLV        | 11101 | rx | ry | 001| 10 | ry   <- ry >> rx
|CMP         | 11101 | rx | ry | 010| 10 | R[x] = R[y] ? T <- 0 : T <- 1 
|MOVE        | 01111 | rx | ry | 000| 00 | rx   <- ry
|MFIH        | 11110 | rx | 000| 000| 00 | R[x] <- IH
|MFPC        | 11101 | rx | 010| 000| 00 | R[x] <- PC
|MTIH        | 11110 | rx | 000| 000| 01 | IH   <- R[x]
|MTSP        | 01100 | 100| rx | 000| 00 | SP   <- R[x]
|SLL         | 00110 | rx | ry | imm| 00 | imm = 0 ? R[x] <- R[y] << 8 : R[x] <- R[y] << imm(unsign)
|SRA         | 00110 | rx | ry | imm| 11 | imm = 0 ? R[x] <- R[y] >> 8 : R[x] <- R[y] >> imm(arith)
### Type I
|Instruction | OP    | rx | ry | imm         | Function
|:-----------|-------|----|----|-------------|---------
|ADDIU       | 01001 | rx | imm|             | R[X] <- R[X]+si(imm)
|ADDIU3      | 01000 | rx | ry |'0' & imm(4) | R[y] <- R[x]+si(imm)
|ADDSP       | 01100 |011 | imm|             | SP <- SP + si(imm)
|LI          | 01101 | rx | imm|             | R[x] <- ze(imm)
|LW          | 10011 | rx | ry | imm(5)      | R[y] <- MEN[R[x] + si(imm)]
|LW_SP       | 10010 | rx | imm|             | R[x] <- MEM[SP +si(imm)]
|SW          | 11011 | rx | ry | imm(5)      | MEM[R[x] + Si(imm)] ← R[y]
|SW_SP       | 11010 | rx | imm|             | MEM[SP + Si(imm)] ← R[x]
|SLTI        | 01010 | rx | imm|             | R[x]<sign_extend(imme) ? T=1:T=0

### Type J
|Instruction| OP     | rx | imm | Function |
|:----------|--------|----|-----|---------
|B          | 00010  |imm |     | PC <- PC +si(imm)
|BEQZ       | 00100  |rx  | imm | if(R[x] = 0) then PC<-PC+si(imm)
|BNEZ       | 00101  |rx  | imm | if(R[x] != 0) then PC<-PC+si(imm)
|BTEQZ      | 01100  |000 | imm | if(T=0) then PC <-PC+si(imm)
|JR         | 11101  |rx  |     | PC <- R[x]
|BTNEZ      | 01100  |001 | imm | T != 0 ? PC <- PC +si(imm)
|NOP        | NOP    |    |     | 
