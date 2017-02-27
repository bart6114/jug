#' Basic authentication middleware
#'
#' @param account_eval_func a function to which the username and password arguments will be passed and which should return \code{TRUE} for a valid combination and \code{FALSE} for an invalid one.
#' @param basic_realm the user visible realm that will be returned through the \code{WWW-Authenticate} header in case of an unauthenticated request
#'
#' @export
auth_basic<-function(account_eval_func, basic_realm = "this_jug_server"){
  function(req, res, err){

    # function which sets the correct status / body if an authentication error occurs
    auth_error <- function(){
      res$set_status(401)
      res$set_header("WWW-Authenticate", paste0('Basic realm="', basic_realm,'"'))
      res$text("Basic authentication error")
    }

    # check if 'authorization' header is present
    if(is.null(req$get_header("authorization"))){
      auth_error()
    } else {
      auth_header <- unlist(strsplit(req$get_header("authorization"), " "))
      auth_type <- auth_header[1]
      auth_userpass <- unlist(strsplit(rawToChar(base64enc::base64decode(auth_header[2])), ":"))

      # check for error/invalid cases
      if(!all(!is.na(auth_userpass),
              length(auth_userpass) == 2,
              tolower(auth_type) == "basic",
              account_eval_func(username = auth_userpass[1],
                                password = auth_userpass[2]))){
        auth_error()
      } else
        return(NULL)
    }
  }
}
