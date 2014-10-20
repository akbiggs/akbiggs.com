CSC372 Lecture 8
====================

When you're approaching your design, don't put everything together at once.
Do little tests on small amounts of functionality.

Pulse-width modulation
------------------------

The **switching frequency** is the rate at which we turn things off and then
on again to conserve energy. Pulse-width modulation involves changing our wave
indicating when our circuit is on and off based on reducing the switching frequency
and changing the amount of voltage being applied.

The period of our program is 1 / frequency. The Duty cycle (D) = on time / period
* 100%. 0% <= D <= 100%.

Example
---------

Let r4 be the cycle time, passed by the caller.

```
.equ TIMER,0x10002000
pwm: movia r23,TIMER
stwia r4,8(r23)
stwio zero,12(r23)
stwio zero,(r23)
movi r24, 0b0100
stwio r24,4(r23)

PollPWM:
	ldwio r24,(r23)
	andi r24,r24,1
	beq r24,zero,PollPWM
```

On a time out, we want to turn the motor off now.

New instruction, shift left/right logical immediate

```slli rC,rA, Imm5```: ```rC <- rA << Imm5```

5 due to 5 bits needed to represent 32, the size of a word in bits.

for example, slli r8,r9,3 shifts r9 three bits to the left and stores it in r8.

Another instruction, shift left/right arithmetic:

```sra rC,rA,rB: rC <- (aligned rA) >> (rB4,,0)```

In other words, fill the empty space created by the right shift with 0s.

Transmitting Information Over Serial Interfaces
------------------------------------------------

Serial interfaces transfer data one bit at a time, whereas Parallel interfaces
transfer a collection of bits at a time. Serial interfaces employ one line,
whereas Parallel employs a collection of lines. Serial interfaces are cheap,
while parallel ones are more expensive.

JTAG UART
------------

The JTAG UART acts as a connection between the USB Blaster interface of the host
PC and the NIOS 2 and its bus interface. Implemented over the JTAG interface on DE2
board and USB on the host PC. Can be used to transfer control to the terminal window
on the Altera monitor program.

The layout of the JTAG UART is two registers -- one at 0x10001000 for the data
register, another at 0x10001004 for the control register.

In the data register, bits 31 - 16 represents the number of characters available to
read, bit 15 represents whether reading is valid from data section, bits 14 - 8 are
unused, and bits 7 - 0 are data.

In the control register, bits 31 - 16 are for white space, bits 15 - 11 are unused,
bits 9 and 8 are used to indicate Write interrupts and Read interrupts, and bits 1
and 0 are used to enable/disable Write interrupts and Read interrupts.

Working With JTAG
-------------------

Workflow is check if data is ready. If it is, load the data, otherwise loop.

```
.equ JTAG, 0x10001000
movia r8,JTAG

Poll: 
	ldwio r9,(r8)
	andi r10,r9,0x8000 	# extract the valid bit
	beq r10,zero,Poll
	andi r9,r9,0xFF		# extract data
```

Factorial Function
---------------------

C Code:

```
int fact(int n)
{
	if (n == 0)
		return 1;

	return (n * fact(n-1));
}
```

ASM:

```
.section .text
.global main

main:
	movi r4,3
	call fact
stop: 
	br stop
	.end

.global fact
fact:
	addi sp,sp,-4
	stw ra,(sp)  			# need to save return address (could go after beq)

	beq r4,zero,return1  	# return 1 if n == 0
	
	addi sp,sp,-4 			# push old value of n on stack so we don't lose it
	stw r4,(sp)

	addi r4,r4,-1 			# call recursively with n - 1
	call fact

	ldw r4,(sp)  			# load our argument for n back on to register
	addi sp,sp,4

	mul r2,r4,r2 			# set return value to be the recursive result * n
	br end

return1:
	movi r2,1

end:
	ldw ra,(sp) 			
	addi sp,sp,4
	ret
```

Another Function Call Example
------------------------------

Compute ```f(f(3,4), -2)``` where ```f(a, b) = a^2 - b```

```
.include "nios_macros.s"
.section .text
.global main
main:
	movi r4,3
	movi r5,4
	call math
	mov r4,r2
	movi r5, -2
	call math

stop:
	br stop
	.end

.section .text
.global main
math:
	mul r2,r4,r4
	sub r2,r2,r5
	ret
```

Function Call With Lots Of Arguments Example
----------------------------------------------

C function definition:

```
if (a < b)
	y = c + d + e
else y = c - d - e;

y = f(a,b,c,d,e)
```

ASM:

```
main:
	movi r4,4
	movi r5,5
	movi r6,6
	movi r7,7 	# now we've run out of registers. need to push our fifth arg onto
				# the stack

	movi r8,8
	addi sp,sp,-4
	stw r8,(sp)

	call add

	addi sp,sp,4 	# clean up the stack pointer, REMEMBER THIS
stop:
	br stop
	.end

add:
	addi sp,sp,-8
	stw r16,(sp)
	stw r17,4(sp)

	ldw r16,8(sp) 	# load the value of our fifth argument, which was at the top
					# of the stack when we branched here, now 8 bytes away

	# if (a < b)
	cmplt r17,r4,r5	# alternative approach to doing blt
	beq r17,zoer,then
else:
	sub r2,r6,r7 	# c - d
	sub r2,r2,r16 	# c - d - e
	br end
then:
	add r2,r6,r7 	# c + d
	add r2,r2,r16 	# c + d + e
end:
	ldw r16,(sp)
	ldw r17,4(sp)
	addi sp,sp,8
	ret
```