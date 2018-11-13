#' Internal state object, used by the `ui` package.
#' @rdname session-state
chronicler_state <- new_state()


#' @description `prepare_session` runs the logic of attaching to
#' a repository without any user interactions. In case of an error, it
#' informs the user how to start the interactive wizard.
#'
#' @param state the global session state object.
#'
#' @rdname session-state
prepare_session <- function (state) {
  inform("chronicler: attempting to attach to an existing repository")

  tryCatch(
    {
      attach_to_repository(state, file.path(getwd(), 'repository'), interactions())
      init_ui(state)
    },
    error = function(e) {
      cinform("Failed to open repository on package load.",
              e$message, "\nRun chronicler::attach_wizard() for interactive wizard.",
              sep = '\n', default = 'grey')
      state_reset(state)
    }
  )
}

close_session <- function (state) {
  stop_tracking(state)
}


#' @description `chronicler_attach` extends the default, on-load logic
#' with interactions with the user whenever a decision cannot be made
#' automatically and thus results in an error on package load.
#'
#' @export
#' @rdname chronicler-ui
attach_wizard <- function () {
  if (!is_rstudio()) {
    abort("currently wizard can be run only in RStudio")
  }

  # TODO check if already attached

  showMultipleChoice <- function (title, message, choices) {
    ans <- rstudioapi::showPrompt(title, paste0(message, '\n', paste(choices, collapse = '\n'), '\n'))
    if (!length(ans)) abort("No answer from user.")

    i <- match(ans, choices)
    if (is.na(i)) i <- suppressWarnings(as.integer(ans))
    if (is.na(i)) abort("Unsupported choice.")
    i
  }


  repo_path <- file.path(getwd(), 'repository')
  attach_to_repository(chronicler_state, repo_path, interactions(
    create_first_commit = function () {
      rstudioapi::showQuestion(
        "Create first commit?",
        glue("Repository found under '{repo_path}' is empty but current session \\
              contains data. Do you want to add objects from the current session \\
              as the first commit in the repositry?")
      )
    },
    clean_env = function() {
      rstudioapi::showQuestion(
        "Clean session (global) environment?",
         glue("Current session does not match any commit in repository '{repo_path}'. \\
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
}

attach_to_repository <- function (state, path, int) {
  state_reset(state)
  open_repository(state, path, int)
  pick_branch(state, .GlobalEnv, int)
  start_tracking(state, 'chronicler-task-callback')
}


