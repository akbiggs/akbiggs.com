CSC372 Lecture 6
====================

Subroutine Register Overview
------------------------------

r2 - r3: subroutine return(caller-save)
r4 - r7: subroutine args(caller-save)

They stay around via the stack, i.e. if we call a subroutine within a subroutine
they get pushed to the stack and we can retrieve them.

Caller responsibilities:

- If r8-r15 contain live values, then save them at the call site.
- Make the call("call funcName")
- On return, restore r8-r15

Subroutine conventions:

- If a separate file wants to use this function, do

```
.global funcName

funcName:
	addi sp,sp,-32 	# adjust sp
	stw ra,20(sp)  	# save ra if this subroutine calls another
					# save r16-r23 is used
					# initialize variables if any
```

Example: BST Search
-----------------------

(10
  (5 () 8)
  (20 15 30))

so we have some code like this:

```
struct Node {
	int key;
	struct Node* left, right;
}
```

In ASM:

```
.equ NULL,0 				# all occurences of NULL replaced with 0
.include "nios_macros.s"
.section .data

root: .word 10,L1,R1 		# L1 is addr of left child, R1 is addr of right child 
L1: .word 5,NULL,R21
R21: .word 8,NULL,NULL
R1: .word 20,L22,R22
L22: .word 15,NULL,NULL
R22: .word 30,NULL,NULL

.section .text
.global main

main:
	movia r4,root			# set up first argument for subroutine we're going to
							# invoke
	movia r5,30
	call search 			# will set up r2 to be a boolean if it was found
	beq r2,zero,offLED		# turn off LED if not found ("zero" is alias for r0)
	call on
	br stop
offLED:
	call off
stop:
	br stop
	.end
```

C code for search:

```
int search(struct Node *ptr, int v) {
	while (ptr) {
		if (ptr->key == value)
			return 1;
		if (ptr->key > value)
			ptr = ptr->left;
		else
			ptr = ptr->right;
	}
	return 0;
}
```

ASM:

```
search:
	addi sp,sp,-4
	stw r16,0(sp)		# save the value that's currently in r16 on top of stack,
						# so we don't wreck anyone else's work
while:
	beq r4,r0,notFound	# when the pointer is NULL, go to end
	ldw r16,(r4)		# grab our value
	beq r16,r5,found 	# r5 contains the value we're looking for
	bgt r16,r5,goLeft
						# going right now, since neither found nor going left
	ldw r4,8(r4)		# right is two words into struct, so 8 bytes of offset
	br while
goLeft:
	ldw r4,4(r4) 		# left is one word into struct, so 4 bytes of offset
	br while
found:
	addi r2,zero,1
	br end
notFound:
	movi r2,0			# might be less efficient than addi since I guess it gets
						# disassembled into an addi
end:
	ldw r16,(sp)		# take the old value of r16 off the top of the stack
	addi sp,sp,4 		# set stack pointer back to the original top of the stack
	ret
```

Prime Example
----------------

C code:

```
int isPrime(int n)
{
	int i;

	if (n == 1)
		return 1;

	for (i = 2; i < n; i++)
		if (modI(n, i) == 0)
		 	return 0;

	return 1;
}
```

ASM:

```
isPrime:
	# save registers
	addi sp,sp,(-12) # want to save three things
	stw ra,8(sp)
	stw r16,4(sp)
	stw r17,0(sp)

	mov r16,r4 		# keep copy of n in r16
	movi r2,1
	beq r16,r2,done # check if n == 1, we're done if so

	movi r17,2 		# i = 2

loop:
	bge r17,r16,done 	# loop is finished when i >= n
	mov r4,r16
	mov r5,r17 		 	# set up our two args for modI
	call modI
	beq r2,zero,done	# no need to change return register value to be zero
						# before we branch to the done address,
						# since it's already set to zero from modI's return
						# value
	addi r17,r17,1 		# i++

done:
	# restore registers
	ldw ra,8(sp)
	ldw r16,4(sp)
	ldw r17,0(sp)
	addi sp,sp,12

	ret

modI:
	bltu r4,r5,donemod
	sub r4,r4,r5
	br modI

donemod:
	mov r2,r4
	ret
```

More Hardware
===============

Recall that the processor connects to the memory through the bus, which transfers
things around. Memory from 0 to 0x007FFFFFF on the NIOS is used just for the
instructions and data of programs. LEDR(memory-mapped I/O) starts at 0x10000000,
LEDG starts at 0x10000010. Then there's a seven segment display in memory-mapped
I/O, HEX 3-0 at 0x10000020, HEX 7-4 at 0x10000030. JTAG-UART(used for terminal
communication) is at 0x10001000. R5232 UART is at 0x10001010. Then there's a timer
at 0x10002000.

We also have pins, used for general-purpose I/O, or GPIO. JP1 is at 0x10000060,
JP2 is at 0x10000070, and there's about 12 other pins(need to look up the NIOS
specs to find out how many pins there are).

Two methods for communicating with devices, detecting when their values have
changed. One is **polling**, the other is **interrupt**. They have individual
pros and cons.

Polling
------------

The timer allows you to measure real-time as a number of clock cycles (50 MHZ on
the NIOS).

We have 6 words of space in the timer.

0x10002000 	bit 0 is timeout, bit 1 is run, bits 2 and 3 are reserved, rest empty
0x10002004 	bit 0 is interrupt timeout, bit 1 is cont, bit 2 is start, bit 3 is
			stop, rest is unused
0x10002008  counter start value (16 LOW-order bits)
0x1000200C	counter stop value (16 HIGH-order bits)
0x10002010  counter snapshot (LOW)
0x10002014  counter snapshot (HIGH)

*timeout*: set to 1 by timer. If timer reached zero can be reset by user.

*run*: timer sets to 1 when running

*start/stop*: timer can be used as a stopwatch. set them to 1 to start/stop

*cont*: when reached zero automatically reloads specified starting count
value. if cont = 1, repeats, otherwise stops.

Say we want to put 5 seconds into the timer, with a 50 MHZ clock. 
cycles = (5)(50)(10^6) = 250(10^6) cycles = (in hex) 0x0EE6 (high) B280 (low)

```
.equ TIMER, 0x10002000
.equ time, 0x0EE6B280
movia r8,TIMER
movui r9,%lo(time) 
stwio r9,8(r8) # put low bits into 0x10002008
movui r9,%hi(time)
stwio r9,12(r8) # put high bits into 0x10002012
stwio r0,(r8) # reset timer
movi r0,0b100 # start <- 1
stwio r9,4(r8)

poll:
	ldwio r9,(r8)
	andi r9,r9,0b1 # check if start is 1
	beq r9,r0, Poll # keep checking until it is
```

How does the snapshot work?

```
movia r8,TIMER 		# set things up to read current timer value
stwio r0,16(r8)
ldwio r9,16(r8)		# read counter LOW
ldwio r10,20(r8)	# read counter HIGH
slli r10,r10,16 	# in order to put the snapshot value together into a 32-bit
					# number, we're going to shift it left into the 31-16 bits
or r10,r10,r9 		# now the value is together
```