#' Basic logging middleware
#'
#' @param log_file the text file to which the log will be appended
#' @param log_msg_func the function which returns the content of the log message, expects a function that allows to pass a \code{req}, \code{res} and \code{err} argument
#'
#' @export
logger<-function(jug){
  on(jug, event="start", func = function(event, req, res, err){
    msg <- cat(toupper(req$protocol), "|", req$path,"-", req$method, "- processing", "\n" ,sep = " ")
    futile.logger::flog.debug(msg)

    return(NULL)
  })

  on(jug, event="finish", func = function(event, req, res, err){
    msg <- cat(toupper(req$protocol), "|", req$path,"-", req$method, "-", res$status, "\n" ,sep = " ")
    futile.logger::flog.info(msg)

    return(NULL)
  })

  on(jug, event="error", func = function(event, req, res, err, err_msg){
    msg <- cat(toupper(req$protocol), "|", req$path,"-", req$method, "- error encountered:", "\n" ,
               err_msg, sep = " ")
    futile.logger::flog.info(msg)

    return(NULL)
  })
}

