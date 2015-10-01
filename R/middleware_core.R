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
              path<-req$path
              method<-req$method

              body<-NULL

              for(mw in self$middlewares){

                if((mw$path==path && (mw$method == method || is.null(mw$method))) ||
                   (mw$method==method && is.null(mw$path)) ||
                   (is.null(mw$method) && is.null(mw$path))
                ){

                  body<-mw$func(req=req, res=res)

                  if(!is.null(body)){
                    res$set_body(body)
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
#' @param server the server instance
#' @param func the function to bind
#' @param path the path to bind to
#' @param method the method to bind to
add_middleware<-function(server, func, path=NULL, method=NULL){
  mw<-Middleware$new(func, path, method)

  server$middleware_handler$add_middleware(mw)

  server
}

#' Function to add GET middleware
#'
#' @param server the server object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
get<-function(server, path, func){
  add_middleware(server, func, path, method="GET")
}

#' Function to add POST middleware
#'
#' @param server the server object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
post<-function(server, path, func){
  add_middleware(server, func, path, method="POST")
}

#' Function to add request method insensitive middleware
#'
#' @param server the server object
#' @param path the path to bind to
#' @param func the function to bind to the path (will receive the params \code{req} and \code{res})
#'
#' @export
use<-function(server, path, func){
  add_middleware(server, func, path, method=NULL)
}
