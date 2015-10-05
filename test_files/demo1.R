library(jug)
library(jsonlite)

my_func<-function(x){ paste("hello world:",x)}

jug() %>%
  get("/",
      function(req, res, err){
        # print(req$query_params)
        # print(res$headers)
        res$set_header("my_val", "3")
        res$set_header("Set-Cookie", "theme=3")
        toJSON(res$headers, auto_unbox=T)
        stop(simpleError("fdsfds"))
      }
  ) %>%
  get("/test",
      function(req, res, err){
        "3"
      }
  ) %>%
  get("/myfunc", decorate(my_func, content_type="application/json")) %>%
  post("/", function(req, res, err){"33"}) %>%
  put("/puttest", function(req,res, err){

    print(req$post_data)

    print(req$method)

    }) %>%
  serve_static_files() %>%
  simple_error_handler() %>%
  serve_it()
