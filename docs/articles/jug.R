## ---- eval=FALSE---------------------------------------------------------
#  library(jug)
#  
#  jug() %>%
#    get("/", function(req, res, err){
#      "Hello World!"
#    }) %>%
#    simple_error_handler_json() %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  devtools::install_github("Bart6114/jug")

## ---- eval=FALSE---------------------------------------------------------
#  install.packags("jug")

## ------------------------------------------------------------------------
library(jug)

## ---- warning=FALSE, message=FALSE---------------------------------------
jug()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    use(path = NULL, function(req, res, err){
#      "test 1,2,3!"
#      }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    use(path = "/", function(req, res, err){
#      "test 1,2,3!"
#      }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    get(path = "/", function(req, res, err){
#      "get test 1,2,3!"
#      }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    get(path = "/", function(req, res, err){
#      "get test 1,2,3 on path /"
#      }) %>%
#    get(path = "/my_path", function(req, res, err){
#      "get test 1,2,3 on path /my_path"
#      }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#     ws("/echo_message", function(binary, message, res, err){
#      message
#    }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#   collected_mw<-
#      collector() %>%
#      get("/", function(req,res,err){
#        return("test")
#      })
#  
#    res<-jug() %>%
#      include(collected_mw) %>%
#      serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  library(jug)
#  
#  collected_mw<-
#    collector() %>%
#    get("/", function(req,res,err){
#      return("test2")
#    })

## ---- eval=FALSE---------------------------------------------------------
#  res<-jug() %>%
#    include(collected_mw, "my_middlewares.R") %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    simple_error_handler() %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  say_hello<-function(name){paste("hello",name,"!")}
#  
#  jug() %>%
#    get("/", decorate(say_hello)) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    serve_static_files() %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    cors() %>%
#    get("/", function(req, res, err){
#      "Hello World!"
#    }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  # dummy account checker
#  account_checker <- function(username, password){
#    # do something to verify the username and password and return TRUE if combination OK
#    all(username == "test_user",
#        password == "test_password")
#  }

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    get("/", function(req, res, err){
#      "/ req"
#    }) %>%
#    get("/test", auth_basic(account_checker), function(req, res, err){
#      "/test req"
#    }) %>%
#    serve_it()

## ---- eval=FALSE---------------------------------------------------------
#  jug() %>%
#    use(NULL, auth_basic(account_checker)) %>%
#    get("/", function(req, res, err){
#      "/ req"
#    }) %>%
#    serve_it()

## ------------------------------------------------------------------------
head(mtcars)

mpg_model<-
  lm(mpg~gear+hp, data=mtcars)

summary(mpg_model)

## ------------------------------------------------------------------------
predict_mpg <- function(gear, hp){
  predict(mpg_model, 
          newdata = data.frame(gear=as.numeric(gear), 
                               hp=as.numeric(hp)))[[1]]
}

## ------------------------------------------------------------------------
predict_mpg(gear = 4, hp = 80)

## ---- eval=F-------------------------------------------------------------
#  jug() %>%
#    post("/predict-mpg", decorate(predict_mpg)) %>%
#    simple_error_handler_json() %>%
#    serve_it()

