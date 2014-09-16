CSC469 Lecture 1
==================

When reading notes, don't go linearly. Focus on the intro and conclusion
to get the meat of the paper. Also, if the paper hasn't already been
selected for you by someone, approach it with some skepticism.

Practice active reading: write notes on each paper you read, make
references between sections.
 
You generally have a few types of problems that you need to deal with
when working with large systems and change:

1. Incommenserate Scalability (scaling resources doesn't make sense)
2. Surprises (unforseen consequences of changes)
3. Trade-offs (you can't provide all the desirable features 
   simultaneously)

Complexity in a large software system is almost inevitable.
You have a large number of elements, a large number of
interconnections, irregularity in how those connections
are formed, lack of a methodical description, and a minimum
team size required to understand the system.

Some sources of system complexity are taking on too many objectives,
needing high usage of limited resources, and making design decisions that
try to be general but are ultimately unnecessary and have to be revisited
later.

So in this course, we'll try to approach understanding and controlling
complexity through the examination of case studies and existing
experience. We'll see how OS design changes in response to *technological
advances*, *new application requirements*, and *advanced system
objectives*.

OSs abstract system resources, providing access to processes, files,
sockets, memory, etc. They are constantly changing, due to shifting
hardware and software, and tend to be highly complex for the reasons
mentioned above. Combining systems together makes everything even more
complicated.

Dealing With Complexity
-------------------------

There are a few techniques we can apply to deal with complexity:

-**Modularity**: Break the implementation up into different components
as necessary.
-**Abstraction**: Separate the interface from the specification of the
implementation, so changes to the internal details do not propogate.
-**Hierarchy**: Build on modularity by recursively grouping different
sets of components based on their purpose(e.g. middleware, workhorses)

The **end-to-end argument** is that you should not implement something
at a low-level if it could be done just as well at a higher level.
Consider the example of transferring a file from node A to node B.
The end-to-end argument says that there is no need to handle verification
at intermediate low level steps when you could just do a final high-level
verification step at the end that was necessary anyways. However,
this doesn't necessarily apply when you're dealing with very unreliable
intermediate steps or extremely large files.

Try to keep things simple. Do one things at a time, and do it well. Make
it fast, don't hide power, and leave it to the client. Make these
interfaces as stable as possible.

Make an implementation work, and plan to throw one attempt at an
implementation away.

Isolate the normal and worst case. Handle the worst case safely,
you can do it slow, but the normal case needs to be fast.

Early Operating Systems
-------------------------

**The THE**: Operating system is cleanly separated into different layers 
(User programs > buffering of I/O > console > segment controller >
 processor allocation and interrupt handling). 
Every layer has a well-defined function and interface. Limits complexity,
can test the system nicely using simulated input, can't deadlock since
there are no cycles. However, it's really hard to partition things this
way.

**Monolithic OS**: You have processes for each application in user-space,
and the OS kernel in kernel-space, which has access to the different
resource managers, which in turn have access to the hardware. Common
in commercial systems.
Very flexible, well-understood, and very performant. Good protection
of OS against applications. However, you have no protection between
kernel components, you can't safely/easily extend it, and as the OS
grows it becomes much more complex.

**Open Systems**: There is no division between kernel and application
space. Apps have direct access to the hardware resources they need.
It sounds crazy today, but used to be *very* common. When resources
were extremely limited, you couldn't afford to deal with all those
levels of indirection. Very extensible and works for a single user
system. However, not very stable and composing extensions leads to
much more unpredictable behavior.

