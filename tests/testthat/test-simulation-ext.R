context("simulation-ext")

test_that("reference to artifacts is recognized", {
  expect_true(is_ui_shortcut("artifacts$x"))
  expect_true(is_ui_shortcut("artifacts$x$y$z$a"))
  expect_true(is_ui_shortcut("z <- artifacts$x"))

  expect_false(is_ui_shortcut("artifact$x"))
  expect_false(is_ui_shortcut("artifacts$x <- 1"))
})

test_that("reference in expression", {
  expect_true(is_ui_shortcut(quote(artifacts$a$b$c)))
})

test_that("custom reference name", {
  expect_true(is_ui_shortcut(quote(zzz$a$b$c), 'zzz'))
})
