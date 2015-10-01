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
                  start=function(host, port){
                    httpuv::runServer(host, port, self$app_definition())
                  }
                ))

#' New beakr instance
#'
#' @export
jug<-function(){
  Jug$new()
}


#' @export
serve_it<-function(jug, host="127.0.0.1", port=8080){
  message(paste0("Serving the jug at http://",host,":",port))
  jug$start(host, port)
}
