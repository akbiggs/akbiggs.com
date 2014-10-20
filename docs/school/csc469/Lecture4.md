CSC469 Lecture 4
================

Interrupts
============


Software Interrupts
---------------------

When you execute an interrupt, part of it is deferred to other parts of
the operating system to be executed at a slightly later time. These parts
are referred to as "software interrupts".

e.g. Network has some time-critical work, like copying packets off the
hardware and responding to the hardware, but it also has some deferred work
to process the packet, figure out what type of packet it is, pass it off to
the correct application. Similarly, timers have time-critical work (incrementing
current time of day) and deferred work (changing process priorities).

Signals
===========

Basic software mechanism for IPC, allows a process to respond to async external
events by specifying its own signal handlers or using the OS' default actions.

Internally, a process has a structure that stores flags for possible signals and
the corresponding actions to take. When a process receives a signal, a pending
flag is set, and then the action occurs the next time the process checks for
signals to execute.

Terminology
--------------

**Posting**: When we generate a signal.

**Delivery**: action taken when process recognizes arrival of signal(handling)

**Catching**: process catches signal when it executes some user-level action in
response.

**Pending**: when the process' flag for that signal has been set but the action
hasn't been taken yet

Complications
----------------

The handlers can execute at any time, so we need to be careful when we're
manipulating global state in the signal handler.

A signal delivery can interrupt execution of signal handler, so we need to make sure
our code can be entered multiple times by the same process without running into
deadlock.

Kernel View of Signals
-----------------------

We have a fixed set of signals in the kernel, each with its own unique number to
identify it. The signal set for a process is a bit vector, where each bit gives
the status of its corresponding signal.

When we set a signal on a process, we wake up the process, interrupt whatever it's
currently doing(including blocking system calls such as read), and give it the
signal. If a process is multi-threaded, need to find a thread to give the signal
to -- on FreeBSD, this is done using signal masks for each thread that say what
signals they don't want to receive. Sending a signal to a multi-threaded process
makes it search for the first thread that doesn't mask the signal.

During the delivery and handling of a signal on FreeBSD, the process sets up
a trapframe like you would when calling a regular function for the stack pointer,
return address, and program counter. Then the trampoline code executes in user
space.

Real-Time Signals
-----------------

Normal signals can't carry any extra info besides the signal number. A real-time
signal can carry a value, but we only have a few of them on most OSs, and they
aren't really able to carry a bunch of stuff.

Other Communication Mechanisms
=================================

Signals are limited in that they are unable to transfer any other information. 
Normally used for communication of exceptional events since they're so unspecific.
UNIX provides a number of other communication methods that we can use to transfer
data around.

Pipes were created as a unidirectional stream that processes can use to receive info
from other processes. However, they were limited in the sense that processes could
only gain access to them through a direct parent-child relationship with the
process creating the pipe's output. So fifos were created, which were named pipes,
but they were also unidirectional and not great for communicating back and forth
between processes.

So nowadays we use **sockets**. A socket is a commmunication endpoint where you
can send data to the endpoint and get a response back, between computers over
a network.

Socket Implementation
------------------------

For memory management of socket resources and data, we use a custom main data
structure, mbuf. We use this because we need to efficiently allocate and reclaim
memory, add and remove headers, dividing a stream into packets and combining
received packets, and moving data between queues. Mbufs are allocated from
a pool of fixed-size blocks of memory, making allocation and reclamation very
fast, and avoiding external fragmentation and coallescing. Allows multiple blocks
to be chained together for longer messages.

For multi-packet messages, we send together packages of mbufs. The first mbuf
of each package has a pointer to the first mbuf of the next package.

Descriptor-based IPC
----------------------

We associate with each file a descriptor that describes the state of the file
being operated on, including its ID.

