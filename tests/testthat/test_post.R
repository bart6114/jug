library(jug)

context("testing post data parsing")

test_req<-RawTestRequest$new()
test_req$post_data("y=3")
test_req$method("post")

test_that("The url-encoded data set in post data is correctly parsed",{

  res<-jug() %>%
    post("/", function(req,res,err){
      req$params$y
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "3")

})


test_that("Same as above but now for put request",{

  test_req$method("put")

  res<-jug() %>%
    put("/", function(req,res,err){
      req$params$y
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "3")

})

test_that("Same as above but now for delete request",{

  test_req$method("delete")

  res<-jug() %>%
    delete("/", function(req,res,err){
      req$params$y
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "3")

})
