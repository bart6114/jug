library(jug)
library(httr)

context("testing get requests")

test_that("A status 404 is returned for a request to an undefined path",{
  j<-jug() %>%
    simple_error_handler() %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/")

  stop_daemon(j)

  expect_equal(status_code(res), 404)

})


test_that("A status 500 is returned for a request with an error in processing",{
  j<-jug() %>%
    get('/', function(req, res, err){
      stop("an error occurred")
    }) %>%
    simple_error_handler() %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/")

  stop_daemon(j)

  expect_equal(status_code(res), 500)

})
