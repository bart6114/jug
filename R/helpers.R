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
