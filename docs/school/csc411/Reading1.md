CSC411 Reading 1
================
	
RL (Reinforced Learning) is a type of machine learning that
takes place over a series of steps leading to a payoff result.

The job of an RL system is to define a reinforcement function,
a mapping from state/action pairs to reinforcements (a scalar
value determing the value of taking that action). State starts
at an initial state and the goal is to reach a terminal state
while maximizing reinforcement.

Reinforcement Function Classes
----------

There are three main classes of reinforcement functions:

1. Pure Delayed Reward and Avoidance Problems

- reinforcement is always zero except at the terminal(payoff)
state.
- sign of the scalar value at the terminal state determines
whether the goal state is a reward (positive) or something
to avoid (negative).
- causes the agent to naturally avoid states that result
in a loss and aim for states that result in a win.
- e.g. backgammon has a state where you have purely lost and
a state where you have purely won.

2. Minimum Time To Goal

- makes agent perform actions that minimize the time to
reach a goal state.
- e.g. car on the hill, assign -1 to all state/action pairs
except for ones that bring the car closer to the top of the
hill via movement.

3. Games

- state involves two players opposing each other. Ultimately
ends up choosing actions that are the best for the player in
a worst-case scenario.

Choosing Actions: The Value Function
----------------

Policy: determines which actions are associated with which states.

Value: sum of reinforcements for a given state received when starting
in that state and following a fixed policy to a terminal state.

Optimal policy is mapping states to actions such that the
reinforcement is maximized when starting in some arbitrary state and
following a fixed policy to the terminal state. So the value of a
state will be dependent on the choice of the policy.

The *value function* is a mapping from state to state values. It can
be approximated using a function approximator. e.g. if you have a
policy that is non-deterministic, the value of a state might be the
average reinforcement gained from using that policy to reach a goal
state.

Choosing the optimal policy given the optimal value function is easy:
you just take the action that maximizes the amount of reinforcement
gained, since the value is based off of the sum of reinforcements to
reach a goal state.

Approximating the Optimal Value Function
----------------------------------------

To teach the system from its mistakes, we use two principles from
**dynamic programming**.

1. When the system makes an action that leads to a losing state,
never do that action again.
2. If all actions in certain situations lead to bad results, avoid
that situation.

When we start, our value function V(xt) is mostly random. We
perform actions and try to adjust V(xt) to get as close as possible
to V'(xt), the optimal value function, in order to develop an
optimal policy.

So V(xt) is initially equal to the optimal value function plus some
error in the approximation e(xt). V(xt) = V'(xt) + e(xt).

Using maths and the idea that V(xt) = r(xt) + y V(x(t+1)),
we can derive that e(xt) = y e(x(t+1)), where y is a decay factor
from 0 to 1 used to place more importance on immediate reinforcement
vs. future reinforcement.

Value Iteration
-----------------

In value iteration, we do many sweeps over the state space,
performing all possible actions on a given state and adjusting
our approximate value function based on the difference between the
max amount of reinforcement we can get from any action in
that state and the current approximate value for that state. Note
that this value is just the error for the approximate value function
on that state.

Residual Gradient Algorithms
----------------------------

Since we can only construct a lookup table when the state and action
space is very small, it's not practical for most situations. Instead,
we can use a formula that derives the approximate value and adjusts
the parameters for the algorithm accordingly for previously unknown
states.

Bishop
==========

Chapter 1
--------------

In machine learning, a set of data {x1 ... xn} called the *training
set* is used to tune an adaptive model that tries to find the correct values
of some parameters in a *target vector* t.

For a lot of practical applications, the data is pre-processed into some
new space of variables where it is hoped that the problem will be easier
to solve. This pre-processing stage is sometimes also called *feature
extraction*.

If a machine learning algorithm has training data that maps input to the
expected output, then the application is considered a *supervised learning*
problem. There are two types of supervised learning problems: *classification*
problems, where the aim is to assign each input vector to one of a few discrete
categories, and *regression* problems, where the output is a continuous
variable.

Alternatively, if no target values are provided, then it is considered
*unsupervised learning*. If the goal is to discover groups of similar
data, then the application is called *clustering*. If the goal is
to determine the distribution of the data, then it is called *density
estimation*. If the goal is to project the data from a high-dimensional
space down to two or three dimensions, then it is called *visualization*.

Finally, *reinforcement learning* is concerned with finding a list
of suitable actions to take over time to maximize some kind of reward,
known as the *payoff*.

Polynomial Curve Fitting
-------------------------

A simple regression problem. Suppose we have some data over x with values
for some field t. We have N observations of x, written as x = (x1 ... xN)T
(recall T means transposed), together with corresponding observations of
the values of t, denoted t = (t1 ... tN)T.

