CSC469 Tutorial 1
==================

Review of Monolithic OS, Microkernel, Exokernel
-------------------------------------------------

A microkernel keeps the kernel small by only allowing
it to handle threading and IPC. Everything else
is in userspace. In monolithic, you have user applications
in user space, and all OS functionality is in kernel space.

In an exokernel, the protection is separated out, and
everything else is provided at the application-level. Very
minimal kernel that provides secure access to the hardware
resources.

Review of VMMs (Virtual Machine Monitors)
------------------------------------------

A VMM is a hardware virtualization technique that allows
software to interact with hardware through a thin software
layer. Basically simulates the hardware layer. Also
called a hypervisor.

Two types: type 1 runs directly on the hosts' hardware
(e.g. Disco/VMWare, Xen), and type 2 runs within a
conventional OS environment(e.g. VMWare Workstation,
Virtual PC).

Disco
-------

The goal of Disco was to extend the modern OS
to run efficiently on shared memory multiprocessors
without large changes to the OS. This was difficult
because a lot of OSs were not designed to scale
to multiprocessors. Lots of lock contention, and
faults were not contained to processors.

By putting a VMM on top of things, we can have the
VMM manage resource allocation in *smarter* ways compared
to outdated OSs which weren't written with multiprocessors
in mind yet.

Challenges
------------

Overhead: extra layer of abstraction needs to be *fast*, or
else you won't be able to simulate hardware effectively. Memory
also needs to support the code and data of multiple operating
systems at once, which are normally designed with the idea of
having one OS in memory at once.

Resource Management: Lack of info. Idle loop and lock busy-waiting
since the OS doesn't have direct access to hardware anymore(?)

Solutions
-----------

Adds a second TLB, which after the physical to machine address
translation occurs also translates the address to a VM address.

For I/O devices, each VM assumes it has exclusive access. This
is handled using virtual devices exclusive to VM. The physical
devices are multiplexed between virtual ones.

To handle this functionality, special drivers are introduced into
the VM that take care of I/O operations. For disks, maps mounted
virtual disks to physical disk locations on operations, and
for network requests, forwards the network request on to
the actual OS using copy-on-write mapping for faster sharing.

Xen Virtualization
--------------------

Two kinds -- **paravirtualiziation**, where the guests run a modified OS
that has high performance on x86, and **hardware-assisted virtualization**,
where the CPUs support virtualization, meaning guest OSs don't have to
be modified.

One of the virtualized OSs is running what's called the Control Plane
Software. This software has access to the hardware directly, used to
initialize/manage VMs.

paper -- "Xen and the art of virtualization" 2003

Practice Questions
--------------------

1. What is the difference between an exokernel and a hypervisor?
2. What about an exokernel and a microkernel?
3. What is the difference between a hypervisor(VMM) and a
microkernel?
4. Can a microkernel be used to implement a hypervisor?
5. Can a hypervisor be used to implement a microkernel?

Hypervisors for Servers
-------------------------

Better to use a Type 1 hypervisor because it's closer to the
hardware, so it's faster.