#' Convenience function to decorate existing functions
#'
#' @param func the function to decorate
#' @param content_type the content type to set on the response object
#'
#' @importFrom utils modifyList
#' @export
decorate<-function(func, content_type="text/html"){
  # check which parameters the function allows
  args_allowed<-
    names(formals(func))

  # create new function for it
  function(req, res, err){
    res$content_type(content_type)

    passed_params<-
      modifyList(req$params, req$headers)

    passed_params$req<-req
    passed_params$res<-res
    passed_params$err<-err

    # drop not requested params from query params
    if(!"..." %in% args_allowed){
      passed_params<-
        passed_params[names(passed_params) %in% args_allowed]
    }

    do.call(func, passed_params)
  }

}
