CSC443 Lecture 1
==================

Recall: each table can have a number of attributes.
Some of these attributes can be keys, which means that the
values of those attributes must be unique to a row.

One operation that we do commonly on databases is
iterate over each record and do some kind of operation.

In a systems catalog for a database, we have for each relational
system a file that is used to store data, to make it persist between
sessions. There are in-memory database systems, but they need to write
to disk in order to make sure the data is not lost.

So we need to go through the file in order to perform an operation.
One way to handle managing the file for the relational system is to
bring it all into memory immediately and manage it from there. But
this takes up a large amount of space, so it's unfeasible for larger
records. In general, you do not do this.

The OS handles file I/O by reading it in a page at a time. Recall a page
is a chunk of data, usually some nice power of two kilobytes. So in our
memory for the file, we have a buffer that stores a few pages that we
are currently dealing with. We take a few pages, not the entire file,
and then do the processing.

If we know how many bytes a record in our table takes up, one easy way
of going from record to record is to add the size of our record to the
location of the pointer. We also need to know how much each field in
the record is offset from the base address of the record.

Note however, that this approach **only works** for *fixed length records*.
If we have a field that is a dynamically sized string (varstring), we cannot
use this approach. We can get around this by storing at the beginning of
each field the current size of the field. But this means that when the size
of something gets changed, you need to move data around to make sure that
everything still fits.

One way to work with this is we have pointers to the start of each attribute's
data at the beginning of the data structure for the record, and have pointers
to each record's memory at the beginning of the relational system data structure.
But still, if we update the value of a field to be something different, we have
no guarantee that the space will be free.

By making sure that each record has a unique identifier, we can make sure that
regardless of how things change, it will not affect how other records refer to
that record.

When we do an update, we need to write the page back to disk. As pages are dirtied,
a bit is set, telling the computer to write the page back to disk before it gets
deleted from memory. If the dirty bit isn't set, the page will not need to be written.

Multiple Table Operations
===========================

Suppose we select from two tables where a field is equivalent, and we want to get
an attribute from the first table and a sum of another attribute from the second table.
To handle the selection where the field is equivalent, we can read one record
from the first table in, then read each record from the second table in and process
it. For the ones that match, we can add the output of the data we need into our
output buffer, since we don't need the entire page. When we run out of room for output,
we need to write it back to disk.

Essentially this whole class is about finding clever ways to avoid doing disk operations.
So we really don't want to keep bringing records into memory.

(review physical disks later)

Disk Space Management
=======================

A DBMS imposes an abstraction of records on to regular files. So it has higher level
calls to the file system layer for allocating and de-allocating a page, and requesting
and writing to a single page. The main benefit for sequential data is that it allows
you to request more than one page at a time.

In a DBMS, the data must be in RAM for the DBMS to operate on it.

When a page is requested, a *pin* is placed on it to indicate that it is currently
being operated on. When done, unpinned and the *dirty bit* is used to determine
whether a write is needed. A page in the pool may be requested many times, a pin
count is used to keep track of what's requesting it. A page can be replaced iff
the pincount == 0.

A frame is chosen for replacement by a **replacement policy**. The policy
heavily impacts how many I/O operations are going on. Depends on the
pattern in which pages of accessed, the **access pattern**.

*Sequential flooding* happens when you use the least-recently used replacement
policy and do repeated seuential scans. When you have less buffer frames than
pages in the file, you have to keep replacing pages, meaning every page request
will cause an I/O operation.

Why Not OS?
============

The OS does a lot of these operations already, why not let it take care of things?

By using a separate DBMS, you can gain a lot more power and control over the
pattern in which pages are being used. You can also force things out to disk,
even when it's not strictly necessary, which is useful as will be explained later.

Files of Records
=================

The page abstraction works well when doing I/O, but we need an abstraction
for multiple records, particularly files of records.

We call a File a collection of pages, each containing a collection of records
supporting a few basic operations.

The simplest type of file storage is an **unordered (heap) file**.
Contains records in no particular order. As the file grows and shrinks, disk
pages are allocated and de-allocated. To support record level operations,
need to keep track of # pages in file, # free space, and <SOMETHING ELSE>

Header Page
=============

Level of indirection to data pages. One implementation has a header page
linking to a data page, which links to another data page, and so forth, but
that approach has lots of inefficiencies, so we usually make the header page
just be a list of pointers to data pages, where the data pages are purely data
and have no associated links.

