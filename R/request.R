#' Request class
Request<-
  R6::R6Class("Request",
          public=list(
            params=list(),
            headers=list(),
            path=NULL,
            method=NULL,
            raw=NULL,
            content_type="",
            protocol="http",

            attach=function(key, value) self$params[[key]]<-value,

            ## inspired by https://github.com/nteetor/dull/blob/master/R/request.R
            get_header=function(key) self$headers[[paste0("HTTP_",toupper(key))]],
            set_header=function(key, value) self$headers[[paste0("HTTP_",toupper(key))]]<-value,
            add_params=function(named_list) self$params<-c(self$params, named_list),

            initialize=function(req){
              self$raw<-req
              self$path<-req$PATH_INFO
              self$method<-toupper(req$REQUEST_METHOD)


              if(length(req$CONTENT_TYPE)>0) self$content_type<-req$CONTENT_TYPE

              self$params<-parse_query(req$QUERY_STRING)

              self$params<-c(self$params,
                             parse_post_data(req, self$content_type))

              self$headers<-as.list(req)

              if(any(tolower(self$get_header("upgrade"))=="websocket")){
                self$protocol<-"websocket"
              }

            }
          )
  )
