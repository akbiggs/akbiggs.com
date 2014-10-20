CSC469 Lecture 5
================

Lock Review
-------------

Recall that a **spinlock** is just looping and spinning until we can
acquire the lock. They're good if we have nothing else to do, or the
wait times are short, or we're not allowed to block threads, despite
their bad performance for longer times. We'll be focusing on these.

The basic operation on a spinlock is TAS(test and set) -- checks to see
if the lock is available, locks it if so. Needs to be an atomic operation.

The Cost of Locking
--------------------

Since we need the lock to operate atomically in order to perform correctly,
this means that every thread waiting needs to operate on memory to check
the value of the lock. This leads to each thread hammering memory.

To improve on this performance, we spin in the cache using a local variable,
and access the memory only when the lock is likely to be available. Our
cached copy is invalidated when the lock is released. This is called a TTAS
(test and test and set) operation. 

However, this still leads to every thread hammering memory at the same time
when they think the lock will end up being available.

So we introduce *backoff*, where each thread is pausing for a delay that is
growing exponentially (* 2 on each iteration). However, this is still not a very
fair algorithm, can lead to some threads getting screwed over.

Ticket Locks
--------------

Resolve the fairness issues through FIFO order, while reducing the number of atomic
operations. The lock has two counters, next_ticket and now_serving.

For a thread to acquire the lock, they do the atomic FAA (Fetch and Add) op
to retrieve the next ticket of the lock, and loop until their acquired
ticket matches the now_serving value on the lock. When the lock is released,
the now_serving value is incremented.

Queuing Locks
---------------

With a ticket lock, there's a bit of contention at release time when the
threads have to acquire the new value of now_serving. A Queuing Lock
solves this.

Each CPU spins on a different memory location, reducing cache
traffic and memory contention. Each CPU is added to a different point in
a queue for acquiring the lock, and spins on that position in the queue.

Each node needs to refer to a node on another CPU, so the structures for
the nodes in the linked list are in shared memory.

The Problems With Locks
========================

Although locks protect shared data and avoid inconsistent views, they have
lots of problem. Deadlock, priority inversion, not fault tolerant, ...

**Deadlock**: There is a set of threads blocked waiting for events that can only be
caused by threads also in the set.

**Priority Inversion**: A low priority thread gets the lock that a high priority
thread needs. Now the high priority thread gets a lot of time to wait while
the low priority thread is unable to do what it needs to release the lock.

**Not Fault Tolerant**: If the lock holder crashes, or gets delayed, everyone is
stuck.

**Convoying**: A bunch of threads start at different times, and do similar work
sharing some data. We would expect that the time when the locks are needed would
be spread out over time, but because of the time the first thread spends with the
lock, the other threads catch up and contention occurs.

Even when uncontended, locks are still very expensive. Ten years ago, it took 0.24
nanoseconds to execute a single instruction, and 234 nanoseconds to acquire a lock.
This has huge implications for locked regions of shared memory -- a lock will inherently be way more expensive to work with.

Not Locking
-------------

So maybe we shouldn't try to lock unless we have to. There's this idea of
Non-Blocking Synchronization. Despite its name, this does not mean that threads
do not sleep.

In basic NBS, we attempt to make changes optimistically, and roll back and retry
the operations to a commit point if there are conflicts.

```
do {
	value = *pointer;
} while (!CAS(S,value,pointer));
```

The ABA Problem
------------------

Suppose we have two threads operating on the same stack. One pops off two values,
pushes on two new values, where the last of the new pushed values is equivalent to
the value that was originally on the stack. Now when our other thread uses the
CAS operation, it will succeed since S == value, but it has a completely different
stack so things get corrupted.

One solution to this issue is to store a version number with every pointer,
incrementing the version atomically every time the pointer is modified. This
will guarantee that CAS fails if the pointer changed, but requires an atomic
CAS operation that can operate on double-words.

Real-Copy Update (RCU)
------------------------

Motivated as an alternative to the idea of NBS based on the idea of real-world
computers not failing in the same way that theoretical computers do.

RCU is a reader-writer synchronization mechanism, where the readers use no
locks, and the writers create new versions atomically, typically by locking
out other writers. Readers can continue to access the old versions, until they're
done with them, at which point the outdated copies need to be cleaned up. kinda
like garbage collection.

Since we don't use locks, we need to find some way to avoid having the CPU
and Compiler reorder statements, so data is initialized in the right order.
RCU provides rcu_assign_pointer and rcu_dereference to enforce operations
executing in the right order.

TODO: study quiescent state based reclamation.