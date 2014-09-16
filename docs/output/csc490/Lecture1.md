CSC490 Lecture 1
================

The main advantage of Watson shows when you can leverage a field
that is entirely based around natural language. e.g. medical
papers.

What's nice about Watson is that it does not just process a
question and return an answer. It also builds up a model of what
you are looking for based on your questions in order to address
the point that you are getting at.

Watson Challenges
-------------------

- Watson is a black box. We have no clue what's going on behind the
scenes.
- Four styles of answers: jeopardy, passage, and two others. We
will be using passage-style answers. Our applications will be designed
for this. There will be no single answer, but a paragraph of facts.
This means that if we want to extract a single fact from Watson,
we have to process the data we get back.
- There will only be a single corpus for the class, and it needs to
be internally consistent.
- No structured data.

Course Details
---------------

Pulling in people from outside is okay(consider Hannah for UX).

Domains
----------

The chosen domain for this course is law.
Good domain because people spend months, even years reviewing papers
trying to figure out how to resolve a case. It also doesn't have to
be necessarily a law-related app since these papers have lots of
info, such as differences between the US and other countries.

Statutes are available for free, as are decisions made by boards and
tributes.

User Roles
-------------

There are five user roles when you're uploading documents to
the thing:

- Manager (assigns questions to different approvers)
- Author (creates corpus+questions from documents, used to train Watson)
- Approver (approves the document and answer quality)
- Uploader (uploads things)
- Student (accesses corpus afterwards for app)

Important number: 507. This is our instance number of Watson.

Prep
--------

CanLII: a collection of law stuff from Canada (www.canlii.org/en)

Group 1: Criminal Code
Group 2: Income Tax Act
Group 3: Canada Labour Code
Group 4: Constitution Act
Group 5: Highway Traffic Act
Group 6: Family Law Act

Goal: Use QAAPI to return answers to queries on your domain.