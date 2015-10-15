library(jug)

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

test_that("The correct response is returned for a GET request with JSON returned",{

  res<-jug() %>%
    get("/", function(req,res,err){
      res$json(list(a=3))
    }) %>%
    process_test_request(test_req$req)

  expect_equal(as.character(res$body), '{"a":3}')

})


test_that("The correct response is returned for a (bare) GET request to non-root paths if root is specified",{

  test_req$path("/test")

  res<-jug() %>%
    get("/", function(req,res,err){
      return("test")
    }) %>%
    get("/test", function(req,res,err){
      return("test2")
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test2")

})

test_that("The correct response is returned for a GET request with query params",{

  test_req$path("/")

  res<-jug() %>%
    get("/", function(req,res,err){
      return(req$params$x)
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


test_that("The correct response is returned for a (bare) GET request to a 'parameterised' path",{

  test_req$path("/test/abc/123")

  res<-jug() %>%
    get("/test/(?<id>.*)/(?<id2>.*)", function(req,res,err){
      paste0(req$params$id,req$params$id2)
    }) %>%
    simple_error_handler() %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "abc123")

})

test_that("The correct response is returned for a (bare) GET request with an explicitely set body",{

  test_req<-RawTestRequest$new()
  res<-jug() %>%
    get("/", function(req,res,err){
      res$text("test")
      return(NULL)
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})
