## Having an additional req object might be significantly hinder peformance...


#' Request class
#'
#' @import R6 stringi
Request<-
  R6Class("Request",
          public=list(
            query_params=NULL,
            headers=NULL,
            path=NULL,
            method=NULL,
            post_data=NULL,
            raw=NULL,
            initialize=function(req){
              self$raw<-req

              self$path<-req$PATH_INFO

              query_string<-req$QUERY_STRING
              if(length(query_string)>0) self$query_params<-get_passed_params(query_string)

              self$headers<-as.list(req)
              self$method<-req$REQUEST_METHOD

              ## TODO: fix for binary posts/puts
              self$post_data<-get_passed_params(req$rook.input$read_lines())
            }
          )
  )


#' Create request instance
#'
new_request<-function(req){
  Request$new(req)
}

#' Helper function to deparse query params
#'
#' @param req the request object
#'
#' @export
#' @import stringi
get_passed_params<-function(query_string){
  params_list<-NULL

  try({
    params<-
      matrix(
        stringi::stri_match_all(query_string, regex="([^?=&]+)(=([^&]*))?")[[1]][,c(2,4)],
        ncol=2)

    params_list<-
      as.list(params[,2])

    names(params_list)<-
      params[,1]
  }, silent = TRUE)

  params_list
}



