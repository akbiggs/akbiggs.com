CSC443 Lecture 3
=================

Recall
-----------

We have a few methods that we can use to handle sorting pages
in a database. One method is that we create a bunch of sorted
runs of length B, where B is the number of pages we can hold in
memory at once, and then do a second pass that organizes pages
between those sorted runs. Can merge B-1 pages at a time.

Another approach is that when we create our sorted runs, we write
things out one page at a time, read in another page to fill in the
slots that were emptied, and then(while keeping track of the values
that we just wrote out) read in another page, sort out the data,
and write out another page that has values >= the last value in the
page that was just written.

e.g.

```
[1 2 3] [4 5 6] [7 8 9] -> []
[1 2 4] [4 5 6] [7 8 9] -> [1 2 3]
[1 2  ] [    6] [7 8 9] -> [1 2 3] [4 4 5]
[1 2 1] [1 1 6] [7 8 9] -> [1 2 3] [4 4 5]
[1 2 1] [1 1  ] [    9] -> [1 2 3] [4 4 5] [6 7 8]
```

and so forth until you can longer continue running like this.
On average, assuming randomly distributed data, gives runs
of size 2B. 

Joins
--------

# pages R = M, PR tuples per page R

# pages S = N, PS tuples per page S

need to evaluate the query:

```
SELECT *
FROM R, S
WHERE R.A = S.B
```

The *nested loop* approach advocates going over every page in S
for every page in R, and comparing all the tuples in these pages.
Costs (M)(N) + M reads. The (M)(N) comes from reading each of S'
pages M times. Very inefficient.

We can optimize it by reading in the pages sequentially using
our buffer pages, reducing the amount of reads to M + ((M)(N))/(B-1).
We can also get that down to (B-2) somehow. Also, if 3B = M,
then this is about M + N. Pretty sweet; this is called a *block nested
loop*.

But we can do even better using an index to avoid having to 
scan over the entirety of S to figure out which records match up with
other records. Then our algorithm becomes probing the index on S.B
on R.A for each tuple of R, for each page of R. We need to go down
the tree every time we probe for an index value. So the cost becomes
M + (M)(PR), PR being the time to index probe.	

The time to index probe is a bit more difficult to figure out.
It depends on a number of factors: the height of the tree, whether
or not the tree is clustered, and the *selectivity* s of the tree.
Selectivity is a property that expresses the average number of pages
it takes to fit a value of the attribute being indexed, i.e. how
common the value in the index is.

So in a clustered tree, this requires h + r reads, where h is the height
of the tree and r is s / # tuples per page. In an unclustered tree,
this is h + s.

In a perfect (no collisions) hash index, this requires 1 page read.
In a clustered one with collisions, it requires 2 + r reads, and an
unclustered one requires 2 + s.

To calculate the selectivity, calculate the cardinality (number of unique
values), divide it by the number of records being dealt with, and multiply
it by 100%.

Sort-Merge
------------

The *sort-merge* algorithm sorts R on A,
sorts S on B, and then merges them together by keeping
a pointer to the current location on both, advancing R when S
is greater and vice-versa. Costs 2MlogB(M) + 2NlogB(N) reads,
plus N + M to do the merges.

Say R gets sorted into 4 runs, and S gets sorted into 5 runs.
Then we can use our advancing pointer algorithm on each run, 
and just handle the merging on one loop, i.e. keep 9 pointers.

Hash Join
------------

Similar to sort merge, but you use a hash instead of sorting,
resulting in things that should be grouped together getting
placed into the same bucket.

We create B - 1 buckets, and use a hash function h to write
a page from R out to those buckets. When a bucket page becomes full,
we wrte it out to to disk sequentially with the rest of the pages
written from that bucket. Assuming a perfect hash function, creates
M / B - 1 runs of pages for R. Each of these pages will end up going next
to each other in the end, so you just need to sort those bucket pages
and then place each bucket into the right locations.

We do the same to S.

If we can fit *all* the buckets of R into memory, then we can do
some kind of comparison sort method similar to the nested loop by
reading a page from S's bucket and sorting it. If we can't fit them,
however, we need to hash things again in order to figure out where
the buckets should go relative to each other before we can write them
back to disk. This is done using a separate hash function h2, that operates
on buckets as opposed to individual values.

Caveats
------------

Inequality conditions can't be done using Hash Join and Sorted
Merge Join. The former is because a hash doesn't help you with
finding values that are less than another value, while the latter
requires rolling the pointer back to the beginning of S every time
you find a record in R that satisfies the inequality condition.

Index NL can do it, but requires a clustered B+ tree index.
Block NL is the best choice.

When we're doing AND and OR operations, we need to be careful about
our choice of indices. Some indices will organize the data in a
way that really hurts handling inequality conditions.

