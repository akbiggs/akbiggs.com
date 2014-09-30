CSC443 Lecture 2
==================

With a heap file(which we need to implement for this assignment), there are
several ops we need to support:

1. Scan all records (scan)
2. insert
3. delete
4. update

Recall that with a heap file, we have a directory structure for storing records,
but records are not stored contiguously, they are unordered(stored randomly
across the file).

Since the heap file does not help you find files that satisfy a specific
condition, we want to use an index for that. Recall that in the data structure
for an index, we have data entries for the actual records, with one of three
organizations. EXERCISE: what are those three organizations?

The simplest form of an index is a separate file that has for each value
of a key, we have a record id of each record that has that key value.

The B+ tree is an index that is designed for inserts and deletes that have
very small costs. The simplest form of our index has insertion and deletion
costs > O(1), which is where the B+ tree has an advantage. Each node in the
B+ tree is a page.

Note that it is possible to get search key values in the leafs that are not in
layers above, either through deletion or through certain insertion patterns.

Hash Functions On Keys
----------------------

Since multiple records can be hashed to the same key, in our hash index file
there would be some sort of directory structure linked to each hash value,
e.g. a linked list or some tree or something. h(k) mod M determines the bucket
to put a data entry in, where M is the number of buckets.

However, note that this is a static hash file. The buckets are predetermined
by the values that the hash function can take on. In a lot of situations, we
won't know how many buckets are necessary, and we might need to extend and
add more buckets to our hash. So we need a dynamic hash file that has a way
to grow our hash table and add in new slots.

Extendible Hashing
--------------------

This is done is by choosing a hash function that hashes to a very
large range of binary numbers. As the need arises for more buckets, you extend
the number of digits used by 1, doubling the number of buckets.

We try to keep the directories only containing a single primary page,
and react to overflow by growing the number of buckets. Recall that this does
not mean a single record -- a page can hold much more than one record if the
record size is small, furthermore since our data entries do not need to hold
the record data directly, they can be even smaller.

The old buckets will have zero as the last digit, and the new buckets will have
one as the last digit. We keep track with each bucket the number of digits it uses,
so we can tell whether or not we need to look at the last digit. The new buckets,
until they become used, are pointing to the same directory structures as the
old buckets. We call the number of bits h(r) is currently using the *global depth*,
while the number of bits needed to tell if we hash to a given bucket is called
the *local depth*.

So there's a fair amount of book-keeping going on here to figure out which buckets
are being used with the old (n-1) bit values and which buckets are using the new n
bit values.

One of the disadvantages of this type of hashing is that insertion
becomes very expensive as the hash grows, since insertions can double the number of
pages in use.

We want to be careful with how we handle the situation where a lot of values are
getting hashed into the same bucket. If we keep doubling the number of pages in use
every time we overflow, insertions become very very expensive very quickly. In that
case, we usually want to allow overflow to occur.

So our choice of hash function is also very important. We want to make sure that it's
not skewed, that not too many things are getting grouped in the same bucket. One way
to avoid this issue is to avoid indexing on search keys that have popular values.

Linear Hashing
----------------

In linear hashing, you keep track of a Level value, which says how many times you've
had to change the number of bits. When you overflow, you split round-robin style,
and increment a Next index by one, which says the bucket that should be split
the next time a split needs to be done. When the Next index equals the number of
bits before the splits began happening, we increment the Level value by one and set
Next back to zero.

This way, no bucket takes on a large amount of overflow(assuming a mostly unskewed
hash function).

We can also see LH as a variant of EH, where the number of buckets is doubled gradually.

Sorting
----------

We have one million pages in our DB, and only three that we can hold in our buffer
manager at a time. One way of sorting is we read all the pages, sort each page
individually, write that back out, then read two sorted pages at a time and merge
them together using our third page as a placeholder(need to use write it twice, once
with the first half of the sorted data, then again with the second half of the sorted
data).

However this is very expensive. This two-by-two approach requires 2M * log2(2M) I/O
read/writes. Brutal.

We can avoid this, though. When we do our first pass, our approach instead could be
to bring as many pages at a time as our buffer manager can support(call this amount
of pages B). We can merge B-1 pages at a time, and then write the merged ones back in.

We can also use this time where we're reading in the pages and merging them
to do extra work specified by the query.

Sorting is really useful when you're about to bulk load all of your data into
a B+ tree. Using a B+ tree as your sorting method is extremely expensive, since
you need to go from the root down each time you perform an insert. If you need
to sort your data after the index has already been created, however, it can
be efficient if the B+ tree is clustered.

TODO: Look over merge sorting when applied to sorting pages.

