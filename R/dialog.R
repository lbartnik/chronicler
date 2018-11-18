showMultipleChoice <- function (title, message, choices) {
  ans <- rstudioapi::showPrompt(title, paste0(message, '\n', paste(choices, collapse = '\n'), '\n'))
  if (!length(ans)) abort("No answer from user.")

  i <- match(ans, choices)
  if (is.na(i)) i <- suppressWarnings(as.integer(ans))
  if (is.na(i)) abort("Unsupported choice.")
  i
}
