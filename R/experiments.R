#' Experiments.
#'
#' @rdname experiments
#' @name experiments
NULL


#' `show_experiments` finds all artifacts matching the definition of a
#' model (e.g. of class `"lm"`) together with their:
#'   * parametrization: literal scalars and scalar variables used in
#'     expressions/calls leading up to the given artifact
#'   * sequence of commands from the original data set to that model
#'   * list of downstream artifacts, like predictions, model evaluations,
#'     plots, etc.
#'
#' @return `find_experiments` returns a container (see [utilities::as_container])
#' of objects of class `"experiment"`.
#'
#' @rdname experiments
#' @export
find_experiments <- function () {
  ms <- find_models(chronicler_state$repo)
  as_container(lapply(ms, as_experiment))
}


#' @export
print.experiment <- function (x, ...) {
  ccat0(grey = '# Experiment ', green = x$id, '\n')
  cat0(x$expression, '\n')

  ccat0(default = 'grey', '\n# Model\n')
  cat0(x$description, '\n')

  if (!length(x$path)) {
    ccat(default = 'grey', '\n# No parameters found for this experiment\n')
  } else {
    ccat(default = 'grey', '\n# Parametrization\n')
    lapply(x$path, function (on_path) {
      ccat('\n*')
      imap(on_path$parameters, function (value, name) {
        cat(' ')
        if (is_character(name) && nchar(name)) ccat0(green = name, ':')
        ccat0(yellow = value)
      })

      # add colors to the expression - highlight parameters
      prms <- as.character(on_path$parameters)
      names(prms) <- rep("cyan", length(on_path$parameters))
      expr <- colorize_(on_path$expression, prms,  'grey')

      ccat0('\n', expr, '\n')
    })
  }
}





#' @importFrom rlang UQ
find_models <- function (repo) {
  model_classes <- c("lm")
  as_artifacts(repo) %>% filter(class %in% UQ(model_classes)) %>% read_artifacts
}

find_ancestors <- function (a) {
  stopifnot(is_artifact(a))
  as_artifacts(repository:::artifact_store(a)) %>% filter(ancestor_of(UQ(a$id))) %>% read_artifacts
}

as_experiment <- function (a) {
  stopifnot(is_artifact(a))

  path <- lapply(find_ancestors(a), as_parametrization)
  path <- Filter(function(x)length(x$parameters), path)

  exp <- list(
    expression  = a$expression,
    description = a$description,
    id          = a$id,
    model       = artifact_data(a),
    path        = path
  )

  structure(exp, class = 'experiment')
}

as_parametrization <- function (a) {
  stopifnot(is_artifact(a))
  c <- artifact_commit(a)

  e <- repository:::as_environment(c)
  f <- function(...){}
  body(f) <- c$expression
  d <- defer::defer_(f, .caller_env = e, .extract = TRUE)

  list(
    expression = a$expression,
    parameters = defer::extract_parameters(d)
  )
}
