CSC372 Lecture 5
==================

Subroutine(AKA functions/methods/procedures)
---------------------------------------------

We have a instruction called "call", which takes
a label of the address where the function instructions
begin. We also have an instruction called "ret", which
indicates the end of a function.

So "call" invokes a subroutine(callee) by using 
"call Imm26", where Imm26 is an immediate 26-bit
value. On NIOS, sets r31(also known as ra) to the next instruction
after the call(PC+4), and sets PC to Imm26. Since
PC requires a 32-bit number, it sets the first four
bits of PC to the first four major bits, assuming
that the other functions of the program will be around
the point of invocation, then the next 26 to Imm26,
then 00 for the last two bits to ensure that the memory
address is aligned by four.

Then the callee returns to the caller using "ret".
Sets PC to ra.

There are a few problems conceptually with this:

1. How do we pass arguments?
2. How do we deal with calling a function within a function
(need to save the ra somewhere)?

Example(related to Lab #2)
---------------------------

```
.section .text
.equ LEDR 0x10000000
.global main

main:
	movia r8,LEDR
repeat:
	call off
	call delay
	call on
	call delay
	bru repeat
	end

off:
	movi r9, 0 		// but what if r9 is in use?
	stwio, r9, (r8)
	ret
```

Our off routine won't work, since we'd be overwriting
registers that might be in use in other places. So we
need to find a way to save our register values when we
start calling the function and set them back when the function
returns.

Stack (LIFO)
-------------

Requires a pointer to keep track of the top of the stack called the stack
pointer (sp). On NIOS II, sp is r27.

Recall the memory layout:

Instructions

|

Data (grows down)

|

Dynamic memory allocated

|

Stack (sp on top) (grows up, so decreasing addresses)

**Push operation**: push the content of a register on to the stack, and
sets the stack pointer to be the beginning of that memory
that just got pushed on.

```
subi sp, sp, 4 // move the stack pointer up one word
stw r9, (sp)
```

**Pop operation**: Get the first thing on top of the stack.

```
ldw r10, (sp)
addi sp, sp, 4
```

Passing Arguments
---------------------

Exchange of info between caller and callee is established:

1. by value(send the data itself)
2. by reference(send the address of the memory location of the data)

We have different means of accomplishing the actual parameter passing,
as well:

1. Registers
2. Fixed memory location
3. Stack

We use the stack because it's flexible and is being recycled.

We have two ways of saving the info: caller-save and callee-save.
The former delegates the responsibility of saving the info to
the function that is invoking the subroutine, while the
latter delegates to the subroutine being invoked.

e.g. main calls foo. caller-save makes main do the work, callee-save
makes foo do the work.

Register usage in the NIOS 2:

**r2 - r3**: Subroutine return value (caller-save)

**r4 - r7**: Subrotuine arguments (caller-save)

**r8 - r15**: General use (caller-save)

**r16 - r23**: General use (callee-save)

**r27(sp)**: stack pointer

**r31 (ra)**: return address