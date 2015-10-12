#' Request class
#'
#' @import R6 stringi jsonlite mime
#'
#' @export
Request<-
  R6Class("Request",
          public=list(
            params=list(),
            headers=list(),
            path=NULL,
            method=NULL,
            raw=NULL,
            content_type="",

            attach=function(key, value) self$params[[key]]<-value,

            ## inspired by https://github.com/nteetor/dull/blob/master/R/request.R
            get_header=function(key) self$headers[[paste0("HTTP_",toupper(key))]],
            set_header=function(key, value) self$headers[[paste0("HTTP_",toupper(key))]]<-value,
            add_params=function(named_list) self$params<-c(self$params, named_list),

            initialize=function(req){
              self$raw<-req
              self$path<-req$PATH_INFO
              self$method<-req$REQUEST_METHOD

              if(length(req$CONTENT_TYPE)>0) self$content_type<-req$CONTENT_TYPE

              self$params<-parse_query(req$QUERY_STRING)

              post_input<-paste(req$rook.input$read_lines(), collapse="")
              ## TODO: fix for binary posts/puts

              if(length(post_input)>0){

                if(grepl("json", self$content_type)){
                  self$params<-c(self$params,jsonlite::fromJSON(post_input))
                } else if(grepl("x-www-form-urlencoded", self$content_type)) {
                  self$params<-c(self$params,
                                 parse_query(post_input))
                } else if(grepl("multipart/form-data", self$content_type)) {
                  self$params<-c(self$params,
                                 mime::parse_multipart(self$raw))
                }

              }

              self$headers<-as.list(req)

            }
          )
  )
