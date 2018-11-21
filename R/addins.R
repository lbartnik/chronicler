#' Browser binding.
#'
#' @param .inBrowser Run in a browser instead of a in-process popup.
#'
#' @export
#' @importFrom browser browser_addin
browser_addin_binding <- function (.inBrowser = FALSE) {
  data <- read_artifacts(as_artifacts(chronicler_state$repo))
  browser_addin(data, .inBrowser)
}


search_addin_binding <- function () {
  if (!try_load('rstudioapi') || !try_load('search')) {
    abort("failed to load rstudioapi or search, aborting")
  }

  path <- rstudioapi::selectFile(path = getwd())
  cinform(grey = glue("searching for artifact matching {path}"))
  search::identify_file(path, chronicler_state$repo)

  # TODO run browser and highlight the matching artifact
}

