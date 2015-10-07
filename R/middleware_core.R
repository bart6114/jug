library(R6)

#' MiddlewareHandler R6 class definition
#'
#' @import R6
MiddlewareHandler<-
  R6Class("MiddlewareHandler",
          public=list(
            middlewares=c(),

            add_middleware=function(mw){
              self$middlewares<-c(self$middlewares, mw)

            },
            invoke=function(req){
              res<-Response$new()
              req<-Request$new(req)
              err<-new_error()

              path<-req$path
              method<-req$method

              body<-NULL


              for(mw in self$middlewares){

                # if there are named capture groups in the path, add them to req$params
                match_path<-re_capture(mw$path, path)

                if(length(match_path$names)>0) req$add_params(match_path$names)

                if((match_path$match && (mw$method == method || is.null(mw$method))) ||
                   (mw$method==method && is.null(mw$path)) ||
                   (is.null(mw$method) && is.null(mw$path))
                ){

                  body<-try(
                    mw$func(req=req, res=res, err=err),
                    silent = TRUE
                  )

                  if('try-error' %in% class(body)){
                    # process it further (will be catched by errorhandler)
                    err$set(as.character(body))
                    body<-NULL
                  }

                  if(!is.null(body)){
                    if(is.null(res$body)) res$set_body(body) # explicitly set body will prevail
                    break
                  }
                }
              }

              res$structured()
            }
          )
  )


#' Middleware class
#'
#' @import R6
Middleware<-
  R6Class("Middleware",
          public=list(
            path=NULL,
            func=NULL,
            method=NULL,
            initialize=function(func, path, method){
              self$func=func
              self$path=path
              self$method=method
            }
          ))





#' Internal function to add middleware
#'
#' @param jug the jug instance
#' @param func the function to bind
#' @param path the path to bind to
#' @param method the method to bind to
add_middleware<-function(jug, func, path=NULL, method=NULL){
  mw<-Middleware$new(func, path, method)

  jug$middleware_handler$add_middleware(mw)

  jug
}

#' Set up generic method (otherwise base::get is masked)
#'
#' @param object the object to pass to get
#' @param ... other arguments passed to get
#'
#' @export
get<-function(object, ...) UseMethod("get")

#' @export
get.default <- function(object, ...) base::get(object)

#' Function to add GET-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @export
get.Jug<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="GET"))

  jug
}

#' Function to add POST-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
post<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="POST"))

  jug
}

#' Function to add PUT-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
put<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="PUT"))

  jug
}

#' Function to add DELETE-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
delete<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="DELETE"))

  jug
}


#' Function to add request method insensitive middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
use<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method=NULL))

  jug
}

