library(jug)

context("testing function decorator")





test_that("The correct response is returned by a decorated function (using a querystring value)",{
  test_req<-RawTestRequest$new()
  test_req$query_string("?x=test")

  my_func<-function(x){x}

  res<-jug() %>%
    get("/", decorate(my_func)) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})

test_that("The correct response is returned by a decorated function (using a header value)",{
  test_req<-RawTestRequest$new()
  test_req$set_header("x", "test")

  my_func<-function(x){x}

  res<-
    jug() %>%
    get("/", decorate(my_func)) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})
