#' Helper function to extract regex named capture groups from string
#'
#' adapted from: http://oddhypothesis.blogspot.be/2012/05/regex-named-capture-in-r.html
#'
#' @param pattern regex pattern
#' @param path the path to test the regex pattern against
#' @param ... arguments passed to \code{regexpr}
#'
#' @export
match_path<-function(pattern, path, ...) {
  result = list(match=FALSE,
                src=path,
                params=list())

  if(is.null(pattern)){
    result$match<-TRUE
  } else {

    if(!(grepl("^\\^", pattern) || grepl("\\$$", pattern))){
      pattern<-paste0("^", pattern, "$")
    }

    rex<-regexpr(pattern, path, perl=TRUE, ...)

    ## extract capture groups
    for (.name in attr(rex, 'capture.name')) {
      result$params[[.name]] = substr(result$src,
                                      attr(rex, 'capture.start')[,.name],
                                      attr(rex, 'capture.start')[,.name]
                                      + attr(rex, 'capture.length')[,.name]
                                      - 1)
    }

    result$match=ifelse(rex[[1]]>-1, TRUE, FALSE)

  }

  result
}


#' Parse the params passed by the request
#'
#' @param req the rook req environment
#' @param body the parsed body
#' @param query_string a query string
#' @param content_type the mime type
parse_params<-function(req, body, query_string, content_type){
  params <- list()
  params <- c(params, webutils::parse_query(query_string))

  if(is.null(content_type)) return(params)
  if(grepl("json", content_type) && nchar(body)>0) params <- c(params, jsonlite::fromJSON(body, simplifyDataFrame = FALSE))
  if(grepl("multipart", content_type)) params <- c(params, mime::parse_multipart(req))
  if(grepl("form-urlencoded", content_type)) params <- c(params, webutils::parse_query(body))
  params
}




#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
