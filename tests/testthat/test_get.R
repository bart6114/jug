library(jug)

context("testing handlers")

test_that("handlers are correctly added to the jug instance",{
  j<-
    jug() %>%
    gett("/", function(req, res){"test"})

  expect_equal(length(j$middleware_handler$middlewares), 1)
})
