CSC411 Tutorial 2
====================

Optimization
===================

In an optimization problem, our method of solving the
problem will vary depending on the assumptions that we
are choosing to make.

1. Is theta (the variable being optimized) discrete or
continuous?
2. What is the domain of theta?
3. What constraints can we put on it?

In machine learning, the theta we are solving for is
the collection of params of the model.

For example, with the data (x, y), we might want to
maximize P(y|x,theta). Equivalently, we can minimize
- log P(y|x, theta).

Minimization
--------------

From Calculus, we know that the minimum of f must
be at a point where the partial of f w.r.t. theta
= 0, in other words, where the slope of the function
is zero. Since we might be dealing with more than one
dimension of slope, we want the entire slope to be
zero.

Recall that the gradient is the partial derivative
of f with respect to each parameter x1, x2, x3, etc.,
so it's a vector.

Gradient Descent
-----------------

Gradient descent is just the idea of adjusting the
gradient of our model w.r.t. theta in an attempt to
maximize the accuracy of our model for finding
the correct value for y given x and theta.

Convexity
-----------

Convexity is the property that if we draw a line between
any two points in the function, the function will always
be below that line between the two points. As long
as we have this property with our model, we will know that a
local minimum/maximum will be the absolute minimum/maximum.