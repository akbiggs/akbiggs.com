CSC443 Reading 1
=================

Chapters chapters 1, 8 - 11, excluding 9.2, and chapter 13.

Chapter 8: Overview of Storage and Indexing
==============

8.1 Data On External Storage
------------------------------

- the unit of measurement when doing disk I/O is a *page*
- a page is typically 4kb to 8kb
- we process pages when doing an initial read and when
writing to a DBMS
- disk I/O is very expensive, it's the bottleneck of DBMS
speed. DBMSs are designed around minimizing the amount of
time managing pages
- the layer of software that manages reading pages into memory
and writing them back to disk is called the *buffer manager*
- the *disk space manager* allocates more space as necessary for
the DBMS to operate

8.2 File Organizations and Indexing
-------------------------------------

- the file has a few operations: creation, destruction, record
insertion and deletion, and record scanning (going through records
in sequence)
- file layer stores records in a file in a bunch of pages, keeping
track of number of pages allocated in each file and the amount of
available space
- *heap (unordered) file*: Stores records in random order across the
page.
- *index*: Data structure that optimizes the organization of records
based on a search key field. The search key field is not necessarily
the same as the key. The index maps a search key k on to data entries
with search keys k*, from which record data can be retrieved. The
data entry k* can be stored in one of three ways:

1. the actual data record (with search key value k)
2. a (k, rid) pair, where the rid is the record id of a data record
with search key value k.
3. a (k, list<rid>) pair, where list<rid> is a list of record ids
to data records with search key value k.

If the organization of data entries in the index closely reflects
the organization of data records in the database, we call the database
*clustered*. Otherwise it is considered *unclustered*. In practice,
this is very difficult to maintain with index storage alternatives 2
and 3, and so usually indexes are only clustered with alternative 1,
while the other two are left unclustered.

A *primary* index is one that is placed on a primary key, whereas
a *secondary* index is one that is placed on another attribute.

8.3 Index Data Structures
--------------------------

The book covers two ways of storing indexes: tree-based and hash-based.

In hash-based indexing, the records in a file are grouped in *buckets*,
where each bucket consists of one primary page, potentially linked to
several more additional pages. Buckets are retrieved from the search key
using a hash function that maps from search keys to buckets, just like
in a hash table. If the search key value is used by more than one
record, the page will contain multiple records or there might be multiple
pages linked together in the bucket.

In tree-based indexing, the records are stored in a B+ tree. Only the
leafs of the tree contain the actual data entries; every node above
the leaf level is a level of indirection, referring to a physical
page on disk. With each node, you have one or more search key values
used to separate a bunch of pointers. The pointer to the left of a
given search key value *k* directs to data entries with search key
value < *k*. The pointer to the right directs to data entries with search
key value >= *k*.

Because each node in the B+ tree refers to a physical page on disk,
retrieving a node requires a disk I/O. The reason that the tree data structure
works very quickly is that the B+ tree always maintains a balanced height,
and each page is able to store a very large number of pointers. This means that
in practice, the B+ tree rarely expands to become larger than three or four
nodes in height, resulting in retrieving a record by search key only taking
three or four disk I/O operations.

One more term: *fanout* is the average number of children for a non-leaf node
in the tree. We can tell how many leaf pages in a tree of height h with uniform
amounts of children n by calculating n^h, but since the number of children of
each node is rarely uniform, F^h acts as a good approximation.

8.4 Comparison of File Organizations
--------------------------------------

This section compares the cost between a few different file organizations
of several operations: scan, search for equality, search for range, insert,
and delete.

It defines the cost model that it uses to figure out how expensive these
operations are.

B: number of data pages when records are packed neatly
R: number of records per page
D: read/write disk time (average)
C: process record time (average)
H: time required to apply hash function a record
F: tree fanout

