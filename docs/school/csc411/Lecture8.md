CSC411 Lecture 8
-------------------

Randomizing Weights
--------------------

You want to randomize the weights you start with when you're doing machine learning
because you don't want your results to be biased by being next to a local optimum.
You need to make sure your model can adapt to lots of new data with different values
usually, not a specific subset of that data.

Multi-Class Logistic Regression
-----------------------------------

When we have multiple classes, we change the way we determine the probability:

```p(T|x1, ..., xn) = product(n=1, N, product(k=1, K, p(Ck|xn)^tnk))```

We can then derive the loss by computing the negative log-likelihood between
two distributions.

```E(w1, ..., wk) = - sum over n, k, (tnk)(log(ynk, xn))```

To train on this, we do gradient descent again, with derivatives on each ynj
w.r.t. znk, and dE w.r.t. znk.

One way to think about our situation is that we have a bunch of nodes for each
value of x, and we connect to values of y using weights for each value of x
and class of y. Our values of y are a function of our weights and values of x.

Now with this idea in hand, we can handle different multi-class problems. With
K-NN with multiple classes, we can generalize to color in different areas surrounding
points based on the class that each point should take on.

In a decision tree, we still aim to find leafs that have elements of just one class,
using divisions based on attribute values.

Generative Models For Classification
========================================

Sometimes, we don't know what classes exist for the data we've been given. We need
to figure out how to create different classes for data based on its distribution.
We build a model for the input data x and for a given class C, and end up building
a model for the input data and *every* class C.

Recall: Bayes' Rule follows the form p(C|X) = p(X|C)p(C) / p(x)

We can think of the top as the conditional likelihood of x given C times what we know
about C without any data(the *prior*) / the probability of different values of x
occuring without any information.

To take our data and determine from it how we might create and divide classes. One
way of doing this is by averaging things into different bins based on their values.
But the main way of doing this is by generalizing the data by fitting a distribution
to it.

To do this, we need to figure out what our model will be, and what the model
parameters will be to accurately portray the distribution of each of the classes.
The model is chosen based on the distribution of the data -- for the most part we'll
be picking the Gaussian.

We can compute the mean and variance from the distribution of the data assuming
it's i.i.d. and fits a distribution. We do this using standard algebra
problem solving techniques to isolate mu and sigma.