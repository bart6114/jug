library(jug)

context("testing get requests")

test_req<-RawTestRequest$new()


test_that("The multiple middlewares set up for one GET path",{

  set_user_id<-function(req, res, err){
    req$set_header("userId", "test")
  }

  res<-jug() %>%
    get("/",
        set_user_id,
        function(req,res,err) req$get_header("userId")
    ) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})


