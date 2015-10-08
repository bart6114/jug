#' Response class
#'
#' @import R6 jsonlite
Response<-
  R6Class("Response",
          public=list(
            headers=list("Content-Type"="text/html"),
            set_header=function(key, value) self$headers[[key]]<-value,
            content_type=function(type) self$headers[['Content-Type']]=type,
            status=200L,
            set_status=function(status) self$status=status,
            redirect=function(url){
              self$status=302L
              self$set_header("Location", url)
            },
            body=NULL,
            set_body=function(body){
              self$body<-body
            },
            json=function(obj){
              self$body<-jsonlite::toJSON(obj, auto_unbox = TRUE)
              self$content_type<-"application/json"
            },
            structured=function(){
              list(
                status=self$status,
                headers=self$headers,
                body=self$body
              )
            }
          ))
