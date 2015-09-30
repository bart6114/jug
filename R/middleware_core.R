library(R6)

#' MiddlewareHandler R6 class definition
#'
#' @import R6
MiddlewareHandler<-
  R6Class("MiddlewareHandler",
          public=list(
            middleware_funcs=c(),

            add_middleware=function(func){
              self$middleware_funcs<-c(self$middleware_funcs, func)

            },
            invoke=function(req, res){
              for(func in self$middleware_funcs){

                res<-func(req, res)
                if(!is.null(res)) break
              }
              return(res)
            }
          )
  )

