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
  artifacts <<- artifacts_query(state)
  #history   <<- commits_query(state)
  lockBinding('artifacts', asNamespace('chronicler'))
}
