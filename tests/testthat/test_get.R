library(jug)
library(RCurl)

context("testing simple get request")

test_that("The correct response is returned for a (bare) GET request",{
  j<-jug() %>%
    get("/", function(req,res,err){
      return("test")
      }) %>%
    serve_it(daemonized=TRUE)

  res<-
    RCurl::getURL("http://127.0.0.1:8080/")

  stop_daemon(j)

  expect_equal(res, "test")

})
