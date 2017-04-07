#' Add cors functionality
#'
#' Allows to set CORS-headers as specified in https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS.
#' It will also setup the infrastructure in order to receive OPTIONS requests send to \code{path}.
#'
#' @param jug the jug instance
#' @param path the path to bind to
#' @param allow_methods a vector of allowed methods
#' @param allow_origin the allowed origin
#' @param allow_credentials either \code{true} or \code{false} (supply as string)
#' @param allow_headers a vector of allowed headers
#' @param max_age in seconds
#' @param expose_headers a vector of exposed headers
#'
#' @export
cors<-function(
  jug,
  path=NULL,
  allow_methods=c('POST', 'GET', 'PUT', 'OPTIONS', 'DELETE', 'PATCH'),
  allow_origin="*",
  allow_credentials=NULL,
  allow_headers=NULL,
  max_age=NULL,
  expose_headers=NULL){

  if(!is.null(allow_headers)) allow_headers <- paste0(allow_headers, collapse=",")
  if(!is.null(allow_methods)) allow_methods <- paste0(allow_methods, collapse=",")

  headers<-list(
    `Access-Control-Allow-Origin`=allow_origin,
    `Access-Control-Expose-Headers`=expose_headers,
    `Access-Control-Max-Age`=max_age,
    `Access-Control-Allow-Credentials`=allow_credentials,
    `Access-Control-Allow-Methods`=allow_methods,
    `Access-Control-Allow-Headers`=allow_headers
  )

  headers<-Filter(function(x) !is.null(x), headers)

  func<-function(req, res, err){

    lapply(names(headers), function(header_name) res$set_header(header_name, headers[[header_name]]))
      
    if(req$method == "OPTIONS"){
      return("") 
      } else
      return(NULL)
  }

  add_middleware(jug, func, path=path, method=NULL)
  jug

}
