library(jug)

context("testing static file server middleware")

test_req<-RawTestRequest$new()

test_that("The static file is loaded correctly",{
  test_req$path("/")

  res<-
    jug() %>%
    serve_static_files() %>%
    simple_error_handler_json() %>%
    process_test_request(test_req$req)

  expect_true(grepl("test", res$body))

  test_req$path("/index.html")

  res<-
    jug() %>%
    serve_static_files() %>%
    simple_error_handler_json() %>%
    process_test_request(test_req$req)

  expect_true(grepl("test", res$body))
})

test_that("The static file is loaded correctly when the middleware is bound to a path",{
  test_req$path("/path_a/")

  res<-
    jug() %>%
    serve_static_files(path="path_a/") %>%
    simple_error_handler_json() %>%
    process_test_request(test_req$req)

  expect_true(grepl("test", res$body))


  test_req$path("/path_a/index.html")
  res<-
    jug() %>%
    serve_static_files(path="path_a/") %>%
    simple_error_handler_json() %>%
    process_test_request(test_req$req)

  expect_true(grepl("test", res$body))


})

