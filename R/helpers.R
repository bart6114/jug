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


#' Helper function to deparse query params
#'
#' @param query_string the query string
#'
#' @export
parse_query<-function(query_string){
  params_list<-list()

  if(length(query_string)>0){
    query_string<-gsub("^\\?", "", query_string, perl=TRUE)

    rex_res<-
      stringi::stri_match_all(query_string, regex="([^?=&]+)(=([^&]*))?")[[1]]

    if(!any(is.na(rex_res))){
      params<-matrix(rex_res[,c(2,4)], ncol=2)

      params_list<-
        as.list(params[,2])

      names(params_list)<-
        params[,1]

    }

  }

  params_list
}



#' Parse the post data
#'
#' @param env the rook req environment
#' @param content_type the mime type
parse_post_data<-function(env, content_type){

  if(grepl("json", content_type)){
    post_data<-env$rook.input$read_lines()

    if(length(post_data)>0) {
      jsonlite::fromJSON(post_data)

    }
  } else if(grepl("x-www-form-urlencoded", content_type)) {
    parse_query(env$rook.input$read_lines())

  } else if(grepl("multipart/form-data", content_type)) {
    mime::parse_multipart(env)

  }


}


