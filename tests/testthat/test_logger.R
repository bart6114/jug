library(jug)

context("testing logger")

test_req<-RawTestRequest$new()
#test_req$method("get")
#test_req$set_header("Content-Type", "application/x-www-form-urlencoded")

test_that("that the logger outputs something to the console at DEBUG level",{
  expect_output({
    jug() %>%
      get("/", function(req, res, err){"test"})  %>%
      logger(threshold=futile.logger::DEBUG) %>%
      simple_error_handler_json() %>%
      process_test_request(test_req$req)
  }, regexp = "INFO")
})

test_that("that the logger outputs something to the console at ERROR level",{
  expect_output({
    jug() %>%
      get("/", function(req, res, err){stop(3)})  %>%
      logger(threshold=futile.logger::DEBUG) %>%
      simple_error_handler_json() %>%
      process_test_request(test_req$req)
  }, regexp = "ERROR")
})
