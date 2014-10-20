CSC372 Lecture 9
--------------------

Interrupts
-------------

Interrupts are used for many, many things, including closing processes in a safe
way before they are closed by e.g. the system shutting down.

An interrupt is an async signal from HW indicating the need for a change in code
execution. Most of the time, we want to use an interrupt because polling is
extremely expensive for longer wait times. However, polling is also easy to 
implement, and it's great for short wait times. Something not to overlook is the
fact that an interrupt can occur anytime, whereas polling is restricted to a busy
wait loop.

Interrupt Handler (Interrupt Service Routine(ISR))
--------------------------------------------------

An interrupt handler has to be placed at address 0x20.

For example:

```
.section .exceptions, "ax" # meaning allocatable executable
.global ISRname
ISR:
	... 	# decide how to handle the exception
	eret 	# exception return
```

In the DE2, everything that can interrupt uses IRQs to broadcast those
interrupts back to the CPU. (What's an IRQ?)

Registers r31-onwards are control registers that are used to control various
services connected to the CPU.

ctl0 is status, ctl1 is estatus, ctl2 is bstatus, ctl3 is ienable (enable
interrupts), ctl4 is ipending(pending interrupts), ctl5 is cpuid.

The zeroth bit of the ctl0 register sets whether or not interrupts can happen
in the middle of executing another process' code.

The 32 bits of ienable each control a separate device that is connected to the
computer. Similarly, the 32 bits of ipending control whether or not there is
an interrupt pending from each device.

We also have special commands for reading and writing controls: rdctl for
reading a control, and wrctl for writing a control.

Example:

```
movi r9, 0b1
wrctl status,r9 # or wrctl ctl0,r9, same thing
```

Longer example:

```
.global main
main:
	# set up interrupt
	# do something
	movi ...
@0x1000	subi ... # INTERRUPT OCCURS!
@0x1004 addi ... # now the PC counter will be here

	...

ISR:
	...
	subi ea,ea,4 # we need to make sure that when we go back, our PC is at the
				 # last instruction we were at(subi), instead of the one that it was
				 # going to go to next(addi).
	eret 		 # return and re-execute subi.
```

When an interrupt occurs, the execution of the current instruction is abandoned.
The old address of the PC is saved in ea(alias for r29, meaning exception address).
Now ea is the address of the next instruction, not the current one: ```ea <- PC+4```

Then PC takes on the address of the ISR(0x20). When you return, ISR executes eret, causing PC to take on the value of ea. We need to subtract four from the ea before
returning to make sure we go back to the previous instruction.

Timer Interrupt
----------------

Full code to come in the next lecture.

```
stwio zero,(r8) # reset timer

# start, allow interrupts
movi r9,0b101
stwio r9,4(r8)

# enable external interrupts
movi r9,0b1
wrctl ienable,r9
movi r9,0b1
wrctl status,r9
```