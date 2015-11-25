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
            invoke=function(req, ws_message = NULL, ws_binary = NULL){
              res<-Response$new()
              req<-Request$new(req)
              err<-new_error()

              body<-NULL


              for(mw in self$middlewares){

                # if there are named capture groups in the path, add them to req$params
                path_processed<-match_path(mw$path, req$path)

                req$add_params(path_processed$params)

                # REFACTOR!

                if(any(
                  (req$protocol=="http" && any(
                    path_processed$match && (mw$method == req$method),
                    path_processed$match && is.null(mw$method),
                    is.null(mw$path) && (mw$method == req$method),
                    is.null(mw$path) && is.null(mw$method)
                  )),
                  (req$protocol=="websocket" && any(
                    path_processed$match,
                    is.null(mw$path)
                  ))
                )){


                  body<-
                    try(
                      switch(req$protocol,
                             "http"=mw$func(req=req, res=res, err=err),
                             "websocket"=mw$func(binary=ws_binary, message=ws_message, res=res, err=err)),
                      silent=TRUE
                    )

                  if('try-error' %in% class(body)){
                    # process it further (will be catched by errorhandler)
                    err$set(as.character(body))
                    body<-NULL
                  }

                  # if return values is not NULL, use it as body (unless set explicitely)
                  if(is.null(res$body) && !is.null(body)) res$set_body(body)

                  if(!is.null(res$body)){
                    break
                  }
                }
              }

              if(getOption("jug.verbose")){
                cat(toupper(req$protocol), "|", req$path,"-", req$method, "-", res$status, "\n" ,sep = " ")
              }

              res$structured(req$protocol)
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
            protocol=NULL,
            initialize=function(func, path, method, websocket){
              self$func=func
              self$path=path
              self$method=method
              self$protocol=if(websocket) "websocket" else "http"
            }
          ))





#' Internal function to add middleware
#'
#' @param jug the jug instance
#' @param func the function to bind
#' @param path the path to bind to
#' @param method the method to bind to
#' @param websocket should the middleware bind to the websocket protocol
add_middleware<-function(jug, func, path=NULL, method=NULL, websocket=FALSE){
  method<-if(!is.null(method)) toupper(method) else NULL
  mw<-Middleware$new(func, path, method, websocket)

  jug$middleware_handler$add_middleware(mw)

  jug
}

#' Function to add GET-binding middleware
#'
#' The params to this function are slightly different from \code{post}, \code{put} and the like due to \code{get} being a base function.
#'
#' @param object the jug object
#' @param ... first argument should be the \code{path} followed by middelware functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{post}}, \code{\link{put}}, \code{\link{delete}}, \code{\link{use}}, \code{\link{ws}}
#' @export
get<-function(object, ...) UseMethod("get")

#' @describeIn get Function to add GET-binding middleware
#' @export
get.Jug<-function(object, ...){
  funcs<-list(...)
  path<-funcs[[1]]
  funcs<-funcs[-1]

  lapply(funcs, function(mw_func) add_middleware(object, mw_func, path, method="GET"))

  object
}

#' Function to add POST-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{get}}, \code{\link{put}}, \code{\link{delete}}, \code{\link{use}}, \code{\link{ws}}
#' @export
post<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="POST"))

  jug
}

#' Function to add PUT-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{post}}, \code{\link{get}}, \code{\link{delete}}, \code{\link{use}}, \code{\link{ws}}
#' @export
put<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="PUT"))

  jug
}

#' Function to add DELETE-binding middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{post}}, \code{\link{put}}, \code{\link{get}}, \code{\link{use}}, \code{\link{ws}}
#' @export
delete<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method="DELETE"))

  jug
}


#' Function to add request method insensitive middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{post}}, \code{\link{put}}, \code{\link{delete}}, \code{\link{get}}, \code{\link{ws}}
#' @export
use<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method=NULL))

  jug
}

#' Function to add websocket handling middleware
#'
#' @param jug the jug object
#' @param path the path to bind to
#' @param ... functions (order matters) to bind to the path (will receive the params \code{req}, \code{res} and \code{err})
#'
#' @seealso \code{\link{post}}, \code{\link{put}}, \code{\link{delete}}, \code{\link{get}}, \code{\link{get}}
#' @export
ws<-function(jug, path, ...){
  lapply(list(...), function(mw_func) add_middleware(jug, mw_func, path, method=NULL, websocket=TRUE))

  jug
}

