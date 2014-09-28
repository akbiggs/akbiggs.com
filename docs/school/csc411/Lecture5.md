CSC411 Lecture 5
=================

Recall
----------

We replace the sign function with the sigmoid or
logistic function so that the result is no longer
a flat zero or one value, but is instead a range from
0 to 1 that spikes sharply at the boundary. This way
we have more feedback and the function is easier to
optimize.

y(x) = sigma(wTx + w0)

where sigma(z) = 1 / (1 + exp(-z))

We use this to calculate the probability that a value will
fall into a certain class in our classification problem.

P(C = 0 | x) = 1 / ( 1 +  exp(-wTx - w0))
P(C = 1 | x) = 1 - P(C = 0 | x)

How do these two functions relate? With plotting we can see that
as one function goes up, the other goes down, and vice-versa,
and that one is high after the boundary while the other is low.

Changing the value of wT stretches the function, while changing the
value of w0 shifts it.

When calculating the boundary, intuitively we try to minimize the
sums of the losses between both of these classifications.

i = index of current data point we're looking at

j = current dimension that we're looking to minimize

xi,j from here on will mean the jth coordinate of the ith data point

Recall regularization penalizes more complex models, to avoid overfitting.

With regularization applied to our model, we can try to estimate
the posterior p(w|{t},{x}), which approximates p({t}|{x},w) p(w).
Helps to keep our model simpler. We call this function p(w) the prior.

Cross-Validation
------------------

A method that we can use to optimize *hyperparameters*, which are parameters
that are not part of the data or components but which we still need to set.

In leave-p-out cross-validation, we use p obvs as the validation set and 
the remaining as the training set. Repeated in all possible combos to cut
the original training set. Very bad performance.

In leave-1-out, we set p to one, and it avoids the computation bottleneck.

In k-fold, we randomly partition the training set into k equal size subsamples.
Each subsample is used with 1 as the validation and the remaining k-1 as the
training, and this whole process is repeated k times. Results are averaged
to obtain an estimate.

Metrics
-----------

We need a way to validate the classifier and suggest how good it is. This
isn't really a way of learning, it's just a way of validating.

In *Precision* checking, we get the fraction of retrieved instances that are
relevant, i.e. how many we get right. P = TP / (TP + FN) = TP / P.

In *Recall* checking, we get the fraction of relevant instances that are
retrieved, i.e. how many of the total amount of right ones we get. R = TP / TP + FP

The *F1 Score* harmonizes the two. F1 = 2((P dot R) / (P + R))

Generally, as the recall increases, the precision decreases. **Average Precision
(AP)** is the mean under the curve.

Nearest Neighbours
====================

Different type of classifier. Non-parametric; no longer has a linear set of
coefficients that we operate on.

Instance-Based Learning
-------------------------

Alternative to the parametric mode. We use the distances from other instance
data to approximate the class that it should fall into.

Makes two assumptions:

1. Output varies smoothly with input.
2. There's data in all the spaces we'll be examining.
