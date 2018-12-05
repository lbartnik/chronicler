History of Objects for R
========================


| CRAN version    | Travis build status   | AppVeyor | Coverage |
| :-------------: |:---------------------:|:--------:|:--------:|
| [![CRAN version](http://www.r-pkg.org/badges/version/chronicler)](https://cran.r-project.org/package=chronicler) | [![Build Status](https://travis-ci.org/lbartnik/chronicler.svg?branch=master)](https://travis-ci.org/lbartnik/chronicler) | [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/lbartnik/chronicler?branch=master&svg=true)](https://ci.appveyor.com/project/lbartnik/chronicler) | [![codecov](https://codecov.io/gh/lbartnik/chronicler/branch/master/graph/badge.svg)](https://codecov.io/gh/lbartnik/chronicler)|


`chronicler` implements the concept of __history of objects__. It is different
from R's standard __history of commands__ in that alongside each command it
stores all objects that it creates, together with the information about their
lineage. (Lineage of an object is the tree of its parent objects.)

The best way to learn about `chronicler` and see how history of objects can
be helpful in data analysis, see ["introduction"](https://htmlpreview.github.io/?https://github.com/lbartnik/chronicler/blob/master/inst/doc/introduction.html)
vignette. If you wish to give it a try in a pre-installed and pre-configured
run-time environment, see
["running the examples"](https://htmlpreview.github.io/?https://github.com/lbartnik/chronicler/blob/master/inst/doc/running-examples.html)
vignette.


`chronicler` is in fact an umbrella-package: it comes with just a little code
to organize the work of a number of lower-level packages. `chronicler` declares
a dependency on
[`storage`](https://github.com/lbartnik/storage),
[`repository`](https://github.com/lbartnik/repository), 
[`ui`](https://github.com/lbartnik/ui),
[`browser`](https://github.com/lbartnik/browser),
[`search`](https://github.com/lbartnik/search),
[`defer`](https://github.com/lbartnik/defer) and
[`utilities`](https://github.com/lbartnik/utilities).



# Vignettes

  * [Introduction](https://htmlpreview.github.io/?https://github.com/lbartnik/chronicler/blob/master/inst/doc/introduction.html) - this is how __history of objects__ help in data exploration; it explains the idea in depth and shows practical examples of interacting with `chronicler`
  * [Integration with ML Flow](https://htmlpreview.github.io/?https://github.com/lbartnik/chronicler/blob/master/inst/doc/mlflow.html) - exporting models and their relevant artifacts to [ML Flow](https://mlflow.org/) through the [mlflow](https://cran.r-project.org/package=mlflow) R package
  * [Running examples](https://htmlpreview.github.io/?https://github.com/lbartnik/chronicler/blob/master/inst/doc/running-examples.html) a pre-configured envioronment to give `chronicler` a go without too much prior work

# Other documentation

  * [Graphical artifact browser](https://lbartnik.github.io/experiment/) - an older attempt at browsing artifacts with Shiny and JS


# Components (dependencies of `chronicler`)

Other packages implementing the *repository of artifacts*:
  * [repository](https://github.com/lbartnik/repository) - middle layer with "business logic"
  * [storage](https://github.com/lbartnik/storage) - store of R objects
  * [defer](https://github.com/lbartnik/defer) - building and processing closures of R functions and data
  * [ui](https://github.com/lbartnik/ui) - text-based user interface
  * [browser](https://github.com/lbartnik/browser) - graphical artifact browser, implemented as an RStudio add-in
  * [search](https://github.com/lbartnik/search) - match artifacts against arbitrary files (data and plots)
  * [utilities](https://github.com/lbartnik/utilities) - a set of shared utility functions


# FAQ

**What is the use case for the repository of artifacts?**

The goal is to build a generic mechanism to store artifacts of data
analysis and to search and browse such repository. Effectively, this
will extend R's history mechanism (see `?utils::history`) to contain
not only commands but also objects, data sets, plots, printouts, etc.
Thus, there is no domain-specific use case other than extending a basic
mechanism with the hope that users will adopt it according to their
personal preferences and working styles.


**What are the key aspects of the repository of artifacts?**

  1. Store evey artifact present in any of the R sessions within a data
     analysis project.
  1. Provide a search mechanism to narrow the selection of artifacts and
     identify the artifact of interest.
  1. Provide an interactive artifact browser to recall the context of any
     given artifact.

My estimate is that the current implementation covers 60% of the first
point, 45% of the second point, and about 10-15% of the third one. See
the [work plan](https://lbartnik.github.io/repository/) for further
information.

