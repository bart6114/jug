library(jug)
library(jsonlite)

my_func<-function(x){ paste("hello world:",x)}

jug() %>%
  gett("/",
      function(req, res, err){
        print(req$query_params)
        print(res$headers)
        res$set_header("my_val", "3")
        toJSON(res$headers, auto_unbox=T)
        stop(simpleError("fdsfds"))
      }
  ) %>%
  gett("/test",
      function(req, res, err){
        "3"
      }
  ) %>%
  gett("/myfunc", decorate(my_func, content_type="application/json")) %>%
  postt("/", function(req,res){"33"}) %>%
  simple_error_handler() %>%
  serve_it()
