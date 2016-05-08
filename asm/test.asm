.ORIG x3000
AND R0, R0, #0
LD R1, a
LD R2, b
main 
	ADD R0, R0, R1
	ADD R2, R2, #-1
BRp main
ST R0, data
ADD R0, R0, R0
LD R1, data

HALT
a .FILL #8
b .FILL #7
data .BLKW #1
.END