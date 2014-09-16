CSC372 Lecture 1
================

Teacher: Hamid Timorabadi (h.timorabadi@utoronto.ca)

TA: Peter McCormick (peter@pdmccormick.com), Peyman Hadi(peyman.hadi@gmail.com)

Lecture
===========

Microprocessors are everywhere. They are any device with some level
of electronics/electrical components.

Laws
========

Moore's Law: every 18 months, transistor density of semiconductor chips doubles.
Trying to say that we will be able to pack more and more power into smaller transistors,
around every 18 months.

Not so much about performance, but about the number of transistors.

Joy's Law: computer speed doubles every year.

Complexity & Slowdown
======================

Software demand is increasing at a rapid pace, and the complexity of software
is increasing just as rapidly.

Software relied on Moore's Law to achieve faster performance, but due to
numerous hardware challenges, doubling up became infeasible around 2002.
The designer could no longer rely on hardware improving.

Challenges
===============

Power Density
---------------

If you look at a processor, and the amount of silicon, it's very very small.
As you double transistor density, you also gain very high power density, and
ventilation becomes difficult. Starts to become dangerous/unstable, and the
hardware melts due to the heat.

ManyCore is the concept of having many processors per chip, apparently without
limit. We can split the power between each core, reducing power density. But how
do you program these chips? You could dedicate cores to different processes,
leading to the idea of parallelism.

Hardware Complexity
--------------------

When you look at hardware, you have a ton of manufacturers and architectures.
You have to deal with different CPUs, different memory types, different I/O
devices, different networking methods. So the complexity of software to interface
with that hardware becomes significantly more complicated.

Shared Memory
---------------

Everything in the computer connects physically to different memory locations.
Shared memory means that you have to be careful about what gets mapped where,
and what needs to be accessed at different points.

Recall that with a processor, you are executing one single instruction at a time.
You need to be careful to make sure that those instructions are being delegated
to the most important processes at any given point, with minimal interference
to the user experience.

-------------------

So it's not practical to provide code for each independent task, using
the required hardware for that task.

So you add an OS, which always tries to accomodate the application with the
hardware and manages resources. But due to the increasing complexity, designing
and implementing an OS is not easy.

This course won't be about exploring OSs or implementing complicated ones. Instead,
we employ the basics of architecture to improve performance and resource management
for small Microprocessor applications. We aim to develop better embedded systems to
gain a better appreciation for the computer system.