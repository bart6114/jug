#' Response class
#'
#' @import R6
Error<-
  R6Class("Error",
          public=list(
            errors=c(),
            set=function(err){
              self$errors<-c(self$errors, as.character(err))
            }
          ),
          active=list(
            occurred=function(){
              return(length(self$errors)>0)
            }
          )
  )

#' Create response instance
#'
new_error<-function(){
  Error$new()
}


