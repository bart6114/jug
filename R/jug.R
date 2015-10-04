#' The Jug class
#'
#' @import httpuv R6 magrittr
Jug<-R6Class("Jug",
             public=list(
               middleware_handler=NULL,
               app_definition=function(){
                 list(
                   call=function(req){
                     self$middleware_handler$invoke(req)
                   }
                 )
               },
               initialize=function(){
                 self$middleware_handler=MiddlewareHandler$new()
               },
               start=function(host, port, daemonized){
                 if(daemonized){
                   httpuv::startDaemonizedServer(host, port, self$app_definition())
                 } else {
                   httpuv::runServer(host, port, self$app_definition())
                 }

               },
               print=function(){
                 print(paste0("A Jug instance with ",length(self$middleware_handler$middlewares)," middlewares attached"))
               }
             )
)


#' New jug instance
#'
#' @export
jug<-function(){
  Jug$new()
}


#' @export
serve_it<-function(jug, host="127.0.0.1", port=8080, daemonized=FALSE){
  message(paste0("Serving the jug at http://",host,":",port))
  jug$start(host, port, daemonized)
}

#' @export
stop_daemon<-function(jug){
  httpuv::stopDaemonizedServer(jug)
}