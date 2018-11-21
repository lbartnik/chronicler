#' Internal state object, used by the `ui` package.
#' @rdname session-state
chronicler_state <- new_state()


#' @description `prepare_session` runs the logic of attaching to
#' a repository without any user interactions. In case of an error, it
#' informs the user how to start the interactive wizard.
#'
#' @param state the global session state object.
#' @param path path to [repository::repository].
#'
#' @rdname session-state
prepare_session <- function (state, path) {
  inform("chronicler: attempting to attach to an existing repository")

  tryCatch(
    {
      state_reset(state)
      open_repository(state, path)
      pick_branch(state, .GlobalEnv)
      start_tracking(state, 'chronicler-task-callback')
      init_ui(state)
    },
    error = function(e) {
      cinform("Failed to open repository on package load.",
              e$message, "\nRun chronicler::attach_with_wizard() for interactive wizard.",
              sep = '\n', default = 'grey')
      state_reset(state)
    }
  )
}

close_session <- function (state) {
  stop_tracking(state)
}


#' Attach to repository.
#'
#' @description `attach_with_wizard` extends the default, on-load logic
#' with interactions with the user whenever a decision cannot be made
#' automatically and thus results in an error on package load.
#'
#' @param x a [repository::repository] object or a path to look for
#'        repository under; if a path, create if does not exist.
#'
#' @export
attach_with_wizard <- function (x = file.path(getwd(), 'repository')) {
  if (!is_rstudio()) {
    abort("currently wizard can be run only in RStudio")
  }

  # TODO check if already attached

  state_reset(chronicler_state)

  # if a repository, simply open it; if a path, try creating too
  if (is_repository(x)) {
    open_repository(chronicler_state, x)
  } else {
    if (!is_character(x)) abort("`x` is not a path nor a repository object")

    open_repository(chronicler_state, x, interactions(
      create_first_commit = function () {
        rstudioapi::showQuestion(
          "Create first commit?",
          glue("Repository found under '{x}' is empty but current session \\
                contains data. Do you want to add objects from the current session \\
                as the first commit in the repositry?")
        )
      }
    ))
  }

  # pick commit in the repository and load it into global environment
  pick_branch(chronicler_state, .GlobalEnv, interactions(
    clean_env = function() {
      rstudioapi::showQuestion(
        "Clean session (global) environment?",
         glue("Current session does not match any commit in repository '{path}'. \\
               Choose 'OK' to remove objects from the current session.")
      )
    },
    choose_commit = function (commits) {
      choices <- imap(commits, function(c, i) glue("{i} - {c$id}"))
      showMultipleChoice("Choose commit", "Multiple commits match global environment, choose the one to attach to.",
                         choices)
    },
    choose_branch = function (commits) {
      choices <- imap(commits, function(c, i) glue("{i} - {c$id}"))
      showMultipleChoice("Choose commit", "There is more than one branch in the repository. Choose the one to attach to.",
                         choices)
    }
  ))

  # turn the tracker on
  start_tracking(chronicler_state, 'chronicler-task-callback')

  # re-initialize ui
  init_ui(chronicler_state)
}
