.ORIG x3000

LD R1, q_ascii
NOT R1, R1
ADD R1, R1, #1

LEA R0, message
PUTS

main GETC
OUT
ADD R2, R0, R1
BRnp main

AND R0, R0, #0
ADD R0, R0, x0A
OUT

LEA R0, quit
PUTS

HALT
q_ascii .FILL x0071
message .STRINGZ "Enter character 'q' to quit\n"
quit .STRINGZ "Exited echo loop\n"


.END