#' @importFrom rlang is_character
is_ui_shortcut <- function (line, shortcut_name = 'artifacts') {
  is_colon <- function (x) is.call(x) && (identical(x[[1]], bquote(`::`)) || identical(x[[1]], bquote(`:::`)))
  is_assignment <- function (x) is.call(x) && identical(x[[1]], bquote(`<-`))

  traverse <- function (x) {
    recurse <- function (y) any(unlist(lapply(y, traverse)))
    if (is.name(x) && identical(as.character(x), shortcut_name)) return(TRUE)
    if (is_assignment(x)) return(recurse(x[-(1:2)]))
    if (is_colon(x)) return(FALSE)
    if (is.recursive(x)) return(recurse(x))
    FALSE
  }

  if (is_character(line)) line <- parse(text = line)
  traverse(line)
}
