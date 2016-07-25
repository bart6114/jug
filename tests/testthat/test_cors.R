library(jug)

context("CORS functionality")

test_req<-RawTestRequest$new()

test_that("Access-Control-Allow-Origin default is set to permissive",{

  res<-jug() %>%
    get("/", function(req,res,err){
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$headers[['Access-Control-Allow-Origin']], "*")

})

test_that("Access-Control-Allow-Origin default is overridable",{

  res<-jug() %>%
    get("/", function(req,res,err){
      res$set_header("Access-Control-Allow-Origin", "not-permissive")
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$headers[['Access-Control-Allow-Origin']], "not-permissive")

})
