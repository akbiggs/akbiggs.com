CSC372 Lecture 3
==================

Aside: The switch fabric on the Avalon controls what has access to what interface is being
used at any given point.

Recall
----------

In a CPU we have a buffer, used to communicate with the main memory via a bus and which
communicates internally inside the CPU.

Since we don't want to have our read/write to I/O-mapped memory wait for the buffer to
flush, we need a way to do operations that are not buffered. So we define two separate
commands from ldw and stw, ldwio and stwio, which do the same thing but are not buffered,
so they take effect *immediately*.

Furthermore, we have operations for loading and storing half-words: ldh+ldhio and
sth+sthio. These are signed half word transfers. The most-significant bit will
be extended to include the sign (0/1). We also have load operations on half unsigned
bytes (ldhu), so the most-significant bit is 0, BUT we do not have sthu because
we need to make sure that memory is aligned in word-sized chunks.

There are signed byte operations (ldb, stb) and an unsigned byte load operation.
Essentially the lack of an unsigned operation comes from the relative complexity
of supporting that instruction properly.

Note that with the signed half word and single byte operations, 
the F at the most major byte would be carried on to the rest of the bytes. Similarly,
the 0 at the most major byte would be carried on to the rest of the bytes if the
sign was 0 or the number was unsigned.