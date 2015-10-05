library(jug)
library(httr)

context("testing get requests")

test_that("The correct response is returned for a (bare) GET request",{
  j<-jug() %>%
    get("/", function(req,res,err){
      return("test")
      }) %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/")

  stop_daemon(j)

  expect_equal(content(res, "text"), "test")

})


test_that("The correct response is returned for a GET request with query params",{
  j<-jug() %>%
    get("/", function(req,res,err){
      return(req$query_params$x)
    }) %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/?x=test")

  stop_daemon(j)

  expect_equal(content(res, "text"), "test")

})


test_that("The correct response is returned for a GET request with headers",{
  j<-jug() %>%
    get("/", function(req,res,err){
      req$get_header("x")
    }) %>%
    serve_it(daemonized=TRUE)

  res<-
    GET("http://127.0.0.1:8080/", add_headers(x="test"))

  stop_daemon(j)

  expect_equal(content(res, "text"), "test")

})
