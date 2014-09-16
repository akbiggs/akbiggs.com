CSC372 Lecture 2
================

Building Blocks of a Computer
------------------------------

We have a CPU, which contains an ALU(arithmetic logic unit), 
Registers, and a Program Counter.

We also have memory, and I/O, which is our various devices.

Memory is a bunch of storage, basically a series of flip-flops,
that can hold on to the values 0 and 1. Dividing our memory up
into a series of bytes (size of 8), we get a bunch of sixteen
flip-flops in each address line, going from 0000 to 0010 to
0100 to 0110 to 1000 ... and so forth. The combination of all
of these is called our address space. If we have four bits
of address, then the size of our address space is 4^2 = 16 bytes.

Most computers are byte-addressable.

We have two different architectures. In Von Neuman architecture,
we have one bus used for both data and instructions. In Harvard
architecture, has separate data and instruction buses, allowing for
more storage and transporation simultaneously. The instruction
set is designed to match the type of architecture of the machine.

Machines understand 0s and 1s, binary. Very easy to work with from
an electrical engineering perspective -- you can just see voltage
as 1 and no voltage as 0.

Languages
-----------

Machine language: patterns of 0s and 1s. Difficult to work with,
since there's no abstract way to reason about them.

Assembly language: higher than machine, uses symbolic names(mnemonics)
to represent patterns of 0s and 1s. e.g. add, sub, mov

Instructions
---------------

We want to be able to instruct the CPU to interact with the memory and
I/O, telling it how to do things for us. An instruction is a sequence of
a processor's language.

Suppose we have the statement C = A + B;

In asm we write: add C, A, B
We have three operands, meaning this instruction is called Risc-Based
instructions.

The pipeline of executing an assembly file looks something
like this:

"add C, A, B" -> assembler -> .o (object) file
in .s file

We may also have *library code*, which determines the files that should
be linked together, bringing external definitions into our .s file.
This is done using a linker.

in pipeline:

.o + library code -> linker -> .elf (machine code) ---> memory
        										  (load)

So it comes to our memory.
When the CPU is executing our code that has been loaded into memory,
it sets the PC equal to the address of the first line of our program.

The IR is responsible for taking the instruction, interpreting it and
setting the control signals necessary for things to take place every
cycle. As soon as this "thing" for the cycle is done, the PC is offset
by the size of the instruction, moving it to the next instruction.

Think of it this way: with a single instruction there are multiple
"implied" instructions. "add C, A, B" implies loading the values in
A and B, loading the address in C, using the ALU to perform the
actual addition, and taking the value in the register and putting
it at C's address. The IR figures all of that out, sets up the memory,
executes the implied instructions and sets the PC equal to the
address at the end.

The PC is just a register, nothing else. It holds the address of
the instruction that is *next* to be executed(current instruction
is in IR). Address is used to fetch and execute another instruction
one instruction at a time. Instructions are executed one at a time
in order of increasing addresses. This is referred to as straight-line
sequencing.

The Register
--------------

What exactly is a register? It's a very fast access of some small
amount of memory. It's fast because it is physically close to the
CPU -- we store it inside the CPU, so things travel over short
distances. Since it is stored in the CPU, we can't afford to have a 
large amount of storage, so it's a very small amount. Then there
are caches, in order of increasing size placed farther away each
time, and then memory. So memory is relatively very slow to access.

So with registers, we have faster processing, but shorter instructions.
Since storing the instruction takes a certain amount of space for the
OPCODE, and we need to store the arguments as well, we can't store
large instructions, so only small instructions can be stored in the
register.

The Nios II has 32 32-bit general purpose regs.

There's a block in the CPU called the register file, which has our 32
locations of registers.

Each 32 bits within that block, 32 times, represents a register. We
index the register by its location in the block. So we have r0, r1, r2,
... r8, ..., r23, ..., r31 located in memory next to each other. We
also have six more registers after r31 called the control registers.
These are not available to the programmer, but instead are used by
the IR and other parts of the CPU.

r8 to r23 are mostly used by the programmer.

Instructions (again)
----------------------

e.g. C = A - B
sub r8, r9, r10

In order to execute this as a programmer, we need to have prepopulated
the values of r9 and r10 with the values of the variables A and B. We
need to do all the implied instructions mentioned earlier. This
is why they are called RISC instructions -- they are Reduced
Instructions that abstract the detail of what is going on behind
the scenes. 

Addressing Modes
-----------------

The way that you put the instruction and the operands together, the
way that the operands are specified is called the *addressing mode*.

-Register Mode: operand is register. e.g. add r8, r9, r10
-Immediate Mode: operand is immediate value given in instruction,
i.e. addi rb,ra,imms (immediate signed), e.g. addi r10, r11, -3

The immediate value is a 16-bit signed number. This allows you
to store the value with the instruction, saving you an extra read
operation.

Recall that to store a signed number, you use the two's complements
system.

Intuitively, to switch -3 to positive, you read from right to left
until you hit the first one, then flip everything to the left of that 1.

-Displacement Mode: effective address of operand is: register + imms

syntax: "ldw rB, imms(rA)" means load the word from rA + imms and put
in rB

(recall ldw: load word(four bytes, 32 bits))

e.g. ldw r8, 4(r9)

When words are loaded into memory, the endian-ness of the value is
swapped, effectively reversing the order in which things are stored.
However, the value is still the same.

Note: In order to operate on a piece of hardware, we can't just
leverage the signal from the value. We need something to do the
heavy work of operating the device, that reads from the memory
to figure out when the I/O device should be activated and deactivated.
This is the driver. When the memory at some space controls the 
activation of the hardware, we call that **memory-mapped I/O**.

Note that for a simple LED, we only need one bit, so we can map
different LEDs to the same word of memory, just on different bits.

Load/Store Instructions
-------------------------

These are used for accessing the I/O device interface.

In the CPU, there's a bus that is used to transfer data from
registers into the cache(buffer). From the cache, it goes
into main memory. It's the main memory that connects to the I/O
devices. But note that I/O device operations need to be very quick,
they can't afford to wait, and when going from the cache into main
memory we usually try to batch data together into chunks to avoid
doing lots of read/writes. So we want a way to bypass the cache
(buffer) and directly write to the memory that controls the
I/O device, to ensure immediate feedback.