library(jug)

context("testing CORS functionality")

test_req_OPTIONS <-RawTestRequest$new()
test_req_OPTIONS$method("OPTIONS")

test_that("Preflight request receives the right headers",{

  res<-jug() %>%
    cors("/", allow_headers = "Authorization") %>%
    process_test_request(test_req_OPTIONS$req)

  expect_true('Access-Control-Allow-Origin' %in% names(res$headers))
  expect_true('Access-Control-Allow-Methods' %in% names(res$headers))
  expect_true('Access-Control-Allow-Headers' %in% names(res$headers))

})

test_req<-RawTestRequest$new()

test_that("Access-Control-Allow-Origin default is set to permissive",{

  res<-jug() %>%
    cors("/") %>%
    get("/", function(req,res,err){
      "foo"
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$headers[['Access-Control-Allow-Origin']], "*")

})

test_that("Access-Control-Allow-Origin is settable through cors()",{

  res<-jug() %>%
    cors("/", allow_origin="foo") %>%
    get("/", function(req,res,err){
      "the get req"
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$headers[['Access-Control-Allow-Origin']], "foo")

})


test_that("Access-Control-Allow-Methods is settable through cors()",{

  res<-jug() %>%
    cors("/", allow_methods=c("GET", "PUT"), max_age=3600) %>%
    get("/", function(req,res,err){
      "the get req"
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$headers[['Access-Control-Allow-Methods']], "GET,PUT")
  expect_equal(res$headers[['Access-Control-Max-Age']], 3600)

})
