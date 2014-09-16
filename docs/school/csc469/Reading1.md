CSC469 Reading 1
End-To-End Argument
====================

The basis of the end-to-end argument is that functionality should be
implemented at the highest level of abstraction that needs to know about
it, instead of at lower levels.

No matter how complex the implementation of the communcation network
becomes, checks will always need to be performed at both ends of the network
to ensure the data was transferred correctly. Spending time and effort getting
intermediate checks to work can be highly damaging towards the performance
of a system, not beneficial. The end-to-end argument paper generalizes this
argument, saying to avoid low-level checks in these situations if the faults
are not very likely to occur.

However, there are always exceptions, such as when you're dealing with
transferring large amounts of data. The end-to-end argument should not
be universally applied, but it should be considered when aiming towards
making a system foolproof.

To summarize, consider the argument before
taking on extra layers of complexity in an attempt to help the user.

Hints for Computer System Design
=================================

A computer system is much different from designing an algorithm.

- The external interface is more complex and less precisely defined
- Much more internal structure => interfaces
- Measure of success is less clear.

This paper aims to share Lampson's knowledge of systems design with
the reader based on his substantial amount of experience.

Easiest to just [link the summary diagram](http://akbiggs.net/images/notes/systemsdesign.png).

The Unix Time-Sharing System
==============================

The paper describes the implementation of the Unix operating system, although
it mainly focuses on the file-related aspects.

One interesting aspect of the file system is that input devices are controlled
using special files. e.g. to punch paper tape, one writes to the file
dev/ppt. I would be surprised if this practice is still used today due to the required
speed of interacting with hardware.

Each user has a unique id that is used to mark files that they create,
used to check against the protection bits of the file, allowing for permissions.
The super user is exempt from file protection.

Each open file in the system has its currently open position maintained by a
pointer. If the file is open multiple times in several processes, each process
owns a separate pointer to the current location of the file to read.

FS Implementation
----------------

Each file entry in the Unix OS has its data stored in an i-node. This i-node
can be found by looking at an i-number attached to the file. The only other
info stored on a file itself is its name. The i-number can be used to
dereference an i-node from the i-list.

Of note on the inode in this early implementation is a bit indicating whether
the file is "large" or "small". Unix implements file storage through levels of
indirection for larger files, where each group of bytes is mapped to from
an address range. i.e. the file data storage is a tree branching off where
the leafs are the actual addresses of the blocks of data. A small file just
has one level of indirection to the blocks of data.

The Rest
-----------

The paper carries on to describe the implementation of mount, the interface
for processes that UNIX provides, the shell and its implementation, and traps.
Amazingly, Unix's interface appears to have changed very little over the past 40 years.

Conclusion
------------

The paper describes three factors as responsible for the success of Unix's design:

1. The system was designed with the intent of making it easy to write, test, and
run programs.
2. The size constraints on the software forced an "economical" approach to
design, bringing about a certain kind of elegance
3. The system maintains itself. People were enthusiastic to provide ideas for
ways that Unix could be improved, and the developers were happy to accomodate.

The Mach Kernel
=================

The development of the Mach was motivated by a lack of uniform access to different
resources in UNIX, both in a single machine and in a network.

Definitions
-------------

1. A *task* is an execution environment in which threads may run; has its own
virtual memory space and protected access to resources.
2. A *thread* is the basic unit of CPU computing. Roughly equivalent to an
independent programming counter operating within a task. Note that this is
**not** equivalent to a process in UNIX; a process would be a task running
a single thread.
3. A *port* is a communication channel, kind of like a queue for messages
protected by the kernel. They are considered the reference objects of the
Mach design(???), and have two operations: *Send* and *Receive*.
4. A *message* is a typed collection of data objects used in communication
between threads. Could be any size and may contain pointers and typed
capabilities for ports.

Thread Benefits
----------------

UNIX processes have a large amount of overhead due to the fact that a new virtual
memory address space needs to be partitioned for the process, among the division
of other resources. Furthermore, since coroutines were not supported by the
kernel, even using libraries built by other users would not allow for concurrency,
since the kernel would have no idea how to provision things.

The abstraction of tasks and threads is known to and supported by the kernel.
Since multiple threads can exist in the same task, you have a lightweight way
of "forking" without all the additional overhead.

Concurrency
------------

The Mach kernel supports three methods of concurrency:

1. create a single task with a bunch of threads in a shared address space, using
shared memory for communication and syncronization
2. create a bunch of tasks and share restricted sections of memory between them
3. communicate via messages between ports

This was an intentional part of the Mach design to accomodate the different
architectures and environments the kernel would be deployed onto.

Virtual Memory
---------------

The Mach kernel supports many different operations on virtual memory, including the
ability to copy on read/write and to share virtual memory between multiple tasks.
