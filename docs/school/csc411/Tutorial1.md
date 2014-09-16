CSC411 Tutorial 1
==================

Notation for probability:

Random var X represents outcomes or states of the world.

p(x) means the probability that X = x.

Sample space is the space of all possible outcomes. Could be
discrete, continuous, or mixed.

p(x) is the probability mass, or density function. It just
assigns a number to each value of X, each state, meaning how
likely that state is to occur.

Rules
--------

Sum rule: p(x) = sum over all values of y of p(x, y)
          p(x1) = sum x2 (sum x3 (sum x4 ... p(x1, x2, x3, ..., xn)))

Chain rule: P(x) = P(x|y)P(y)

Bayes' Rule: p(x|y) = (p(y|x)p(y)) / p(x)

Gives you a way of "reversing" conditional probabilities.

Independence
------------

Two r.v.s are said to **independent* iff their joint distribution
factors p(x,y) = p(x)p(y). This means p(x) = p(x|y) and p(y) = p(y|x)

Two r.v.s. are **conditionally independent** given a third r.v.
iff p(x,y|z) = 

Continuous R.V.s
-----------------

Outcomes are real values. The probability density functions define the
distribution of those outcomes.

The probability mass in [a,b] is given by the integral from a to b
of the probability density function.

Summarizing
-------------

Often useful to give summaries of distribution without defining whole
distribution.

Mean: integral over x of (x dot p(x) dx)
Variance: integral (x^2*f(x) dx) - mu^2 

Recall Bernouli distribution = p(x | mu) = mu^x * (1 - mu)^(1-x), where
mu is the probability of flipping heads.

Multinomial distribution: X in {1, 2, ..., K}
p(x1, x2, ..., x_K | mu) = product from k=1 to K of (mu_k ^ x_k)
p(X = k | mu) = mu_k
For a single observation, considered a die toss.
Marginal distribution: p(x_k | mu) = mu_k ^ x_k * (1 - mu_k) ^ (1 - x_k)
Mean of x_k: mu_k
Variance of x_k: mu_k * (1 - mu_k)

Normal (Gaussian) Distribution: 
	p(x | mu, sigma) = 
		(1 / (sqrt(2pi)*sigma) * exp (- (1 / 2sigma^2) * (x - mu)^2)

When you deal with multiple input variables, the formula changes to
the multivariate distribution.

If we're given the variance of some data D with a Gaussian distribution,
we can estimate the mean using a likelihood function.

This is the p(D|mu) = product from i=1 to N of p(x^i | mu, sigma)

We want to maximize this expression (the value that is most likely to
occur). To do this, we take the log of the expression, use basic
calculus to differentiate w.r.t. mu, set derivative to 0, and then
solve for the **sample mean**.

