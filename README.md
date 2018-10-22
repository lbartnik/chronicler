Binary History for R
====================


| CRAN version    | Travis build status   | AppVeyor | Coverage |
| :-------------: |:---------------------:|:--------:|:--------:|
| [![CRAN version](http://www.r-pkg.org/badges/version/chronicler)](https://cran.r-project.org/package=chronicler) | [![Build Status](https://travis-ci.org/lbartnik/chronicler.svg?branch=master)](https://travis-ci.org/lbartnik/chronicler) | [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/lbartnik/chronicler?branch=master&svg=true)](https://ci.appveyor.com/project/lbartnik/chronicler) | [![codecov](https://codecov.io/gh/lbartnik/chronicler/branch/master/graph/badge.svg)](https://codecov.io/gh/lbartnik/chronicler)|


# Other packages (components)

Other packages implementing the *repository of artifacts*:
  * [repository](https://github.com/lbartnik/repository) - middle layer with "business logic"
  * [storage](https://github.com/lbartnik/storage) - store of R objects
  * [defer](https://github.com/lbartnik/defer) - building and processing closures of R functions and data
  * [ui](https://github.com/lbartnik/ui) - text-based user interface
  * [browser](https://github.com/lbartnik/browser) - graphical artifact browser, implemented as an RStudio add-in
  * [search](https://github.com/lbartnik/search) - match artifacts against arbitrary files (data and plots)
  * [utilities](https://github.com/lbartnik/utilities) - a set of shared utility functions


# Documentation

  * [user interface tutorial](https://lbartnik.github.io/chronicler/tutorial.html) - ways and APIs to interact with the repository
  * [work plan](https://lbartnik.github.io/chronicler/plan.html) - current state of affairs and ideas for research
  * [graphical artifact browser](https://lbartnik.github.io/experiment/) - an older attempt at browsing artifacts with Shiny and JS

If GitHub pages is down, documents are also available under link below; save locally and open in browser:
  * [user interface tutorial](https://raw.githubusercontent.com/lbartnik/chronicler/master/inst/doc/tutorial.html)
  * [work plan](https://github.com/lbartnik/chronicler/blob/master/inst/doc/plan.html)


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

