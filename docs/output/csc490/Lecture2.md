CSC490 Lecture 2
==================

Misconceptions About Watson
----------------------------

Quite a few people don't know what Watson does. A lot
of people thinks Watson is a supercomputer that can do anything.

Watson is actually a bunch of different apps, which share a common
base of neural nets and AI. There are three business models that IBM
runs with Watson:

1. Around industries that will go through a big change in cognitive
computing

2. Where there are similar patterns across industries, such as how
people discover and engage with organizations and how organizations
make different kinds of decisions

3. Creating an ecosystem of entrepreneurs.

There are three simple questions that you need to ask when
making a Watson app:

1. What is the business value?

2. Does the app draw on the unique characteristics and capabilities
of a cognitive offering?

3. Is the content identified and can be secured/licensed for the
intended use?

A great use case has:

1. A question and answer requirement, with questions posed in natural
language

2. Seek answers and insights from a defined data repo filled with largely
unstructured data

3. Provide transparency and supporting evidence for confidence
weighted responses to questions and queries.

It's difficult when the data is unstructured, because someone who has
not studied the source data will not ask the question in a way similar
to how someone who has studied the source data will. Need to accomodate
for variation.

Examples of Watson Apps
========================

The Dev Challenge
-------------------

Short time period to develop a Waton-based application. Five finalists
were chosen, three grand prize winners. All five finalists have
their pitch videos and Q/A up online.

In the USC competition, the team that won did a legal research application.
The thing that carried them to the top was that they really understood the
target market, and how the industry was changing.

Watson Use Cases
==================

Rule 1: Consider the value of the Pain you're solving. The *size*,
the *frequency*, and the *duration* of the pain. You need to figure
from this to figure out how much you're saving, so you can figure out
how much to cost.

Rule 2: Ask your users. Need to figure out if you need a wider
variety of data if it improves decision making, if there's more value 
in providing a small set of best answers, if knowing the source and
confidence of the answers helps, if there's a pool of historically
known best answers(the ground truth Watson provides answers from),
and remember that the number of answers increases with the skill of the user.

Rule 3: Watson speaks in the Language of the User

The people who ask questions will use a much different language from
experts of the system. The answer needs to be found in the corpus,
since Watson can't make stuff up.

Rule 4: Ingestion with Content

Best approach is empirical. Try structuring the content in different ways,
run experiments, and analyze. One cool way to get Watson to associate
specific sections with specific info is to feed the data to Watson in
both the large document and separate documents for each section.

Rest of use cases are on the slides.

Don't use anything less than 300 questions.

Law
========

Statutes are the overall rules, whereas Regulations are the way
those rules get applied. Both of these exist at the municipal,
provincial and federal levels.

The format of the beginning of each statute seems consistent.
Could extract some information from that using NLP.

Pain Points
-------------

1. If lawyers throw a massive body of evidence at you that they
plan to use during the case, it's impossible to go through all
of it quickly enough.
2. CanLII only provides when papers are cited, doesn't provide
information on *how* the paper was cited(favorably? unfavorably?
used as a point of contention? etc.)

Legal Research
=================

1. Identify the legal issue to be investigated. 20% of the time it's
easy (source for investigation is dictated in question), 80% of the time
it's difficult(no idea where to start).

Tough questions: What are the exceptions to the legal hearsay rule?
When are police required to read you your rights? What is the state
of law in Ontario on unjust enrichment?

2. Identify the general legal topics.

3. Go to the sources. Work from general topic to specific issue.

General tips: brainstorm key search words, identify search params,
search for articles/bulletins, search CANLII, search secondary sources

4. Compare and synthesize the case law and legislation. Recognize the
similarities and differences in fact patterns to distinguish or apply
court decisions.

We can cover steps 1 to 3 using Watson. This is usually about three to
four hours of work for tougher questions. However, the *major pain* comes
from step four -- this takes a day and a half to two weeks for tougher
cases.

The worst part of doing research is figuring out *when* to stop. You don't
know if you have all the information.

There's a major trust issue with automating the research step though. There's
no real confidence that comes with just asking a computer and getting a list
of results. We can alleviate this somewhat by building up our corpus to be
all-encompassing and by sharing Watson's confidence values. We can also
share a list of all the records we searched through.

Relevancy and giving lawyers a path to go down improves the reception
of a research app idea. The value also improves if we're able to
give them back info from provinces that they don't have much experience.
