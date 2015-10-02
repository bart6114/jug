library(jug)

context("testing handler adding")

test_that("handlers are correctly added to the jug instance",{
  j<-
    jug() %>%
    get("/", function(req, res){"test"})

  expect_equal(length(j$middleware_handler$middlewares), 1)
})
