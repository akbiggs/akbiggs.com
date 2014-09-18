CSC469 Lecture 2
==================

Microkernel
--------------

In a microkernel OS, a few services that we think would normally
be at the kernel level are run as regular processes outside the
microkernel. The user level contains both regular processes and
important OS services.

Design philosophy is that the kernel code should be as small as
possible, keeping the abstractions small, clean, and logical.

The kernel includes tasks and threads, virtual memory, and
interprocess communication. Everything else (networking, FS, etc.)
is at the user-level.

Experience is mixed.

Advantages:

- Very extensible, easy to add new OS functionality

- kernel doesn't impose a particular OS design, so you
can have different OS *personalities*, i.e. run different
servers each of which emulates a different OS, but each
running on the same microkernel. Allows apps to use their
own customized OS.

- mostly hardware agnostic, since the servers don't need
to know about what hardware they're running on

- strongly protected, even with parts of the OS

Disadvantages:

- **performance**: microkernel killer. System calls can require
a lot of protection mode changes.

- expensive to reimplement everything with a new model. Moving
your OS to a microkernel can actually be more work than moving
to new hardware, since at least with new hardware you'll know what
subsystems will be affected.

- bad past: look up IBM Workplace OS

Microkernel Performance Example
---------------------------------

1. App calls read(), trap to microkernel
2. microkernel has to request Unix personality to read
3. Unix personality has to send message to FSS, which
means trapping to the OS again
4. FSS looks up what to do, has to read some disk blocks,
which means trapping *again*
5. FSS sends message back to Unix personality
6. personality receives message, sends back to app
7. App receives data.

Each message requires trapping. Yikes.

Mach
-------

Research project approached in a few steps:

1. Proof of concept("fix" VM, threads, IPC in BSD 4.3)
2. Microkernel and "single-server" Unix emulation(take
the Unix kernel and saw it in half, half for kernel space,
half for user space)
3. Multi-server work

The multi-server part was never completed, but it was a hugely
influential project that got people excited and talking about
microkernels.

Mach Abstractions
------------------

1. Tasks are address space + resources
2. Threads are program counters within a task
3. Ports are message origin+destination, essentially
an object reference mechanism.
4. Messages, used to communicate between tasks, between
ports, between computers, etc.

Also provided device handling and a concept of virtual memory
+ handling things that are in physical memory.

What's really nice about the abstraction of messages is that you
can easily have a much more powerful multiprocessor computer
take care of a workload by transmitting it via messages and receiving
the results back.

It explored a lot of ideas, but left a few things to be desired
in the implementation. Notably because they started with a monolithic
system and broke it out, there were still a lot of dependencies,
and the microkernel was larger than one would want.

L4 Abstractions + Mechanisms
----------------------------

Starts mostly from scratch, proper microkernel. Has two basic abstractions:

1. Address spaces, the unit of protection. Initially empty, and populated
by privleged mapping operations.

2. Threads, the unit of execution. Kernel-scheduled, but managed at the
user level.

and two mechanisms:

1. IPC - synchronous message passing
2. Mapping - provides all access to memory and devices.

Drastically improved performance over Mach. L3 whitepaper showed 
that Mach's performance issues weren't necessarily from the
microkernel idea, but from the implementation.

The main performance benefit comes from a very small cache footprint.
Mach had a complex API, but more importantly, its large cache footprint
meant that it was memory bandwidth-limited. L4, instead, is CPU-limited.

L4Ka is *extremely* small these days (only 10k lines!). This is sweet,
because the kernel can be tested and formally proven to be correct/stable.

Exokernels
-------------

The microkernel design philosophy said that we should reduce the number
of abstractions. The exokernel research project from MIT claims that
all OS abstractions are bad, since in the process of hiding detail
you prevent applications from doing things that could be cool. Discourages
innovation.

So the solution an exokernel proposes is to separate protection from abstraction
and management. It's a *resource multiplexer*. It gives physical hardware
access to processes, and that's it. It's also very **fine-grained** about how
it gives out resources, e.g. provides individual disk blocks, instead of disk
partitions.

To deal with things like file permissions that are difficult for the exokernel
to keep track of, the user can provide code for the kernel to download that
can be executed in a privleged mode. Complicated, since you have to avoid
things like infinite loops when executing arbitrary code.

Virtual Machines
-----------------

In a virtual machine, you have a thin layer of software that resides over
the hardware, with monitoring tools like the hypervisor that simulate
the hardware, so the OS isn't aware that it's actually running on the software
level.

However, there are some virtualization systems that actually make it clear
to the OS that it's being virtualized, so it can handle some situations
more efficiently.

A virtual machine monitor provides an efficient, isolated and duplicated
version of the real machine.

The original motivation behind virtual machines in the 1960s was that
you needed to share large, expensive computers with many users,
and different groups wanted or needed different operating systems.
So it was convient for timesharing.

Today, large scale servers have similar issues as the machines
that originally motivated VMs. VMs also provide security,
portability/compatibility(since your hypervisor can schedule
things on multiple CPUs while the OS only sees a single CPU),
reliability/fault tolerance(try out code you don't trust in a VM),
migration(not dependent on physical hardware), and innovation(allows
us to try out new ideas safely).

Conventional software is developed for a specific OS and instruction
set architecture(ISA). This combination is considered the ABI. Gives us
two types of VMs: [process VMs](http://en.wikipedia.org/wiki/Virtual_machine#Process_virtual_machines)
and [system VMs](http://en.wikipedia.org/wiki/Virtual_machine#System_virtual_machines).
The process VM supports a single process, while the system VM works on an operating
system.

In a classic system VM (VMM), the VM runs on bare hardware. Most privleged
form of software. In a hosted VM, the VM is like a regular application.

Requirements
-------------

There are a few architecture requirements for a VM to function:

1. dual-mode operation
2. A way to call privleged operations from non-privleged mode.
3. memory relocation / protection hardware (need to know when the
memory isn't where the VM's hardware simulations says it should be
for optimization)
4. Asynchronous interrupts for I/O to communicate with CPU

None of these things are particularly difficult/esoteric on today's
architectures.

There are also a few generic VM operations that need to be implemented.

A *privleged instruction* is required to trap when it's not
executed in supervisor mode. A *sensitive instruction* affects the
operation of the system in some way. Pretty vague, but generally,
there's a theorem that as long as the sensitive instructions form
a subset of the privleged instructions, we can make an efficient
VMM, since the OS won't know the difference. This means that we
need to avoid instructions that have different effects depending
on whether they are executed in user mode or kernel mode.

Different approaches between VMs of how this is handled. VMware
uses binary rewriting, whereas Xen uses paravirtualization.

OS Extensions
---------------

Adding new functions to OS "on the fly", at runtime. Allows
for fixing mistakes, supporting new features or hardware.
For implementation, you could give everyone their own 
machine (VMs), allow some OS functions to run outside (ukernel),
or we could alow users to modify the OS directly (loadable kernel
modules).

The last solution is popular because giving everyone their
own VM is pretty drastic for a potentially small change. So
this solution allows parts of the kernel to be dynamically
loaded and unloaded, replacing the small parts accordingly.
This is for example how drivers could be implemented.

But this also means that if the loaded part is buggy, then
the kernel will crash. Responsible for a large majority of
BSODs.