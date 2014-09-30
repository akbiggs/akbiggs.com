CSC411 Lecture 6
====================

Nearest Neighbors
------------------

With a Nearest Neighbor algorithm for finding classifications,
we don't have explicit decision boundaries, but we can infer them.

In k Nearest Neighbors, k determines how many neighbours we look at
for the majority vote of how to classify a given point.

We basically group things into classes based on the class of the point
that they are closest to. This means that the boundary between classes
occurs when a point is equidistant from points of different classes.
We don't need to take all such points to form the boundary, only the
exterior edges.

This method doesn't work well and is very expensive when we're dealing
with classes that dwarf the other classes in terms of data.

A few problems with k Nearest Neighbours approach:

1. Some attributes have larger ranges, leading to them being treated as more
important, so we need to normalize the scale. Not a good idea if the attribute
is supposed to be treated as more important.

2. Some attributes are irrelevant to the situation, e.g. the wrong kinds of
medical tests. These attributes add noise to the distance measure. This
means we need to remove attributes, or vary the weight on those attributes.

3. Some attributes aren't metric data, they're categories. In this case, we
might want to use a distance besides Euclidean distance, e.g. Hamming distance
which assigns values to each category.

4. Very expensive. To reduce the computational burden, you can use a subset
of the provided dimensions, or a subset of examples, by removing the ones
that lie within the Voronoi region or by making an efficient search tree that
only looks for the boundaries that we care about.

Decision Trees
----------------

One way that we can think of a more complex boundary is as a composition
of a bunch of simple AABB boundaries. To check which box we fall into, we
construct a tree that checks different conditions to group us into a set of
boxes. When we've limited ourselves down to a single box, we've found
the group that we fall into.

How do we determine the thresholds between the boxes? You need to find some
sort of measure, a cost function that determines how effective a given leaf
(box) in your decision tree is for grouping things.

To construct a decision tree, we need to apply some information theory. We
can rely on the entropy of the data to gain some intuition about how the
data is distributed around.

H(X) = - sum over all x in X of (p(x) log2(p(x)))

Tells us how uncertain we are about a distribution. We want lower entropy
when constructing a decision tree, so it's easier to predict what a value will
be.