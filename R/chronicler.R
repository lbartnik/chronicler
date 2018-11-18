#' @title Chronicler: Binary History for R
#' @description Meta-package that installs all dependencies needed to
#' enable history of binary R objects: data sets, models, plots, code.
#'
#' Package-level [options]:
#'   * `chronicler.attach` (default: `TRUE`) find the most
#'      up-to-date [commit] in the repository and continue work from
#'      there
#'
#' @docType package
#'
#' @import repository
#' @import utilities
#' @import storage
#' @import ui
#' @import browser
#' @import search
#' @importFrom glue glue
#' @importFrom rlang inform warn abort
#'
#' @name chronicler
#' @rdname chronicler
NULL


.onLoad <- function (libname, pkgname) {
  if (interactive() && !is_devtools_load()) {
    if (!is_auto_attach()) {
      inform("chronicler.attach is not TRUE, not attaching to repository")
    } else {
      prepare_session(chronicler_state, file.path(getwd(), 'repository'))
    }
  }
}

.onUnload <- function (libpath) {
  if (interactive() && is_auto_attach() && !is_devtools_load()) {
    close_session(chronicler_state)
  }
}

is_devtools_load <- function() {
  any(vapply(sys.calls(), function (c) {
    if (!is.call(c)) return(FALSE)
    c <- utilities::first(c)
    if (!is.call(c) || !identical(first(c), quote(`::`))) return(FALSE)
    identical(second(c), quote(devtools)) && identical(nth(c, 3), quote(load_all))
  }, logical(1)))
}

is_auto_attach <- function() isTRUE(getOption("chronicler.attach", TRUE))
