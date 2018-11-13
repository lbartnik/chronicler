#' Search for artifacts.
#'
#' An entry point for artifact search. Exposes an interactive query
#' mechanism with tab-completion via the `$` (dollar) operator.
#'
#' @export
#' @rdname chronicler-ui
artifacts <- NULL


#' @rdname session-state
init_ui <- function (state) {
  guard()

  unlockBinding('artifacts', asNamespace('chronicler'))
  artifacts <<- artifacts_query(state)
  lockBinding('artifacts', asNamespace('chronicler'))
}
