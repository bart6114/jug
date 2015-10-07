library(jug)

context("testing function decorator")


test_req<-RawTestRequest$new()
test_req$query_string("?x=test")

test_that("The correct response is returned by a decorated function",{
  my_func<-function(x){x}

  res<-jug() %>%
    get("/", decorate(my_func)) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})
