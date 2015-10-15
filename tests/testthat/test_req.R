library(jug)

context("testing Request class")

jug_req<-Request$new(RawTestRequest$new()$req)

test_that("A variable is correctly attached to a request",{
  jug_req$attach("testkey", "test")

  expect_equal(jug_req$params$testkey, "test")
})
