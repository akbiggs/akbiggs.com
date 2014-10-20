CSC372 Lecture 11
===================

For the seven-segment display, we have seven LEDs laid out in the arrangement
of an 8. By toggling LEDs on and off, we can form any number or character.

We have two registers, one at address 0x10000020, and another at
address 0x10000030. In register 1, bits 0 - 7 are Hex0, bits 8 - 15 are Hex1,
bits 16 - 23 is 2, and bits 24 - 31 is 3. In register 2, bits 0 - 31 are the
numbers 4, 5, 6, 7.

Layout:
```
      0
    5   1
      6 
    4   2
      3

```

```
.include "address_map.s"
.extern seconds
.extern SEVEN_SEG_TABLE

.section .text
.global inc_seconds

inc_seconds:
	# save registers

	movia r19,SEVEN_SEG_TABLE
	movia r16,seconds # load external method

	# increment by 1
	ldw r17,(r16)
	addi r17,r17,1
	stw r17,(r16)

	# determine Hex Table offset
	andi r17,r17,0x000F

	# adjust Hex Table Pointer
	movia 421,HEX_HEx0
	stw r20,(r21)

	# restore registers

	ret
	.end