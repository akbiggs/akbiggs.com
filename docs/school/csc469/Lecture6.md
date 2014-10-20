CSC469 Lecture 6
Transactional Memory
====================

Database Transactions
------------------------

We use this as inspiration behind transactional memory, since databases
are able to provide concurrent query execution without the person writing
the query having to worry about it. There are atomic and consistent operations,
which determine how the operations should be ordered when executing a query.

Transactional Memory
----------------------

With transactional memory, we gain a magic keyword, *atomic*:

```
atomic {
	...
	access_shared_data()
	...
}
```

Specifies that we want  an action to execute as a single unit.
The TM system executes transactions optimistically in parallel, leaving
checkpoints at each point, until it detects a conflict, at which point it
rolls back and re-executes the code.

Differences from DB Transactions
-----------------------------------

1. DB transactions are operating on disk, so the cost of keeping checkpoints
and checking conflicts is dwarfed by the time spent on disk. However, in
our TM system, we need to make sure these operations are super optimized,
since everything's being done in memory.

2. We have no need for durability.

3. A program using TM has to coexist with libraries and operating systems that
do not use it.

TM Options
------------

1. Hardware
	-- requires changes to system
	-- need extra cache for buffer writes, extend coherence protocol to track
	conflicts, special transaction instructions
	-- only supports a limited number of memory locations

2. Software
	-- language runtime or library and extensions required to use transaction
	-- exploit multicores
	-- more widely used

3. Hybrid

Caution
-----------

With an atomic operation, things won't see the results from functions until
they finish executing, since the transaction won't be commited until the end.
So if you have two threads running with atomic operations that set flags that
would unblock the other thread, and then wait for their flag to become true,
the flag wouldn't be set until the transaction completes. Visibility issue.

Isolation is another concern. We have two types of isolation -- weak and strong
isolation. Weak isolation means that a memory reference outside the transaction
may not follow the protocols of the TM system. Strong isolation converts all
operations outside atomic blocks into individual transactions, guaranteeing
everything obeys TM protocols.

For nested transactions(required for composability), we have three options:

1. Flattened: remove inner transaction. Risk more aborts.
2. Closed: effect of inner transaction only visible to surrounding one,
abort affects only inner. Very difficult to implement.
3. Open: Effect of inner becomes visible to everything after commit. Abort
affects only inner. Solves the abort problem, but we've broken some isolation
properties. Also, what if the outer one aborts afterwards?

Most systems implement a flattened transaction model, use another strategy
if abort rate becomes too high.

Implementation
----------------

Options:

	1. What unit do we detect conflict over? Word or object?

	2. Should a transaction directly modify an object or modify a private
	copy and then propogate at commit time? Both are complicated when you
	have data races.

	3. Should we be optimistic when executing operations concurrently? Or
	pessimistic instead? Typically we're optimistic, leading to the need
	to detect and resolve conflicts.

Scalability
===============

With scaling things, adding more processors to a machine not designed for
lots of processors won't cut it. The throughput will decrease after a certain
point, rather than increase.

The main enemy of scaleability is shared data, since we need to make sure that
we're not blocking the CPUs on other CPUs accessing that data. We distribute
our data structures and use per-cpu data whenever possible, padding the cache
lines to make sure that we don't accidentally share a cache line between
processors.

MP Scheduling
---------------

How do we assign threads to different CPUs?

Same considerations as uniprocessor scheduling, but now we have to take into
account the ready queue implementation, load balancing, and which CPU the
thread would be best suited for based on the current location of data.

