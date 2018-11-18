#' Chronicler user interface objects.
#'
#' @name chronicler-ui
#' @rdname chronicler-ui
NULL

#' `artifacts` is the entry point for artifact search. It exposes an
#' interactive query mechanism with tab-completion via the `$` (dollar)
#' operator.
#'
#' @export
#' @rdname chronicler-ui
#'
#' @examples
#' \dontrun{
#' # show summary of all artifacts in repository
#' artifacts
#'
#' # show all R sessions
#' artifacts$session
#'
#' # show artifacts from a given session
#' artifacts$session$afc61b89
#'
#' # show all artifacts with a given name
#' artifacts$name$input
#' artifacts$input
#'
#' # retrieve a given artifact
#' artifacts$id$c643b1a$value
#' }
artifacts <- NULL

#' `history` gives access to the history of commands stored in the
#' repositoy along artifacts.
#'
#' @export
#' @rdname chronicler-ui
history <- NULL


#' @rdname session-state
init_ui <- function (state) {
  guard()

  unlockBinding('artifacts', asNamespace('chronicler'))
  assign('artifacts', artifacts_query(state), envir = asNamespace('chronicler'))
  #history   <<- commits_query(state)
  lockBinding('artifacts', asNamespace('chronicler'))
}


#' `identify` takes an object or a file path as a parameter and returns
#' artifacts matching that object or contents of the file. A number of
#' file types are supported: plots, text data, serialized R objects.
#'
#' @param x R object, file path or an artifact.
#'
#' @export
#' @rdname chronicler-ui
#'
#' @importFrom rlang is_scalar_character
#'
#' @examples
#' \dontrun{
#' # look for an object
#' identify(iris)
#'
#' # look for a plot
#' identify('./plot.png')
#' }
identify_artifact <- function (x) {
  # TODO gracefully handle exceptions

  if (is_scalar_character(x) && file.exists(x)) {
    ans <- search::identify_file(x, chronicler_state$repo)
  } else {
    ans <- search::identify_object(x, chronicler_state$repo)
  }

  if (identical(length(ans), 1L)) return(first(ans))
  ans
}


#' `explain` provides additional context for an artifact.
#'
#' @export
#' @rdname chronicler-ui
explain <- function (x) {
  stopifnot(is_artifact(x))

  x_id <- x$id
  ans <- as_artifacts(chronicler_state$repo) %>% filter(ancestor_of(UQ(x_id))) %>% read_artifacts
  ui:::wrap(ans, 'history')
}

