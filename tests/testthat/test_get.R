library(jug)
library(httr)

context("testing get requests")

test_req<-RawTestRequest$new()
test_req$query_string("?x=test")
test_req$set_header("x", "test")


test_that("The correct response is returned for a (bare) GET request",{

  res<-jug() %>%
    get("/", function(req,res,err){
      return("test")
      }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})


test_that("The correct response is returned for a GET request with query params",{
  res<-jug() %>%
    get("/", function(req,res,err){
      return(req$query_params$x)
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})


test_that("The correct response is returned for a GET request with headers",{
  res<-jug() %>%
    get("/", function(req,res,err){
      req$get_header("x")
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})
