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
#' @param env the rook req environment
#' @param content_type the mime type
parse_params<-function(body, query_string=NULL, content_type){
  params<-list()
  if(!is.null(query_string)) params <- c(params, webutils::parse_query(query_string))

  if (is.null(content_type)) { return(params) }

  if(grepl("json", content_type)){
    if(length(body)>0) {
      params <- c(params, jsonlite::fromJSON(body, simplifyDataFrame = FALSE))
    }

  } else if(any(sapply(c("x-www-form-urlencoded", "multipart/form-data"), grepl, content_type))) {
    params <- c(params, webutils::parse_http(body, content_type))
  }
  params
}


