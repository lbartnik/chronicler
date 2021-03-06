% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tracker.R
\name{attach_with_wizard}
\alias{attach_with_wizard}
\title{Attach to repository.}
\usage{
attach_with_wizard(x = file.path(getwd(), "repository"))
}
\arguments{
\item{x}{a \link[repository:repository]{repository::repository} object or a path to look for
repository under; if a path, create if does not exist.}
}
\description{
\code{attach_with_wizard} extends the default, on-load logic
with interactions with the user whenever a decision cannot be made
automatically and thus results in an error on package load.
}
