CSC411 Tutorial 3
===================

Cross-Validation
-----------------

We do cross-validation to estimate the performance of our
model, in terms of its error rate. We use an additional
dataset for tests that we try our model on after we've trained it
using the training set.

In cross-validation, we have three types:

1. random subsampling, where we take a random subsample of size n of our dataset
and compare that to our model
2. k-fold cross validation, where we split the data across several experiments
and average the errors.
3. leave-1-out cross validation, which is the same as random subsampling but
n = 1.

Intense use of cross-validation can overfit, so we can hold an additional
dataset for testing that we don't use during validation, and only use it to
confirm the best model can adapt. It can also be very time-consuming.

k-Nearest Neighbours
---------------------

Classification method that figures out class of a point by examining k nearby points.
If k = 1, then it classifies based on the nearest point, otherwise averages the
class values of k nearest points and sets the class to be the one that's nearest
to that averaged value. To avoid ties, k is usually odd.

Decision Tree
--------------

Recall that a decision tree aims to classify a point by guiding down a tree,
checking various conditions of a point. Creates a more complex boundary from
several rectangles.

Also recall that entropy E(S) = -P+log2(P+) - P-log2(P-), in other words the
positive examples and the negative examples logged and kinda added together.

When constructing the decision tree for categorical data, we can just partition
our data based on the different attributes that affect our end classification,
until we end up with a set of data in the leaf that all has the same class.

There are a few things we need to watch out for. If the decision tree has incorrect
data, we'll overfit.

Look up two types of pruning for the decision tree: [reduced-error pruning](http://en.wikipedia.org/wiki/Pruning_(decision_trees)#Reduced_error_pruning) and
[rule post-pruning](http://jmvidal.cse.sc.edu/talks/decisiontrees/rulepostprun.xml)
