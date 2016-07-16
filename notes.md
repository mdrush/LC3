Modifications
1. An additional condition code has been added (carry flag). It is not an overflow flag, 
so it will not determine if the sign of the result is different than it should be.

2. Opcodes MOVt and MOV have been added. There is no longer an illegal opcode.
	|opcode|dr|flag|imm8|
	flag=1 specifies a MOVt whereas flag=0 specifies a MOV

	if (IR[8])
		(DR) <= ((DR) & 0xFF) | (imm8 << 8)
	else
		(DR) <= ZEXT(imm8)



[Helpful explanation of control logic](https://www.cs.utexas.edu/~fussell/courses/cs310h-spring2010/lectures/control_logic_notes.txt)

http://people.cs.georgetown.edu/~squier/Teaching/HardwareFundamentals/LC3-trunk/docs/LC3-uArch-ControlStates.txt
