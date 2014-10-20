CSC469 Tutorial 3
====================

Shared Memory Consistency
----------------------------

We need to know how our memory operations are arranged in our programs, because if
we make incorrect assumptions, our program could crash. It's also important
because if we evaluate our algorithm with the wrong assumptions, we won't
understand its performance properly.

We define memory consistency as the order in which memory operations appear to
execute(loads and writes).

Sequential Consistency
--------------------------

We consider a setup sequentially consistent if machine instructions are not
reordered from the order they are specified in the program, and if all processors
see the same order of memory.

It's feasible to implement this using a single processor machine. But we don't
really want to, because it's restrictive and we lose the power of doing multiple
reads sequentially, forcing us to do a bunch of slower memory operations.

Hardware Optimizations
------------------------

The hardware does some cool optimizations that we need to understand if we're going
to write a system that takes advantage of those optimizations. We also need to
understand them because they can have scary effects on code running on multiple
processors.