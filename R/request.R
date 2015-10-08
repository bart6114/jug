#' Request class
#'
#' @import R6 stringi jsonlite
#'
#' @export
Request<-
  R6Class("Request",
          public=list(
            params=list(),
            headers=list(),
            path=NULL,
            method=NULL,
            post_data=NULL,
            raw=NULL,
            content_type="",

            attached=list(),
            attach=function(key, value) self$attached[[key]]<-value,

            ## inspired by https://github.com/nteetor/dull/blob/master/R/request.R
            get_header=function(key) self$headers[[paste0("HTTP_",toupper(key))]],
            set_header=function(key, value) self$headers[[paste0("HTTP_",toupper(key))]]<-value,
            add_params=function(named_list) self$params<-modifyList(self$params, named_list),

            initialize=function(req){
              self$raw<-req
              self$path<-req$PATH_INFO
              self$method<-req$REQUEST_METHOD

              if(length(req$CONTENT_TYPE)>0) self$content_type<-req$CONTENT_TYPE


              self$params<-get_passed_params(req$QUERY_STRING)

              ## TODO: fix for binary posts/puts
              if(grepl("json", self$content_type)){
                self$params<-c(self$params, fromJSON(req$rook.input$read_lines()))

              } else {
                self$params<-c(self$params,
                               get_passed_params(req$rook.input$read_lines()))

              }

              self$headers<-as.list(req)

            }
          )
  )
