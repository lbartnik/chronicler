# used to load sample repos in vignettes
attach_to_repository <- function (repo) {
  state_reset(chronicler_state)
  open_repository(chronicler_state, repo, ui::interactions())
  pick_branch(chronicler_state, new.env(), ui::interactions())
  start_tracking(chronicler_state, 'chronicler-task-callback')
  init_ui(chronicler_state)
}
