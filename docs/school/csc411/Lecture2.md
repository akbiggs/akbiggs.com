CSC411 Lecture 2
Regression
=================

1-D Regression
=================

Recall that regression means fitting a model to data.
So in 1D regression, you are matching a curve of values to
a bunch of data points.

The key questions to keep in mind are:
  -How do we parammetrize that model?
  -What loss (objective) function should we use to judge our model?
  i.e. judge how far off our model is from reality.
  -How do we *generalize* our model and its fit to unseen data?

We choose to describe the data D as a bunch of pairs
((x1, t1), (x2, t2), ...) where x is the input feature and t is
the target output. Now we can create new data for given values
of x by making a pair (x, f(x)), where f(x) is our model.

We can use the training examples we're given to construct
a hypothesis, or **function approximator**, that maps x to
predicted y. Then we evaluate this hypothesis on the test set
to see how well it works out. If we leave some data out of our
training examples, we can use the excess data to figure out
how much loss our function has.

There are a few problems that this runs into. We call lack of fit
that results from these problems **noise**:
  - Maybe we don't have enough data.
  - Maybe the input feature or target output is imprecise
  - Maybe we need more attributes

Least-squares Regression
------------------------

For least-squares regression, the standard loss function measures the
squared error in y from x, in other words the squared difference between
our prediction and the objective value.

N = amount of data
w = vector of parameters for our model

J(w) = sum(n=1 to N)[tn - (w0 + (w1)(xn))]^2

How To Optimize
---------------

One straightforward method of minimizing the error, or optimizing
the objective, is to initialize w randomly and then repeatedly minimize
it based on **gradient descent** in J

w <- (update to) w - lambda * derivative of J w.r.t. w

where lambda is the learning rate. The lower the learning rate, the
longer it takes to get to the minimum, leading to smaller changes in
w. The choice of our optimization method and learning rate is very
important, and will be examined in more detail later.

The LMS update rule suggests that for a single training case we adjust
using the error applied to the derivative.

We have two ways of generalizing this:

1. Stochastic / online update: Update params for each training case
in turn, according to that cases own gradients

2. Batch update: sum or average updates across every example i, then
change the parameter values afterwards.

There's an underlying assumption that the sample is independent and
identically distributed(i.i.d.), i.e. the data has no bias. This
assumption is applied to make the math for all these algorithms work.

Non-iterative least-squares regression
---------------------------------------

Instead of examining values case by case, we take the derivatives,
set to zero, and then solve for the parameters.

SOLVE: dJ(w) / dw0 = 0

Useful to work through this and get the expected result.

Minimizing the absolute error
------------------------------

An alternative to the least-squares objective is to try and
minimize the absolute error (sum over n)|tn - (wT)(xn)|.
(What is wT)?
Taking the derivative of this isn't easy, so instead you have
to solve a linear programming problem, which is more time-consuming.

As we will see later though, there are reasons to want to use this
optimization method though.

Multi-Dimensional Input
========================

When we generalize to more than one input, each training case's
x value becomes a vector of x1 to xd, representing each of the input
values.

Essentially we have a polynomial function with x0 = 1, so in the form

y = w0 + w1x1 + w2x2 + ...

We can try to fit a polynomial function to our regression by defining
input vars that are combos of components of x.

Regularized least-squares
-------------------------

Regularization, otherwise known as weight decay, aims to find the
simplest model that fits the data the best. We can modify the
least-squares method to fit this.

