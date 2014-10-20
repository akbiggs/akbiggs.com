.include "nios_macros.s"
.section text

.equ JP1 0x10000060

.global main
main:
	movia r8,JP1

reactToSensors:

readSensor:
	addi sp,sp,-4
	stw r16,(sp)

	

	ldw r16,(sp)
	addi sp,sp,4
	ret