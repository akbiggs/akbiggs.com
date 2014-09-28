Test 1 Practice
================

Question 1
------------------

1. A relation must have a clustered index on its primary key: F
2. If R.B is a (non-null) foreign key referencing S.B, then the number of tuples in R[A, B] nj S[B, C] is T(R) (that is, the number of tuples in R): T
3. Using a nested loop join, R nj S = S nj R: T
4. A sort-merge join is always more efficient than an index join: F
5. To process the query select where A < 2 from R, a plan that uses a B+ tree index
will be faster than a plan that scans the entire heapfile containing R: F
6. A heap file that uses a variable length record format does not permit records
to be updated: F
7. Math heap join stuff: F, in the worst-case R the field to join on has the
same value everywhere, and then we need to do multiple passes on the data.

Question 2
----------------

R = 50
F = 100
PEmp = 1000000 / 50 = 20000
PDept = 500 / 50 = 10
sortEmp = 22000
sortDept = 30
B = 4

Types of joins available: nested loop, index-nested loop, sort-merge

1. Given a clustered B+ index on Emp.Dept and an unclustered B+ index on Dept.Name,
describe the lowest cost join plan (and estimate its I/O cost).

--------

Lowest cost join plan would be to run an index-nested loop join on Dept with
Emp(to make sure that the index probing is done on the clustered tree). The
cost of this would be N + M * PR, the cost of index probing on M. The height
of the tree is logF(20000) ~= 2.15, let's say 3 in the worst-case. So the
time to index probe is , where s, the selectivity, is 100%.

Question 3
------------

The goal of a record id is to uniquely identify a record. A simple record id format
is the pair(pid, owp), where pid is the id of the page in which the record is
stored, and owp is the byte offset of the record within that page. However, instead
of using the above simple record id format, most systems use the more complex
(pid, slot number) format for record ids. Why?

1. Easier maintenance(if the offset of the record changes, the id doesn't have to)
2. Easier to check immediately if a record is empty or taken for insertion by seeking to its slot

Question 4
------------

You are given 1001 buffer pages and asked to sort a heap file with 1,000,000,000
pages. What is the I/O cost to sort the file using a 1000-way merge sort? Your
answer should include the cost of creating the sorted runs in Pass 0. You can assume
that Pass 0 produces runs of length (on average) 2000 pages. Does your answer depend
on whether the original file uses fixed or variable length records?

2N * (1 + log(1000, 1000000000 / 1001)) = 2 * 1000000000 * (1 + 2)
								= 6000000000

---------

First pass produces around 500k sorted runs of average length 2000 pages.
Second pass produces 500000 / 1000 = 500 sorted runs of average length
2000000. Then since we have more buffer pages than sorted runs, we can merge
the remaining data in 1B I/O ops.

Question 5
--------------

Consider the natural join of the two relations R(A,B) and S(B,C). Relation R has
attributes A and B, and relation S has attributes B and C. Attribute A is a key for
relation R. Attribute B is a key for relation S. No foreign keys are declared on
either relation. You are given the following information about the two relations:

1. Relation R contains 10,000 tuples and has 100 tuples per page

2. Relation S contains 5,000 tuples and has 10 tuples per page.

3. There is a clustered linear hash index on S.B.

4. You have 22 buffer pages available

What is the cost of joining R and S using a hash join? The cost should be given in a
single whole number. How does this cost change if B is not a key for S?

--------

3(100 + 500) = 1800. If B is not a key for S, then there's a possibility that there
won't be enough room to fit a partition of S into memory, in which case a BNL join
is required.

Question 6
---------------

Consider an extendible hashing index with a directory containing two
entries (for 0 and for 1), so the global depth is 1. The directory entry for 0
points to Bucket A containing a single data entry 0', and the entry for 1 points to
Bucket B containing a single data entry 1'. Both buckets have local depth of 1.

What is the minimum number of data insertions (assuming no deletions) into this
index such that the final index structure has a directory size of eight. Write down
such a sequence of data insertions. You should also draw the final index structure 
after the insertions (including the directory, buckets, hash entries, local depths
and global depth). You can assume that each bucket can hold at most two data
entries.

