context("experiments")


test_that("experiment from artifact", {
  a <- sample_artifact()
  e <- as_experiment(a)

  expect_named(e, c("model", "expression", "parameters"))
  expect_length(e$parameters, 1)
  expect_equal(first(e$parameters), "MAC000010")
})

test_that("all models are found", {
  m <- find_models(sample_repository())
  expect_length(m, 1)
  expect_equal(first(m)$class, "lm")
})

