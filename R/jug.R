#' The Jug class
#'
#' @importFrom magrittr %>%
Jug<-R6::R6Class("Jug",
             public=list(
               middleware_handler=NULL,
               daemon_obj=NULL,
               app_definition=function(){
                 list(
                   call=function(req){
                     self$middleware_handler$invoke(req)
                   },
                   onWSOpen=function(ws){
                     ws$onMessage(function(binary, message) {
                       ws$send(self$middleware_handler$invoke(ws$request,
                                                              ws_message=message,
                                                              ws_binary=binary)
                       )
                     })
                   }
                 )
               },
               add_collected_middelware=function(collector){
                 self$middleware_handler$add_middleware(collector$middleware_handler$middlewares)
               },
               initialize=function(){
                 self$middleware_handler=MiddlewareHandler$new()
                 options("jug.verbose"=FALSE) # set early for testing purposes were serve_it isn't called
               },
               start=function(host, port, daemonized){
                 if(daemonized){
                   self$daemon_obj<-
                     httpuv::startDaemonizedServer(host, port, self$app_definition())
                 } else {
                   httpuv::runServer(host, port, self$app_definition())
                 }

               },
               print=function(...){
                 cat("A Jug instance with ",length(self$middleware_handler$middlewares)," middlewares attached\n", sep="")
                 invisible(self)
               }
             )
)


#' New jug instance
#'
#' @export
jug<-function(){
  Jug$new()
}

#' Start serving the jug instance
#'
#' @param jug the jug instance
#' @param host the host address
#' @param port the port to host on
#' @param daemonized whether or not to start a daemonized server (experimental)
#' @param verbose verbose output?
#'
#' @export
serve_it<-function(jug, host="127.0.0.1", port=8080, daemonized=FALSE, verbose=FALSE){
  options("jug.verbose"=verbose)

  message(paste0("Serving the jug at http://",host,":",port))
  jug$start(host, port, daemonized)

  jug
}

#' Stop daemonized server
#'
#' @param jug the jug instance
#'
#' @export
stop_daemon<-function(jug){
  httpuv::stopDaemonizedServer(jug$daemon_obj)

  jug
}
