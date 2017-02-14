#' Convenience function to decorate existing functions
#'
#' @param func the function to decorate
#' @param content_type the content type to set on the response object
#' @param strict_params if TRUE and not all parameters needed for func
#'
#' @importFrom utils modifyList
#' @export
decorate<-function(func, content_type="text/html", strict_params=FALSE){
  # check which parameters the function allows
  args_allowed<-
    names(formals(func))

  # create new function for it
  function(req, res, err){
    res$content_type(content_type)

    # inspect passed params
    passed_params<-
      modifyList(req$params, req$headers)

    passed_params$req<-req
    passed_params$res<-res
    passed_params$err<-err

    if(strict_params){
      # error if not all args requested by function are present
      args_present <- sapply(args_allowed, function(p) p %in% names(passed_params))
      if(!all(args_present)){

        err$set(paste0("Requested arguments not provided: ", paste(args_allowed[!args_present], collapse=", ")))
        return(NULL)
      }
    }


    # drop not requested params from query params
    if(!"..." %in% args_allowed){
      passed_params<-
        passed_params[names(passed_params) %in% args_allowed]
    }

    do.call(func, passed_params)
  }

}
