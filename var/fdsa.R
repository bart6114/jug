# library(interfacer)
# library(infuser)
#
#
#
# req<-list()
#
# showReq<-function(req){req<<-req;print(req$REQUEST_METHOD);paste(ls(req), collapse=",<br>")}
# helloWorld<-function(x=6){paste("Hello world", x)}
# headerTest<-function(HTTP_TEST){paste("Hello world", HTTP_TEST)}
#
#
# library(magrittr)
# interfacer() %>%
#   add_path("/showReq", showReq, res_content_type = "text/html") %>%#   add_path("/helloWorld", helloWorld) %>%
#   add_path("/headerTest", headerTest) %>%
#   add_path("/", function(...){
#     print(list(...))
#     infuse("var/index.html", key_value_list=list(...))
#   }, res_content_type = "text/html") %>%
#   start_interface(verbose=T)

library(interfacer)
library(magrittr)
library(jsonlite)

my_func<-function(x){ paste("hello world:",x)}

beakr() %>%
  get("/",
      function(req, res){
        print(req$query_params)
        print(res$headers)
        res$set_header("my_val", "3")
        toJSON(res$headers, auto_unbox=T)
      }
  ) %>%
  get("/test",
      function(req, res){
        "3"
      }
  ) %>%
  get("/myfunc", decorate(my_func)) %>%
  use(path = NULL, function(req, res){
    res$status=404L
    "no route bound to handler"
  }) %>%
  serve_it()