A summary of the findings can be found [here](http://akbiggs.net/images/notes/443fileperf.png). A good exercise is reasoning through how each of those values was obtained.

8.5 Index and Performance Tuning
-----------------------------------

The reason that tree-based indexes are more commonly used vs. hash-based indexes
is that the hash-based index is only optimized for the search for equality
operation, not the search for range operation. A search for range operation can
be even less performant on a hash-based index storage system compared to a heap
file. The tree-based index handles both cases efficiently.

Tree-based index files are also effective when compared to sorted record files,
due to their ability to handle the insert and delete operations without significant
reorganizations of the rest of the file and the relative efficiency of finding
a leaf page in a tree compared to binary search. The one advantage that sorted record
files hold over the tree-based index is that in a sorted record, the pages can be
allocated according to their order on the physical disk, allowing for much faster
retrieval of several pages in sequential order.

Chapter 9: Disks and Files
============================

9.1 The Memory Hierarchy
-------------------------

The computer has several forms of storage: primary(cache+main memory),
secondary(magnetic disks), and tertiary(tape). Disks are much cheaper
than memory for the same amount of storage, and tapes are much cheaper than
disks.

Memory isn't large enough to store all the data needed in a database, and
can only store as much data as is addressable on the computer(2^32 on systems
with 32-bit addressing).
Furthermore, it is *volatile*(not persistent across sessions). So
we need to use disks despite the fact that disks are much slower
devices.

A *magnetic disk* is a fairly complicated device. Data is stored on the
disk in units called *disk blocks*, a contiguous sequence of bytes. Each
block is arranged in concentric rings called *tracks*, of which there
are multiple per *platter*. The space occupied by tracks with the same diameter
is called a cylinder, since a cylinder is formed by taking the space occupied
by those tracks in each platter. A platter can be double-sided, allowing for
reads and writes to both the top and bottom sides. Each track is divided
into several *sectors* -- the size of a disk block is determined when the disk
is initialized as a multiple of the sector size.

Despite the fact that there is a disk head per recorded surface, all disk heads
move together as a unit. A disk head being over a block means that all other
disk heads will be over the same section of their platters.

There are three sources of overhead that a programmer should be aware of
from disk operations:

1. Seek time: The time it takes for a disk head to reach the track the data
is located on.
2. Rotation time: The time it takes for the track to rotate so the requested
block from the track is underneath the disk head.
3. Transfer time: The time it takes to actually read from the disk block.

Generally seek time is the largest source of overhead from this. This means
that you can achieve significant performance gains by ensuring that when you
are doing a lot of disk reads, the data mostly resides on the same cylinder and
is contiguous.

The unit of data transfer between disk and main memory is a block. If a single
item on a disk block is needed, the entire block is transferred into memory.
The DBMS can only operate on the data once it is in memory.

So now we know that an I/O operation is reading or writing a disk block.

9.2: Skipped
--------------

9.3 Disk Space Management
---------------------------

The *disk space manager* supports operations on pages. The size of a page
is equivalent to the size of a disk block and pages are stored as disk blocks
in order to ensure that reading/writing a page can be done in one disk I/O.

The disk space manager needs to keep track of where blocks are being used
and where they are not, and how much free space is available so that it
can try to find ways to fill in gaps that naturally occur from allocating
and removing pages.

One way of keeping track of this is using a list of free blocks. As blocks
are deallocated, the free list is added to. The list is obtained by following
a known pointer to the first free block. Another way is to maintain a bitmap
that has one bit for each disk block, indicating whether or not it is in use.
This allows for very fast identification and allocation of continuous 
blocks.

9.4 Buffer Manager
--------------------

Useful for handling the common situation of replacing pages in memory
with new data. Uses a replacement policy to determine which page to
replace.

Does some book-keeping on pages, using a *pincount* and a *dirty* bit.
Pincount tracks the number of users of the page(people who have requested
but not released the page). Until the pincount becomes zero, page cannot
be replaced. Dirty bit tracks 