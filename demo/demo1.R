library(jug)
library(jsonlite)

my_func<-function(x=5){ paste("hello world:",x)}

jug() %>%
  gett("/",
      function(req, res){
        print(req$query_params)
        print(res$headers)
        res$set_header("my_val", "3")
        toJSON(res$headers, auto_unbox=T)
      }
  ) %>%
  gett("/test",
      function(req, res){
        "3"
      }
  ) %>%
  gett("/myfunc", decorate(my_func, content_type="application/json")) %>%
  postt("/", function(req,res){"33"}) %>%
  use(path = NULL, function(req, res){
    res$status=404L
    "no route bound to handler"
  }) %>%

  serve_it()
