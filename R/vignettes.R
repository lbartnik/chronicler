# used to load sample repos in vignettes
attach_to_repository <- function (repo) {
  state_reset(chronicler_state)
  open_repository(chronicler_state, repo, ui::interactions())
  pick_branch(chronicler_state, new.env(), ui::interactions())
  start_tracking(chronicler_state, 'chronicler-task-callback')
  init_ui(chronicler_state)
}


#' Knit artifacts.
#'
#' @rdname engine-chronicler
#' @name engine-chronicler
NULL


#' @param x value to be tested.
#'
#' @rdname engine-chronicler
#' @export
is_artifact_id <- function (x) {
  is.character(x) && (length(x) == 1) && (nchar(x) == 40) && identical(grep('^[a-f0-9]+$', x), 1L)
}

#' @param id artifact identifier.
#'
#' @rdname engine-chronicler
#' @export
#' @importFrom rlang UQ
#' @importFrom utils capture.output
knit_artifact <- function (id) {
  # pre-conditions
  is_highlight <- try_load('prettycode')

  # read artifact and its ancestors
  art <- as_artifacts(chronicler_state$repo) %>% filter(id == UQ(id)) %>% read_artifacts %>% first
  anc <- container_sort(find_ancestors(art), time)

  # capture the main artifact
  out <- capture.output(print(art), type = 'output')

  # capture explanation
  extra <- capture.output(type = 'output', invisible(lapply(anc, function(b) {
    if (!is_highlight) {
      cat(b$expression)
    } else {
      cat(ansi_to_html(prettycode::highlight(b$expression)))
    }
    cat('\n\n')
  })))

  extra <- paste0(
    '<div class="chronicler"><a onclick="$(\'#', id, '\').toggle()">explain artifact ', id, '</a>',
    '<pre id="', id, '" class="r-output" style="display: none"><code>',
    paste(extra, collapse = '\n'),
    "</code></pre>",
    "</div>"
  )

  # needs to be passed to knitr::engine_output
  list(out = out, extra = extra)
}
