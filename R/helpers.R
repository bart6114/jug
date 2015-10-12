#' Helper function to extract regex named capture groups from string
#'
#' adapted from: http://oddhypothesis.blogspot.be/2012/05/regex-named-capture-in-r.html
#'
#' @param pattern regex pattern
#' @param string the string to test the regex pattern against
#' @param ... arguments passed to \code{regexpr}
#'
#' @export
match_path = function(pattern, path, ...) {
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
#' @import stringi
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


#' Convenience function to return plots in a response (as a PNG image)
#'
#' @param plot_obj the plot object
#' @param res the response instance
#' @param ... parameters passed to the png device
#'
#' @export
web_plot<-function(plot_obj, res, ...){
  res$content_type("image/png")

  plot_file<-tempfile(pattern="web_plot")
  png(filename = plot_file)
  print(plot_obj)
  dev.off()

  readBin(file(plot_file, "rb"), what="raw", n=1e6)
}
