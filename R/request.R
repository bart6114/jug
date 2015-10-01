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
            initialize=function(req){
              self$path<-req$PATH_INFO
              self$query_params<-get_passed_params(req$QUERY_STRING)
              self$headers<-as.list(req)
              self$method<-req$REQUEST_METHOD
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

  params<-
    matrix(
      stringi::stri_match_all(query_string, regex="([^?=&]+)(=([^&]*))?")[[1]][,c(2,4)],
      ncol=2)

  params_list<-
    as.list(params[,2])

  names(params_list)<-
    params[,1]

  params_list
}



