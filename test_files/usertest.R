library(jug)

jug() %>%
  get("/login", function(req, res, err){
    "please login here :)"
  }) %>%
  # require authentication
  use(path=NULL, function(req, res, err){
    if(is.null(req$get_header("user_id"))){
      res$redirect("/login")
    }
  }) %>%
  simple_error_handler() %>%
#   use(path=NULL, function(req, res, err){
#     if(!is.null(req$get_header("userid"))
#     "fds"
  # }) %>%
  serve_it()
