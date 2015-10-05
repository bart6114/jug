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
              res<-new_response()
              req<-new_request(req)
              err<-new_error()

              path<-req$path
              method<-req$method

              body<-NULL

              for(mw in self$middlewares){

                if((grepl(path,mw$path, perl = TRUE) && (mw$method == method || is.null(mw$method))) ||
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
#' @export
get<-function(x, ...){
  UseMethod("get", x)
}

#' Function to add GET-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
get.Jug<-function(jug, path, func){
  add_middleware(jug, func, path, method="GET")
}

#' Function to add POST-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
post<-function(jug, path, func){
  add_middleware(jug, func, path, method="POST")
}

#' Function to add PUT-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
put<-function(jug, path, func){
  add_middleware(jug, func, path, method="PUT")
}

#' Function to add DELETE-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
delete<-function(jug, path, func){
  add_middleware(jug, func, path, method="DELETE")
}


#' Function to add request method insensitive middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
use<-function(jug, path, func){
  add_middleware(jug, func, path, method=NULL)
}
