library(jug)

context("testing including collectors")

test_req<-RawTestRequest$new()

test_that("A local collector is correctly included",{

  collected_mw<-
    collector() %>%
    get("/", function(req,res,err){
      return("test")
    })

  res<-jug() %>%
    include(collected_mw) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test")

})


test_that("An external collector is correctly included",{

  res<-jug() %>%
    include(collected_mw2, "helper_collected_mw2.R") %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "test2")

})


