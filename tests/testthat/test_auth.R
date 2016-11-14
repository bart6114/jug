library(jug)
library(base64enc)

context("testing authorization middleware")

test_req<-RawTestRequest$new()

valid_combo<-function(username, password){
  username == password
}

test_that("status 200 is returned for a correct user/pass combination",{

  test_req$set_header("authorization", paste0("basic ", base64encode(charToRaw("test:test"))))

  res<-jug() %>%
    use(NULL, auth_basic(valid_combo)) %>%
    get("/", function(req,res,err){
      "test"
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$status, 200)

})


test_that("status 401 is returned for an incorrect user/pass specication",{

  test_req$set_header("authorization", paste0("basic ", base64encode(charToRaw("test1:test"))))

  res<-jug() %>%
    use(NULL, auth_basic(valid_combo)) %>%
    get("/", function(req,res,err){
      "test"
    }) %>%
    process_test_request(test_req$req)



  expect_equal(res$status, 401)
  expect_equal(res$headers[["WWW-Authenticate"]], 'Basic realm="this_jug_server"')


  test_req$set_header("authorization", paste0("basic ", base64encode(charToRaw(":test"))))

  res<-jug() %>%
    use(NULL, auth_basic(valid_combo)) %>%
    get("/", function(req,res,err){
      "test"
    }) %>%
    process_test_request(test_req$req)



  expect_equal(res$status, 401)


  test_req$set_header("authorization", paste0("basic ", base64encode(charToRaw("test1:"))))

  res<-jug() %>%
    use(NULL, auth_basic(valid_combo)) %>%
    get("/", function(req,res,err){
      "test"
    }) %>%
    process_test_request(test_req$req)

  expect_equal(res$status, 401)


  test_req$set_header("authorization", paste0("basic ", base64encode(charToRaw(""))))

  res<-jug() %>%
    use(NULL, auth_basic(valid_combo)) %>%
    get("/", function(req,res,err){
      "test"
    }) %>%
    process_test_request(test_req$req)



  expect_equal(res$status, 401)

})
