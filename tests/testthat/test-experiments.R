context("experiments")


test_that("all models are found", {
  m <- find_models(sample_repository())
  expect_length(m, 1)
  expect_equal(first(m)$class, "lm")
})

test_that("experiment from artifact", {
  a <- sample_artifact()
  e <- as_experiment(a)

  expect_named(e, c("description", "expression", "id", "model", "outcomes", "path"), ignore.order = TRUE)
  expect_length(e$path, 3)

  entry <- first(e$path)
  expect_equal(first(entry$parameters), "MAC004929")
})

test_that("print experiment", {
  e <- as_experiment(sample_artifact())
  expect_output_file(print(e), 'expected-output/print-experiment.txt')
})
