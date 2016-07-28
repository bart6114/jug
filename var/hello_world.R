# for example usage in the Dockerfile

library(jug)

jug() %>%
  get(path=NULL, function(req, res, err) "Hello World!") %>%
  simple_error_handler_json() %>%
  serve_it(host = Sys.getenv("JUG_HOST"), port = as.integer(Sys.getenv("JUG_PORT")))
