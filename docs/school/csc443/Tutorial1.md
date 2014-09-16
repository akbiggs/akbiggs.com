CSC443 Tutorial 1
==================

Objectives
-----------

1. Understand the need for block-based I/O
2. Intro to first assignment

Block-based I/O
----------------

It's really important that before you start using a buffer
and doing block-based writes, you zero out the buffer by the
size of the block. It's also important that you flush out
the buffer before you're done using it(or the write won't
actually take place).

Is there an optimal value for our chosen block size? It's going
to depend completely on the hardware itself. Different pieces
of hardware have different characteristics, especially between
an SSD and a hard drive. So you need to figure out the optimal
performance for different hardware.

If you have a slow CPU, you'll notice in the histograms of your
operations for block-based I/O that as the block size increases,
it starts to go up since the computer is not I/O-blocked,
it's CPU-blocked.

Assignment
-------------

Record directory:

In a page, let's say 16 KBs in size, you have a bunch of records.
Say 16 records per page. Every record has an offset in the page,
called the slot number of the record, which we can use to compute
its position within the page. Each record consists of a tuple
(pageid, slot#). So when we load a record into a directory,
we load the whole page, but we also use that record's number
to direct to it.

The end of the record has our record directory. It's a flag that
indicates which records are empty and which records are in use.
This allows you to skip over empty records when doing scans.