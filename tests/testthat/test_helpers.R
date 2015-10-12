library(jug)

context("testing get requests")


test_that("parse_query returns correctly",{

  expect_equal(parse_query("?a=b&c=d"),
               list(a="b", c="d"))

  expect_equal(parse_query("?"),
               list())

  expect_equal(parse_query(""),
               list())

  expect_equal(parse_query(character(0)),
               list())

})
