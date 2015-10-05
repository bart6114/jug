library(jug)
library(httr)

context("testing function decorator")

test_that("The correct response is returned by a decorated function",{
  my_func<-function(x){x}

  j<-jug() %>%
    get("/", decorate(my_func)) %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/?x=test")

  stop_daemon(j)

  expect_equal(content(res, "text"), "test")

})
