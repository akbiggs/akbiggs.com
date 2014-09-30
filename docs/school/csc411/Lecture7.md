CSC411 Lecture 7
==================

Recall that in a decision tree, we break complex boundaries into simple
boundaries, and choose which boundary we're in by checking a few simple
conditions, going down the tree.

We need to figure out how to make such a tree, what values we pick and what
attributes we narrow down for distinguishing between the paths on the tree.

Entropy
----------

One way that we figure this out is by examining the entropy of the distribution
of our data. This tells us how surprised we are to see new values in a sequence.
It basically measures the spread of our data.

To calculate the entropy of a joint distribution, H(x, y), we take
the ```- sum over all values of x of the (- sum over all values of y of
p(x,y)log2(p(x,y)))```

If one of the variables is given, we plug in that variable and then
sum over the other. This gives us the conditional entropy for that specific
value

e.g. ```H(X|Y=y) = - sum over x in X of (p(x | y)log2(p(x | y)))```

Expected (Non-Specific) Conditional Entropy
----------------------------

```H(X|Y) = sum over y in Y of p(y)H(X|Y=y)```

It's the sum over all of the possible outcomes of our conditional entropies.

Tells us what the entropy is of a random variable is with regards to all the
things that it is conditionally dependent on. We can see this as a measure of
how much impact one variable has on another variable.

Information Gain
----------------

```IG(X|Y) = H(X) - H(X|Y)```

This is referred to as the **information gain** in X due to Y.

Constructing Our Decision Tree
--------------------------------

The optimal decision tree algorithm is NP-hard. So we're going to aim for
a simple approximation. Our first approach will be a simple, greedy approach,
where we build up the tree node-by-node. Steps:

1. Pick an attr to split at a non-terminal node
2. Split into groups based on that attr's values
3. Measure the entropies of those groups to figure out which attribute gives
us the most entropy. Won't give us the optimal solution, but it's something
that we know how to measure and works reasonably well for splitting up our data.

Evaluating A Decision Tree
----------------------------

Needs to be small, but not too small. The tree needs to distinguish your data
sufficiently well.

However, also has to be not too big, to avoid computational complexity and to
avoid overfitting.

We generally want to apply Occam's Razor: go for the simplest hypothesis.

Problems:

1. Exponentially less useful at lower levels
2. Too big a tree can overfit
3. Greedy algorithms don't yield optimum

We often get around this by reguarizing the construction process.

Comparison with KNN
--------------------

In KNN, we have piece-wise DBs, whereas in DTs we have axis-aligned,
tree-structured boxes.

Multi-Class Classification
============================

One way that we can classify multiple class data is to have K - 1 classifiers,
each solving a two class problem of separating the class CK from points not in
that class. Called the **1 vs all** algorithm.

However, this means that there is more than one good answer where your classes
collide.

So instead we introduce two-way classifiers, one for each possible pair of
classes. Points are classified according to majority vote among these functions.
This is called the **1 vs 1 classifier**. However, it might not classify all
the space(two way relations aren't transitive(?)).

We get around this by making K functions and K weights, and classifying based
on the max.
