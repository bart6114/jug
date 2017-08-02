#' Middleware class
#'
#' @import R6
Listener<-
  R6Class("Listener",
          public=list(
            event=NULL,
            func=NULL,
            initialize=function(func, event){
              self$func=func
              self$event=event
            }
          ))

#' Internal function to add listeners
#'
#' @param jug the jug instance
#' @param func the function to bind
#' @param event the event to bind to
add_listener<-function(jug, func, event){
  mw<-Listener$new(func, event)
  jug$request_handler$add_listener(mw)

  jug
}

#' Function to add an event listener
#'
#' @param jug the jug instance
#' @param event the event to bind to (one of \code{start}, \code{finish} or \code{error})
#' @param func the function to pass the \code{req}, \code{res}, \code{err} and (if \code{error} event) the \code{err_msg} to
#' @param ... extra arguments to pass to the listener function
#'
#' @seealso \code{\link{post}}, \code{\link{put}}, \code{\link{delete}}, \code{\link{use}}, \code{\link{ws}}
#' @export
on <- function(jug, event, func, ...){
  add_listener(jug, func, event)
}
