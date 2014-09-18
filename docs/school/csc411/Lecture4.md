CSC411 Lecture 4
================

Recall that you cannot always separate classes using a linear classifier.
This can mean a variety of things: the class isn't easy to separate,
you don't have all the information necessary, there's noise, etc.

The question is, should we make the model complex enough to have
perfect separation in the training data?

Review
---------

The classifier we chose last lecture was y(x) = sign(w0 + wTx).
With this classifier, it was difficult to optimize any loss on
l(y, t) due to the form of y(x), since it's either 0 or 1(you lose
any info about how close you were).

We want a smoother function so things become easier to optimize.

Sigmoid
----------

One alternative is replace the "sign" function with the **sigmoid**
or **logistic** function. Now we have y(x) = sigma(wTx + w0),
where the sigmoid sigma is a function sigma(z) = 1 / (1 + exp(-z)).

Has a few interesting properties: max value is 1, min value is 0. As
z -> inf, y -> 1, and as z -> -inf, y -> 0. The majority of change
in the value happens around 0. It's a smooth function.

Shape of the Logistic Function
------------------------------

Changes to w affect the shape of our logisitic function. We can
view w0 as the "bias" of our function -- changing it will shift
the location of our curve. Changing w1 - wN will stretch and squish
our curve in different dimensions.

Conditional Likelihood
------------------------

Assume t in {0, 1}, we can write the probability distribution of
each of our training points {t1, ..., tN | x1, ..., xN}. In other
word, we can figure out how likely each of our target points
are to occur.

One view to take when approaching your training model is that you should
bias towards the training examples, since they're pulled from reality
and therefore might be more likely to occur.

Assume that the training examples are sampled IID, i.e.
p(t1, ..., tN|x1, ..., xN) = product from i=1 to N of p(ti|xi).

We can write each probability as
p(ti|xi) = (p(C=1|xi)^ti)(p(C=0|xi)^(1-ti)). The intuition for this
is that when ti = 0, this is 1 pp(C=0|xi), and when
ti = 1, this is p(C=1|xi). It seems like a pretty complicated way
to express this idea, but it's easy to take the derivative of, which
will be useful for when we're working on optimizing the learnining
function.

When we learn from the model, we do so by maximizing the conditional likelihood:

max over w of (product from i=1 to N of p(ti|xi))

Note that p(t1, ..., tN|x1, ..., XN) =
product from i=1 to N of (1 - P(C=1|xi)^ti)(P(C=0|xi)^ti-1)

We want to convert this to a minimization problem so we can use it to
minimize our loss. So we can take the log and convert the maximization
to a minimization by changing the sign. Typically called the **log loss**
function.

l{log-loss}(w) = -(sum from i=1 to N of (ti)(log(1-p(C=0|xi,w)))) -
(sum from i=1 to N of (1 - ti)log(p(C=0|xi,w)))

Recall the log properties:

log(ab) = log(a) + log(b)

log(a^b) = blog(a)

log(1/a) = -log(a)

We can use these properties to make simplifying our expression easier.

l(w) = sum over i of (t^i)