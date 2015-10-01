#' Response class
#'
#' @import R6
Response<-
  R6Class("Response",
          public=list(
            headers=list("Content-Type"="text/html"),
            set_header=function(key, value){
              self$headers[[key]]<-value
            },
            content_type=function(type){
              self$headers[['Content-Type']]=type
            },
            status=NULL,
            set_status=function(status){
              self$status=status
            },
            body=NULL,
            set_body=function(body){
              self$body<-body
              if(is.null(self$status)) self$status<-200L
            },
            structured=function(){
              list(
                status=self$status,
                headers=self$headers,
                body=self$body
              )
            }
          ))

#' Create response instance
#'
new_response<-function(){
  Response$new()
}
