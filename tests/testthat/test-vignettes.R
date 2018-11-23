context("vignettes")

test_that("match id", {
  expect_true(is_artifact_id('abcdef0123456789012345678901234567890123'))

  expect_false(is_artifact_id('abcdef012345678901234567890123456789012'))
  expect_false(is_artifact_id('abcdef012345678901234567890123456789012z'))
})
