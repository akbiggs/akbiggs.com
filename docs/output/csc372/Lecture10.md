 CSC372 Lecture 10
=====================

Recall that an interrupt is better for handling medium to longer wait times,
while polling is better for short wait times.

During an interrupt, the return address is stored in r29, aliased ea. When
you go back, you need to subtract 4 from the ea before returning if you want
to execute the instruction you were doing when the interrupt occurred.

When a device wants to interrupt, it flags on one of irq0-irg31.

If you want to handle a reset interrupt, here's what you do:

```
.section .reset, "ax"
movia r2,_start # move our start function into a register
jmp r2 # go there

.section .text # important to specify or else your code could go
outside of the boundaries it's supposed to, screws things up.
... # _start happens somewhere here
```

In order for an interrupt to occur, when irqX is set, bit X in the
ienable control register also needs to be set. Does "and" with bit
and irqX.

Multiple Interrupts
---------------------

Allows ISR to interrupt itself. Suppose that we're allowing two
interrupts:
	irq0 => Timer <- Higher Priority
	irq11 => JP1

```
.section .exception, "ax"
.global ISR

ISR:
	subi sp,sp,12
	stw et,(sp) # exception temporary register. Alias for r29
	rdctl et,estatus # in case interrupt occurs during interrupt, read and save
	stw et,4(sp)
	stw ea,8(sp)

#irq0 has higher priority

	rdctl et,ipending # see who's interrupting us
	andi et,et,0x1
	beq et,zoer,IRQ11 # where's our interrupt coming from?
	call serve_irq0

# acknowledge interrupt

	movia et,TIMER
	stwio zero,(et)
	br exit

irq11:
	# has lower priority
	rdctl et,iPending
	andi et,et,0x0800
	beq et,zero,IRQ # if no one interrupted you, you can exit here instead

	# since irq11 has lower priority, allow interrupts
	movi et,0x01
	wrctl status,et # PIE <- 1
	call server_irq11
	br exit

	... # could have other interrupts set up here

exit:
	wrctl status,zero # disable interrupts, PIE <- 0
					  # we don't want anyone to interrupt us right now
	ldw et,4(sp)
	wrctl estatus,et
	ldw et,8(sp)
	mov ea,et
	ldw et,(sp)
	addi sp,sp,12
	subi ea,ea,4
	eret 				# automatically sets PIE <- 1, allowing interrupts again
```

0b...1010 & 0b1111...1101 = 0b...1000


Pushbutton Parallel Port
--------------------------

four registers, starting at 0x10000050:
	1. readonly data: 31 - 4 unused, 3 - 1 keys 3 through 1, 0 reset
	2. unused
	3. interrupt mask: 31 - 4 unused, 3 - 1 mask bits, 0 reset
	4. edge capture: 31 - 4 unused, 3 - 1 edge bits, 0 reset

Interrupt mask register allows you to enable interrupts.

Edge capture is set to 1 if a key is pressed, can check to find out which key was
pressed.

```
main: # TIMER initialization
	movia r8, TIMER
	movui r9,%lo(time)
	stwio r9,8(r8)
	movui r9,%hi(time)
	stwio r9,12(r8)
	stwio zero,(r8) # reset timer

	# initialize push buttons
	movia r15, 0x10000050
	movi r9,0b01110 # allow interrupts for all keys
	stwio r9,8(r15)

	# enable device interrupts for irq0, irq1
	movi r9,0b011 # extra zero is there to make sure it doesn't get extended
	wrctl ienable,r9 # enable interrupts from timer and pushbutton

	# enable external interrupts
	movi r9,0b01
	wrctl status,r9 # everybody can now interrupt

	# start timer
	movui r9,0b111 # flag on start, Cont, and iTO

IDLE:
	br IDLE
	.end
```

Interrupt Priority
--------------------

If you want some interrupts to take higher priority compared to other interrupts,
switch the order in which you check the interrupts when serving them. The order
of your code is important.

LCD (Liquid Crystal Display)
------------------------------

The LCDs are a 40x2 character memory.

There are 40 bytes for the LCDs. The first 16 are visible, the last 24 are invisible.
The two rows handle storing the y-pos of each character, while the visible byte
columns are for storing the x position of each character. You store the first
character of the string to write in the last visible byte.

LCD Post Register
-------------------

Address 0x10003050:
	instruction byte: allows controlling LCDs
	data byte: stores ascii code for the data to display.

```
.equ LCD,0x10003050
movia r8,LCD
pvio r18,0x80
stbio,r18,(r8) # write 1000 0000 into inst for LCD 0, setting char to display 
			   # in corner

# clear display
movui r18,0x01
stbio r18,(r8)
movui r19.'U' # alternatively ASCII code, movui r19,55
stbio r19,1(r8) # store the character U into the data for LCD 0
```

Displaying the string "University":

```
University: .byte 'U', 'n', 'i', ..., '0' # terminal character

# alternatively
University: .asciz "University" # terminates with 0 automatically

# a second alternative
University: .ascii "University" # no 0 termination

# can use the zero in a loop to read through string
_start:
	movia r8,LCD
	movui r18,0x80 # cursor address: (00)Hex
	stbio r18,(r8)

	# set ptr
	movia r9,University

	# read first char
	ldbu r19,(r9)

loop:
	beq r19,zero,endloop # branch when we read the zero terminator

	# write char to LCD
	stbio r19,1(r8)
	addi r9,r9,1 # advance my pointer
	ldbu r19,(r9)
	br loop

endLoop:
	br endLoop
	stop
```
