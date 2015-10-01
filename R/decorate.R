#' Convenience function to decorate existing functions
#'
#' @param func the function to decorate
#' @export
decorate<-function(func, content_type="text/html"){
  # check which parameters the function allows
  args_allowed<-
    names(formals(func))

  # create new function for it
  function(req, res){
    res$content_type(content_type)

    passed_params<-
      modifyList(req$query_params, req$headers)

    # drop not requested params from query params
    if(!"..." %in% args_allowed){
      passed_params<-
        passed_params[names(passed_params) %in% args_allowed]
    }

    do.call(func, passed_params)
  }

}