Our goal with this kind of problem is to be able to make predictions for
the values t shall take on given some new input data x*. One easy way of
doing this is to fit some polynomial curve to the data as a function of x,
so we can just feed in the new value of x and get back the expected value
of t. We express this idea as 
	y(x, w) = w0 + w1x + w2x^2 + ... wMx^M 
			= sum from j=0 to M of (wj * x^j)

where M is the order of the polynomial
      w is the vector of polynomial coefficients

Note that although M is non-linear w.r.t. x, it is linear w.r.t. the
coefficients w.

We can determine the values of these coefficients by fitting the polynomial
to the training data. The easiest way to do this is to minimize the value
of an *error function*, which computes the difference between our polynomial
for a value of w and the training set data points. A simple and widely used
error function is the sum of squares of errors between the predictions
y(xn, w) for each data point xn and the corresponding target values tn.
i.e. minimize

E(w) = 1/2 * (sum from n=1 to N of ((y(xn, w) - tn))^2))

The 1/2 is included for later convenience.

Note that this is a non-negative quantity that would only be zero if
the function y(x, w) were to pass exactly through each training point
data. This means finding a solution to the equation E(w) = 0 is equivalent
to finding our target estimated polynomial curve. There is only one unique
solution for the coefficients, since the derivative of the polynomial curve
is linear w.r.t. w. In other words, there is only one such polynomial curve.

We also need to choose the order M of the polynomial. If we choose an order
that is too low, the resulting polynomial is a poor fit to the data and
does not accurately show how the data changes as x changes. This is
*underfitting*. If we choose an order that is too high, the resulting
polynomial is very complicated, oscillating wildly and also poorly
representing how the data changes. This is called *overfitting*.

One way of evaluating the fit of our choice of polynomial is to
have a separate data set of extra test cases outside the ones used
in the creation of the error function. Then we can take the root-mean
squared error, ERMS = sqrt(2E(w*)/N). The division by N accomodates for
the different sizes of data sets, and the square root makes sure that
the error is measured on the same scale as t. ERMS w.r.t. the
extra test cases determines how good our polynomial is at adapting
to new test cases.

The reason why overfitting happens is that the polynomial is "tuned"
to the variability of a relatively small number of test cases. As the
number of test cases increases, the polynomial becomes a closer fit
to the data. So one way of seeing the choice of order is that the complexity
of the model should reflect the size of the data set.

Regularization
----------------

There are many cases where we want complex models to work with
small amounts of data without overfitting becoming an issue.

To address this case, one technique that is used to control the values
is regularization. This technique penalizes the error function to avoid
having the coefficients reach large values(the cause of higher-order polys
overfitting in the first place).

E~(w) = 1/2 * (sum from n=1 to N of (y(xn, w) - tn)^2) + (lambda/2)(||w||^2)

where ||w||^2 = wTw = w0^2 + w1^2 + ... + wM^2
      lambda = "learning rate", governs importance of regularization term
            					vs. sum-of-squares error term. Usually a
            					negative value to cause decay to
            					occur.

This is known as *ridge regression* in stats, and is called *weight decay*
in neural networks.

Alpaydin
============

Chapter 2
------------

In a classification problem, we're trying to find a *hypothesis*
h that matches up with a class C, an indication of a range of
values in which the class takes on a certain value. For example,
if the class is binary(true/1 or false/0 values), we want to find
a rectangle that captures all the points where C is 1 and no points
where C is 0. The set of all possible hypotheses is H.

One possibility is to find the *most specific hypothesis* S, the smallest
rectangle that includes all the positive examples and none of the
negative ones. C may be larger than S but never smaller. The *most
general hypothesis* G, on the other hand, is the largest such rectangle.
Any *h* in our hypothesis *H* between S and G is a valid hypothesis
with no error, said to be *consistent* with the training set, and
the collection of all these h values makes up the *version space*.

Furthermore, depending on X(training data) and H, there may be several Si
and Gj which form the S-set and G-set. The version space is the
collection of all values h between any Si and Gj.

Generally, when picking h, our strategy will be to choose an h exactly
in the middle of S and G, to maximize the *margin*(distance between
boundary and instances closest to it). We also have an error function
for these types of problems that measures the distance of h from the
boundary.

Vapnik-Chervonenkis (VC) Dimension
-----------------------------------

The VC dimension for a hypothesis set states the maximum number of
points that can be *shattered* by H. Shattering N points means
there exists an arrangement of those N points for which any possible
classification of those N points can be classified in a hypothesis
h in H without error.

Probably Approximately Correct (PAC) Learning
------------------------------------------------

We want to make sure that the probability of false negatives is
low, and we want to do so in a way that feels mathematically correct.

