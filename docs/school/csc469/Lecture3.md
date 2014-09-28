CSC469 Lecture 3
====================

Recall that loadable kernel modules allow you to load
in parts of the kernel dynamically. Used to handle
drivers on monolithic kernels.

Linux Loadable Kernel Modules
------------------------------

Module writer needs to define two functions: init_module and cleanup_module.
init is called when module loads, cleanup is called when it unloads.
To find these methods, it takes advantage of the fact that the ELF format
is consistent

Has insmod, rmmod, lsmod commands for loading, unloading and listing
modules.

To track modules, the kernel has a doubly linked list of module objects.
This module object is a struct contained in the module memory,
including information such as name, reference counters that are used
by the CPU to track what's using the module, and a list of other module
names that use the module.

Kernel Handlers for Modules
------------------------------

**sys_init_module()**: The system call for init_module. Handles various
low-level functionality(checking permission and copying arguments,
allocating memory, etc.). When the module is attached to the list,
it isn't initialized yet, and its state is set to MODULE_STATE_COMING.
Then init_module gets called, and the module state is set to ready.

**rmmod()**: Needs to ensure that nobody is using the module first, uses
the reference counter for that. Also needs to be very careful about
how memory is freed, and when -- if you free some object at a time
when it's currently in use by the system, you're screwed.

Drawbacks With Modules
---------------------------

Requires stable interfaces at the OS level or the module breaks since
it won't be able to call some stuff. It's also very unsafe since the module
code is able to do anything, since it runs at the kernel level.

Alternatives
--------------

Trusted compiler + digital signatures: Allows verification of the author
of the code added to the kernel. Still have to decide if the source is trustworthy,
and the code can still do anything.

Proof-carrying code: The consumer supplies a spec of what the extension is
allowed to do, and the producer must give a proof that it's safe according
to the specs. The OS handles the validation. The proofs are easy to check,
but they can be hard to generate.

Sandboxing: Limits memory references to per-module divisions, and checks for
some unsafe instructions.

Papers to look at: Spin, Veno

Performance
=============

Time Scales + Measurement
---------------------------

When we talk about time on a computer, we're dealing with two scales,
really. Microscopic(processor ops) and macroscopic(I/O).

How do we measure this?

We can use the CPU time, to figure out how many total seconds of CPU
execution are used when executing X. This is the measure used by most
apps, and has a small dependence on other activities.

We could also use actual time, and measure the diff between the start
and the completion of the process, but this is very dependent on how
loaded your system is and what kind of I/O operations are happening.

From here on, "time" will refer to the user time, the time spent
executing instructions in the user process. However, in practice,
it is difficult to actually draw a line between system time
and other user processes that are running at the same time as
your process.

Interval Counting
--------------------

You keep two counts per process, user time and system time. With every
timer interrupt that occurs, you check the current process and mode that
you're in, and increment the count by the interval.

Runs into some problems: if you switch into a process after doing
a lot of work in another process, and then a timer interrupt occurs, all
of that time is attributed to the wrong process.

However, in the long run, these over/under errors tend to average out,
and you get a decent approximation of how much time is being spent.

Cycle Counters
----------------

We use special registers that are incremented every clock cycle. Very
fine-grained measurement, and maintained as part of the process state. We
use some special asm code to access this register.

Needs to be 64 bits, since for a 2 Ghz machine the low-order 32-bits
of the register wrap around very quickly, but the upper-order 32 bits
do not.

Time of Day
-------------

gettimeofday() is a nice system call that gives you the elapsed time
since a reference date (Jan 1 1970). You can use it to track the elapsed
time between some code executing. However, being a system call, you also
need to accomodate for the overhead that comes with the context switch.

Overhead
------------

Even just reading the register still incurs a bit of overhead. One way
we can work around this is by doing a bunch of gettimeofday() calls
and averaging the distance between each one.

However, we also have to worry about cache hits and misses; the order in which we
execute statements can have dramatic differences on our time measurements for the
time that functions take.

To avoid this, we need to warm up the cache before we take our time measurements,
by executing the function once, and then doubling the number of times that you
keep executing the function between time intervals until you reach some threshold.
When we take our cycle counter measurements, we have to divide it by the number
of times the function was executed.

Annoyingly, context switches also affect the cache performance. We need to make sure
that our code being timed is short enough that it can finish within a single time
slice, so no context switch occurs.

We can detect I/O interrupts by checking to see if the real-time clock advanced
during the execution of our code. This is because the real-time clock is only
advanced when a timer interrupt occurs. Not very accurate.

To improve our measurements, we can use a K-best measurements method, where
we assume that bad measurements always overestimate time, and then take
samples until the lowest K time measurements are within a small tolerance factor.
We then take the fastest measurement. If the errors can also underestimate time,
then we look for a cluster of samples within some tolerance, and then take the
average of that cluster.

In summary, it's really difficult to get accurate times, and difficult to
get repeatable times.

Hardware Performance Measure
------------------------------

Modern CPUs contain counter registers for low-level architectural events,
for example the number of instructions executed, or branches taken.

However, they are difficult to use, since there are only a limited amount
of counters (so you can't count all the interesting events), they're non-standard,
and poorly documented.

Designing Experiments
======================

Measurement isn't sufficient for an experiment. We need to come up with
some metrics that we're using to figure out what factors are important for
our experiment. e.g. latency, bandwidth, power consumption, throughput, all
time,

You also need a system to measure, a set of tests to perform(benchmarks),
and a hypothesis of what we expect to learn from doing this experiment.
A good hypothesis should be falsifiable, i.e. if the hypothesis is wrong,
there should be an experiment that proves you wrong. It also should be more
specific than "my system is better than your system".

STUDY: performance metric questions on slides.

In your choice of experiment, try all possible combinations of the different
factors that you're experimenting on if combinations exist. e.g. types of
processor, garbage collection methods, and workloads.

However, it's difficult to measure a real workload, since we need repeatability
and we might want to test new ideas that can't be deployed in real settings. To
solve this, we use **macro benchmarks**, which emulate typical workloads.
You need to be really careful about your choice of benchmark here -- the wrong
size or type of data can lead to side-effects with the OS that change how it handles
the opeation, e.g. attempting a disk measurement with data small enough to fit into
memory on modern machines.

Watch out for averaged relative performance numbers! Inaccurate.

Amdahl's Law
---------------

When considering the overall speed gained from an optimization, make sure that
you consider the amount of time that you can't optimize. The overall speedup
will be the overall time before the optimization / the overall time after the
optimization, not just a comparison of the section being optimized.

The lesson that Amdahl's Law teaches us is that it's difficult to speed up
a program, since if you identify and eliminate one bottleneck in a system,
something else becomes the bottleneck