CSC372 Lecture 7
==================

How do we handle I/O? We have a few different ways.

1. Parallel Interface (PIT)
--------------------------

DE2 includes two Bidirectional(Input or Output) General Purpose I/O(GPIO), called
the JP1/JP2.

Both the JP1 and JP2 have two registers: the data register and the direction
register. The data register is in the lower four bytes, while the direction register
is in the upper four bytes.

If a bit in the  **direction register** is 0, the corresponding bit in the
data register is configured as input. If it's 1, then it's configured as output.

First ten bits are used in this way, then four unused pins, then another 12,
then four unused, then another 10.

Configuring:

```
.equ JP1, 0x1000 0060
movia r8,JP1
stwio r0,4(r8) # zero out the direction register, configuring as inputs

ldwio r9,0(r8) # this is how you would read the data register

movi r9,0xFFFF # sign extends to all 32 bits since signed move 
stwio r9, 4(r8) # configured for output
```

Motor Control
---------------

Our PIT can be used to handle motor control. There are five motors over ten bits,
every two bits separating a motor. The first bit is the on/off bit, the second
bit is the forward/reverse bit. Oddly enough, off is 0, and on is 1.

When we have our motors hooked up and we want to control them, we should have the
first ten bits of our direction register on JP1 or JP2 set to 1.

Motors are from bits 9 - 0.

Sensor Control
---------------

Again, we can have five sensors hooked up to the board. Each sensor has two bits:
on/off and ready. When ready is 0, it means the data is prepared, but when it is
1, the data is garbage.

We use output on the direction register for the on/off bit, to set it on or off.
We use input for the ready bit, to check whether or not the data is ready.

Sensors are from bits 19 - 10. The data from the sensor we're interested in is kept
on the 30 - 27 bits, so our direction bits are 0 for all of those.

**Note**: Best to set the direction register for 0x07F557FF. This will set/reset
all bits for motors/sensors to the appropriate values.

Usage
--------

```
.equ JP1,0x1000 0060
movia r8,JP1
movia r9,0xFFFFFFFF
stwio r9,(r8) # all motors & sensors off
movia r9,0x07F557FF
stwio r9,4(r8)

# suppose we want to turn on motor 0, to go forward
movia r9,0xFFFFFFFC # C is 1100, sets motor 0 on, sets forward bit to 1
stwio r9,(r8)

# going in reverse
movia r9,0xFFFFFFFE
stwio r9,(r8)

# let's suppose we need two sensors
movia r10,0xFFFFEFFF 	# E is 1110, configures sensor 1 on
movia r11,0xFFFFBFF 	# B is 1011, sensor 0 on
stwio r10,(r8)			# turn on sensor 1

# we need to check for when the data is ready in sensor 1.
# let's poll the bit that says when it's ready.
Poll:
	ldwio r14,(r8)
	srli r14,r14,13  	# we need to bring bit 13 to bit 0 within our register
	andi r14,r14,1 		# extract the value at bit 0
	bne r14,r0,Poll

	# sensor data is ready
	ldwio r14,(r8)
	srli r14,r14,27 	# go to the data sensor
	andi r14,r14,0x000F # extract last four bits

	# cut off for sake of time, but here's the basic workflow for lab 2:
	# 1. init
	# 2. turn on motor
	# 3. pulse width modulate? whatever PWM stands for
	# 4. read sensor
	# 5. flip to go forward and reverse

```