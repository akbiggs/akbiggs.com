CSC443 Lecture 4
==================

Query Optimization
--------------------

Suppose we have the following query

```
Reserves[bid, sid, date]
Sailors[sid, sname, rating, club]

select date
from R,S
where R.sid = S.sid and S.rating > 10 and club = 'UT' and date >= 1/1/14
```

We could just join the R tuples with the S tuples using a Block-Nested Loop,
filter out the resulting tuples, and then project for the date. But this is
really expensive: the BNL costs N + MN / B I/O operations, and then the rest of
the operations have to be done on the fly. If we know the sizes of N and M,
which we do, we can test other plans and estimate their costs in comparison,
choosing the one which works best.

Alternative plans would be to do the selections on R and S first, then the
natural join, and then do the projection.

In order to compute the costs of the selections, you need to know a bit of info
about the distribution of the data and the type of tables you're operating on.
You need to know how many distinct values there are for each selection field,
and also how frequently those values occur. Knowing what indexes there are lets
you do selections on > and < clauses much more efficiently if you have a B+ tree,
and equality comparisons efficiently if you have a hash index.

So the selectivity of your data and the types of indexes that are used greatly
affects the results that you get back.

Recall that with an index on multiple keys, the key that comes first is sorted,
then each thing with the same values of that key is sorted by the next key,
and so forth. So order is very important.

How do we store the intermediate results from the query? If we have enough memory
to store the number of records returned from the selections on R and S, then we
can just do that. But if we don't, we need to do something called *materialization* to store the intermediate result back on to disk.

We also have to accomodate for the current state of the data at the time that we
execute the query. For example, a sort merge during a join will go much faster if
the data is already sorted.

Stuff becomes super crazy when you get into joining multiple relations. You have
to test each order of joins and order of operations to figure out which one
optimizes ones the most.