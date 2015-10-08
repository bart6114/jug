library(jug)

context("testing get requests")


test_that("get_passed_params returns correctly",{

  expect_equal(get_passed_params("?a=b&c=d"),
               list(a="b", c="d"))

  expect_equal(get_passed_params("?"),
               list())

  expect_equal(get_passed_params(""),
               list())

})
