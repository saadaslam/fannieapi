context("test-get_indicator")

test_that("not setting an API key will result in error", {
  expect_error(
    get_indicator("housing", "housing-starts-single-family"),
    "Please set an API key with `fannieapi::set_api_key()`",
    fixed = TRUE
  )
})
