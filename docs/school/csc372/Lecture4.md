CSC372 Lecture 4
===================

Example C to ASM
------------------

B = A + 7

We need to retrieve the value at the address of A,
add seven to it, and store that value into the address
at B.

```
.section .data 		// start data section
.align 1 			// means align data to be every 2^1 = 2 bytes,
					// ensures data ends at address that is multiple of 2 bytes.
A: .hword 0x0003 	// put 3 in A
.align 2 		 	// align data to be every 4 bytes, or full word
B: .skip 4		 	// reserve four bytes for B.

.section .text 		// start instructions section
.global _start		// set _start as the main global function

_start: movi r8, 7	// move the immediate value 7 into register 8
					// now r8 = 0x0007. Note that this instruction
					// probably becomes two or three other instructions
					// in the compiled diassembly

movia r9, A 		// move the address at A into the register r9.
					// Now r9 is basically a pointer to that location.

ldh r10, 0(r9)		// loads half a word from the start of the address
					// in r9 into r10. We use half word load since we
					// only stored half a word in A to begin with.

add r11, r10, r8	// store into r11 the result of adding the data in r10
					// to the data in r8.

movia r12, B 		// point r12 to B

stw r11, (r12)		// store a word from the beginning of r12 into r11,
					// i.e. take the result of adding to 7 to the data
					// at A's address and store it into B.

.end

```

Directives
------------

Provide info to assembler. They are not instructions, and they start with
a dot.

.text: Instructions go below. Assumed by default.

.data: Data goes here.

.global: Makes symbol visible to other files, i.e. assembler makes symbol
visible to linker.

.end: Does nothing, just makes the end of the program explicit.

.equ symbol, value: equates symbol to value.

The preassembler finds directives with .equ and changes them into
proper assembly instructions.

.byte expression

.hword "

.word "

Expressions separated by comma can be specified and are assembled
to 8, 16, 32 bits respectively

.skip size: Leaves the space empty, unallocated.

.space size:  Allocates zero initialized bytes as specified in size.

.string "STRING", ...

A string of ASCII characters are loaded into consecutive byte
addresses and zero byte-terminated (null character)

.ascii is the same as .string, but does not include the zero
termination.

.include filename: Same as #include in C, takes contents of
filename(a .s file) and replaces the directive with them.

**Label**: A name given to a memory location. e.g.
arrayC: .byte 1,2,3,4 puts four bytes next to each other
with the corresponding values, and now arrayC just means
the address of the beginning of those bytes.

Branching
------------

Allows implementation of if clauses, loops.

Changes the order of execution of instructions by loading
a new value into PC. "br offset" performs a sign extension
on offset to make it a 32-bit value, then adds it to PC.
Note that the offset is added *after* the PC is changed
to point to the address of the next instruction.

For a conditional, the logic is if (Cond == TRUE), then
PC <- PC + offset, otherwise PC <- PC.

"bCC rA, rB, location", where CC is eq, ne, gt, ge, lt, or le
is equivalent to if (signed rA CC signed rB) then PC <- PC + location
otherwise PC <- PC. "bCCu" is the unsigned equivalent. Note
that it calculates the offset to the given location before adding.

Lab 1 
==========

IMPORTANT: need .include "nios_macros.s" to fix a movia bug
Toggling LEDs
--------------

```
.include "nios_macros.s"

.text
.equ LEDR, 0x10000000 // memory mapped I/O, each bit in the word following
				      // this address controls an LED, 0 meaning off, 1 meaning off
.global main

main:
	movia r8, LEDR	   // move the address for the LEDs into r8
	movi r9, 0 		   // move 0 into r9
	stwio r9, 0(r8)    // bypass buffer, zeroing out the address r8 points to
	movia r10, 1000000 // move a very large number into r10 (need to use movia due
					   // to size)
Delay1:
	subi r10, r10, 1    // keep decrementing r10
	bne r10, r0, Delay1 // keep decrementing until it hits zero
	movi r9, 1
	stwio r9, 0(r8)
	movia r10, 1000000
Delay2:
	subi r10, r10, 1
	bne r10, r0, Delay2
	movi r9, 0
	stwio r9, 0(r8)
	movia r10, 1000000
	br Delay1
```

Sum Array
-----------

C version:

```
int sum = 0;
for (i = 0; i < size; i++) {
	sum += array[i];
}
```

ASM version:

```
.include "nios_macros.s"
.align 2
.section .data
array: .word 0x2, 0x4, 0xa, 0x20
size: .word 0x4
sum: .skip 4

.section .text
.global _start

_start: 
	movia r8, size
	ldw r9, (r8) 		// we're going to use the size and decrement downwards
	movia r10, 0 		// sum = 0
	movia r11, array 	// point r11 at the start of the array

loop:
	beq r9, r0, endloop
	ldw r12, (r11)
	add r10, r10, r12 	// sum += array[i]
	addi r11, r11, 4 	// advance our pointer to the start of the array
	subi r9, r9 		// i--
	br loop   			// do it again

endloop:
	movia r8, sum 		// point r8 to the word we've left for our sum result
	stw r10, (r8)		// store our accumulated result there

stop:
	br stop				// gives you a nice way to keep looking at the results,
						// so you can debug while the program keeps executing.
						// You can also use more regular breakpoints.
	.end
```

Sum of Products
----------------

Expected: (sum from i = 0 to (N-1) of (Ai)(Bi))

```
.include "nios_macros.s"
.section .data
.align 2 // not necessary, but maybe you want to force it

N: .word 6
A: .word 5,3,-6,19,8,12
B: .word 2,14,5,-3,-5,36
Result: .skip 4

.section .text
.global _start
_start: 
	movia r12, A
	movia r13, B
	movia r14, N
	ldw r14, (r14) 		// no need for the addxress, just load the contents
	add r15, r0, r0 	// initialize r15 to zero, equivalent to movi r15, 0
Loop:
	ldw r16, (r12)		// r16 is now the first element of A, 5
	ldw r17, (r13) 		// first element of B, 2
	mul r18, r16, r17
	add r15, r15, r18

	// DON'T FORGET TO ADJUST YOUR POINTERS TO THE ARRAYS

	add r12, r12, 4
	add r13, r13, 4

	subi r14, r14, 1
	bgt r14, r0, Loop 	// since we're checking the condition at the end,
						// this is a do-while loop, and therefore we need
						// to do a greater-than as opposed to a ge
	
	movia r14, Result 	// don't need to keep the loop counter anymore
	.end
```