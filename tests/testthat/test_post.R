library(jug)

context("testing post data parsing")

test_req<-RawTestRequest$new()
test_req$post_data("y=3")

test_that("The url-encoded data set in post data is correctly parsed",{

  res<-jug() %>%
    get("/", function(req,res,err){
      req$params$y
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "3")

})
