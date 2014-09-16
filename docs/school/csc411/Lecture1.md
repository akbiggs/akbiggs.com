CSC411 Lecture 1
=================

Email: csc411prof@cs.toronto.edu

4 assignments, worth 12.5% each.
Last assignment is Kaggle.

Lecture
===========

Learning System
-----------------

A *learning system* isn't developed to directly solve a problem,
instead it develops its own program based on examples of how
they should behave and from trial-and-error experience of trying
to solve it.

You want to implemnet an unknown function, using input-output
pairs, called *training examples*.

A common benchmark problem for a learning system is classifying
handwritten characters into digits.

Label data means that you know what the right answer for the data
is. e.g. if you know that a certain handwritten character is a
zero.

Why Use Learning?
------------------

It's hard to write programs that solve problems like
recognizing a handwritten digits. Producing a program
allows us just to base what should happen from thousands
to millions of examples.

The program needs to work on new cases just as well as it
works on the examples. Needs to generalize to unknown input.

Classic examples of learning: face and spam detection.

Types of Learning Tasks
-------------------------

Supervised: Correct output known for each training example.
- Classification: 1-of-N output (e.g. speech and object recognition)
- Regression: real-valued output (predicting prices)

Unsupervised: Don't know the correct output for each input. Need to create
an internal representation of the input. e.g. form clusters, extracting
features.

Reinforcement learning: different flavor, temporal problem. You go through
a series of steps and get a payoff. Need to figure out the actions that
maximize payout. Not much info in a single payoff signal, payoff is often
delayed.

Data Mining
--------------

Data mining typically uses very simple machine learning techniques on large
databases because of how much data there is to process.

Previously used in a negative sense. Kind of a misguided stats procedure of
brute-forcing a relationship in data. These days, the lines are blurry, since
many ML problems involve tons of data. But problems with AI flavor are definitely
in the realm of ML.

Machine Learning & Stats
-------------------------

ML uses stats theory to build models, since the core task is inference from a
sample. Lots of it is rediscovery of things already known by statisticians, just
disguised by differences in technology.

There's a cultural gap between the two. A lot of the terms we use are different,
but they mean the same thing. e.g. weights vs. parameters, learning vs. fitting.
However, machine learning has huge differences in grants!