Alternative File Organizations
==============================

There are many alternatives to the heap (random order) files, which are good in some
situations and worse in others.

-Heap files: Suitable when typical access is a scan retrieving all records. Any request
for an individual page has a worst-case of checking everything. Any general record
operations needs to examine every record.
-Sorted file: Best if records need to be retrieved in some order,
-Indexes: Data structures to organize records via trees or hashing. Speed up
searches for a subset of records, based on values in certain ("search key") fields.
Much faster updates than in sorted files.

Indexes
=============

Index on a file speeds up selections on the search key fields for the index(note that
search key is not the same as the key, it's a minimal set of fields that uniquely
identifies a record in a relation)

An index contains a collection of data entries, and supports efficient retrieval of
all data entries k* with a given search key value k. We want to minimize the disk I/Os
for a given data entry from its index.

B+ Tree
===========

The most widely used index. It's a tree with index entries in the upper layer, until
the bottom layer where the data entries are stored and doubly-linked. Data entries
are sorted.

Insert/delete at log_F(N) cost. Keeps the tree height-balanced, where F is the fanout,
and N is the number of leaf pages.

The non-leaf pages have index entries, only used to direct searches.

P0 - K1 - P1 - K2 - P2 - K3

P0 points to pages with key values less than K1. P1 points to pages with key values
between K1 and K2, and so forth.

An insert/delete operation finds the data entry in leaf, and changes it. Requires
occasional adjustment of the parent, and sometimes changes bubble up the tree,
forcing reorganization.

Insertion:
  1. You have a value k, need to figure out where it goes in the data structure.
  2. Find the corresponding leaf L where that value should go.
  3. Insert it regularly if it's not full. Otherwise create a new page and
  split the data half and half. Sometimes splitting half and half can't be done
  without propogating the changes to higher points in the tree.

Deletion:
  1. Start at root, find leaf L where entry belongs. NOTE THAT L IS NOT THE SAME
  AS THE ENTRY, it is the container of all the entries that fit within the range
  given by the index values next to the leaf's pointer.
  2. Wipe the entry. If at least half-full, you're done, otherwise you need to 
  **redistribute**, borrowing from a *sibling* (adjacent node with same parent as L).
  3. If re-distribution fails, **merge** L and sibling. This means deleting an entry
  from the parent of L.

Note that the elaborate merging method is not often used in most DBMSs, since
gaps are usually filled quickly. They often prefer to reconstruct the entire tree in a balanced way when it becomes too sparse.

Prefix Key Compression
=========================

Increases fan-out by minimizing the size of the search key value as much as possible
while maintaining its uniqueness. e.g. with a bunch of names used as the key, you can
just store as many characters as is necessary to make a name unique.

Hash-Based Indexes (Static)
============================

A B+ tree uses a lot of indirection to give you a path towards a page. This can be
sometimes really annoying.

A hash index instead just hashes the search key value, so with one level of indirection
you can find a collection of pages that are what you want.

The index in this case is a collection of buckets, where each bucket is a 
**primary page** plus zero or more **overflow pages**. Buckets contain data entries.

The hashing function h(r) determines which bucket the data entry for record r belongs
in. h looks at the search key fields of r, so there's no need for index entries.

Data Entry Storage in Index
============================

We have a few alternatives for how we store a data entry k* in an index.

1. Data record with key value k. This means that your entries in the index will be
very large, requiring a very large number of pages for storage and drastically
expanding the size of the tree.
2. (k, RID of data record with search key value k)
3. (k, list of RIDs of data records with search key value k). In both of these
other two alternatives, you have much smaller data entries. Alternative 3 is
more compact than Alternative, but leads to variable sized data entries even if
the search keys are of a fixed length, requiring manual searching or other
alternatives as discussed earlier with data storage for records.

This choice is independent of your method of indexing.

Index Classification
======================

Primary vs. secondary: if search key contains primary key, called primary index.

Clustered vs. unclustered (*more important*): If the order of the data entries in
the index is similar to the organization of the data entries in memory on pages, 
then it's considered clustered. If it's all over the place, then it is considered
unclustered. You want clustered as much as possible, but note that since the values
of the index affect heavily the layout of the B+ tree, you can only make one index
clustered at once, so this is why you might want to use an unclustered tree.
