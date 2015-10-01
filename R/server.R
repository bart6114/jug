#' The Server class
#'
#' @import httpuv R6
Server<-R6Class("Server",
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
beakr<-function(){
  Server$new()
}


#' @export
serve_it<-function(server, host="127.0.0.1", port=8080){
  server$start(host, port)
}
