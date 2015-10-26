library(jug)

context("testing static file server middleware")

test_req<-RawTestRequest$new()
test_req$path("/")



test_that("The static file is loaded correctly",{
  res<-
    jug() %>%
    serve_static_files() %>%
    simple_error_handler() %>%
    process_test_request(test_req$req)

  expect_true(grepl("test", res$body))
})
