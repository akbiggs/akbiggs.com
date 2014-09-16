CSC411 Lecture 3
=================

In a classification problem, we are interested in mapping the input x in X
to some label y in Y. A label could be really anything, but it has to be some
kind of category. So we're assigning categories to data. In regression, typically
Y = R, but in classification it's a category, so some kind of discrete set.

Getting good performance in machine learning is figuring out how to extract
good features that can be easily classified.	

In classification, you can't really use what we've learned in the previous lectures.
A regression ignoring that the input is categorical runs into a number of issues.
You don't have a clean solution for how values between the discrete values in Y
should be rounded around. The labels are also not ordered data, compared to the data
in R.

(Aside: intuition for *overfitting*: you're overfitting if your model is so specific
to the training examples that it poorly fits new ones)

A *decision rule* in classification determines how your *classifier* gets mapped
on to different categories, i.e. determines the value of category a new value should
take on based on where it falls.

A *linear classifier* has a linear boundary w0 + wTx = 0 which separates the space into two "half-spaces". It is used for binary category problems.

Intuitively, looking at the equation wTx + w0 = 0, with wTx = 0 we have a line passing
through the origin orthogonal to w. In wTx + w0 = 0, we have that line shifted by w0.

Choice of Decision Boundary
-----------------------------

Learning consists in estimating a "good" decision boundary. We need to find w
(direction) and w0 (location) of the boundary.

But first, we need to figure out what "good" means.

Classifying a linear decision boundary reduces the data dimension to 1,
i.e. y(x) = sign(w0 + wTx).

The cost of being wrong with your decision boundary is very domain-specific.
You need to weigh more towards false positives or false negatives depending
on what your needs are.

Loss Functions
----------------

L(y, t) is the loss incurred for predicting y when the correct answer is t.

We need to figure out what loss functions we have available to us so we can
choose an appropriate one.

L[0-1](y(x, t)) = {0 if y(x) =t, 1 otherwise}

LABL(y(x), t) = {alpha if y(x) = 1 and t = 0, beta if y(x) = 0 and t = 1, 0 if y(x) = t}

Lsquared(y(x), t) = (t - y(x))^2

Lquadratic(y(x), t) = |t - y(x)|

There are a few more complex loss functions for different situations.
e.g. when movie predictions are used for rankings, the predicted ratings don't
matter, just the order that is implied by those.

So we have a few more possibilities: 0-1 loss on the winner, permutation distance
(get different simulated rankings, get real rankings, get distance between each
value in rankings).
