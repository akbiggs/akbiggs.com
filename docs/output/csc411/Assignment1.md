CSC411 A1
============

#1

1.1 p(y=1|x) = (p(x|y=1)p(y=1)) / p(x)
             = p(y=1) p(x|y=1) / p(x)
             = alpha * p(x|y=1) / (p(x|y=0)p(y=0) + p(x|y=1)p(y=1))
             = alpha * p(x|y=1) / (p(x|y=1)alpha + p(x|y=0)(1-alpha))

             divide by numerator
             = 1 / (1 + (1-alpha)p(x|y=0)/((alpha)(p(x|y=1))))
             = 1 / (1 + exp(ln((1-alpha)(p(x|y=0))/((alpha)(p(x|y=1))))))

p(x) = (1/(sigma)