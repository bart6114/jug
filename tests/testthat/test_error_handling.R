library(jug)

context("testing get requests")


test_req<-RawTestRequest$new()

test_that("A status 404 is returned for a request to an undefined path",{
  res<-jug() %>%
    simple_error_handler() %>%
    process_test_request(test_req$req)

  expect_equal(res$status, 404)

})


test_that("A status 500 is returned for a request with an error in processing",{
  res<-jug() %>%
    get('/', function(req, res, err){
      stop("an error occurred")
    }) %>%
    simple_error_handler() %>%
    process_test_request(test_req$req)

  expect_equal(res$status, 500)

})
