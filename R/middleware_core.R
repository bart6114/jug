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
              path<-req$PATH_INFO
              method<-req$REQUEST_METHOD
              body<-NULL

              for(mw in self$middlewares){

                if((mw$path==path && (mw$method == method || is.null(mw$method))) ||
                   (mw$method==method && is.null(mw$path)) ||
                   (is.null(mw$method) && is.null(mw$path))
                   ){

                  body<-mw$func(req, res)

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


add_middleware<-function(server, func, path=NULL, method=NULL){
  mw<-Middleware$new(func, path, method)

  server$middleware_handler$add_middleware(mw)

  server
}

#' @export
get<-function(server, path, func){
  add_middleware(server, func, path, method="GET")
}

#' @export
post<-function(server, path, func){
  add_middleware(server, func, path, method="POST")
}

#' @export
use<-function(server, path, func){
  add_middleware(server, func, path, method=NULL)
}
