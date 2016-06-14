library(jug)

context("testing post data parsing")

test_req<-RawTestRequest$new()
test_req$body("y=3&x=4")
test_req$method("post")
test_req$set_header("Content-Type", "application/x-www-form-urlencoded")

test_that("The url-encoded data set in post data is correctly parsed",{

  res<-jug() %>%
    post("/", function(req,res,err){
      paste0(req$params$y,req$params$x)
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "34")

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

test_that("Same as above but now for JSON POST request",{

  test_req<-RawTestRequest$new()
  test_req$method("post")
  test_req$set_header("CONTENT_TYPE", "application/json", prefix = "")
  test_req$body('{"y":3, "x":4}')

  res<-jug() %>%
    post("/", function(req,res,err){
      paste0(req$params$y,req$params$x)
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$body, "34")

})
#
# test_that("multipart data is correctly parsed", {
#
#   mp_body<-
# '----WebKitFormBoundary7MA4YWxkTrZu0gW
# Content-Disposition: form-data; name="submissionType"
#
# intermediary
# ----WebKitFormBoundary7MA4YWxkTrZu0gW
# Content-Disposition: form-data; name="teamName"
#
# Here for Beer
# ----WebKitFormBoundary7MA4YWxkTrZu0gW'
#
#   test_req<-RawTestRequest$new()
#   test_req$method("post")
#   test_req$set_header("CONTENT_TYPE", "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW", prefix = "")
#   test_req$body(mp_body)
#
#   res<-jug() %>%
#     post("/", function(req,res,err){
#       paste0(req$params$y,req$params$x)
#     }) %>%
#     process_test_request(test_req$req)
#
#   print(res$params)
#   expect_equal(res$params$teamName, "Here for Beer")
#
#
#
# })
