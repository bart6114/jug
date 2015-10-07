library(jug)

context("testing req functions")

jug_req<-Request$new(RawTestRequest$new()$req)

test_that("A variable is correctly attached to a request",{
  jug_req$attach("testkey", "test")

  expect_equal(jug_req$attached$testkey, "test")
})