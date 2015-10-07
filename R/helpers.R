#' Helper function to extract regex named capture groups from string
#'
#' source: http://oddhypothesis.blogspot.be/2012/05/regex-named-capture-in-r.html
#'
#' @param pattern regex pattern
#' @param string the string to test the regex pattern against
#' @param ... arguments passed to \code{regexpr}
#'
#' @export
re_capture = function(pattern, string, ...) {

  if(!is.null(pattern) & !is.null(string)){

    rex = list(match=FALSE,
               src=string,
               result=regexpr(pattern, string, perl=TRUE, ...),
               names=list())

    for (.name in attr(rex$result, 'capture.name')) {
      rex$names[[.name]] = substr(rex$src,
                                  attr(rex$result, 'capture.start')[,.name],
                                  attr(rex$result, 'capture.start')[,.name]
                                  + attr(rex$result, 'capture.length')[,.name]
                                  - 1)
    }

    rex$match=ifelse(rex$result[[1]]>-1, TRUE, FALSE)

    rex
  } else {
    list(match=FALSE,
         src=string,
         names=list())
  }


}
