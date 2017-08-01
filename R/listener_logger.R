#' Basic logging middleware
#'
#' @param log_file the text file to which the log will be appended
#' @param log_msg_func the function which returns the content of the log message, expects a function that allows to pass a \code{req}, \code{res} and \code{err} argument
#'
#' @export
logger<-function(jug, threshold = futile.logger::DEBUG, log_file = NULL, console = TRUE){

  if(!is.null(log_file) & console){
    appdr <- futile.logger::appender.tee(log_file)
  } else if(!is.null(log_file) & !console){
    appdr <- futile.logger::appender.file(log_file)
  } else if(is.null(log_file) & console){
    appdr <- futile.logger::appender.console()
  } else {
    stop("Logging output has to go to either a log_file, to the console or a combination of both")
  }

  futile.logger::flog.logger("jug", threshold, appender=appdr)

  on(jug, event="start", func = function(event, req, res, err){
    msg <- paste(toupper(req$protocol), "|", req$path,"-", req$method, "- request received", "\n" ,sep = " ")
    futile.logger::flog.debug(msg, name = "jug")
  })

  on(jug, event="finish", func = function(event, req, res, err){
    msg <- paste(toupper(req$protocol), "|", req$path,"-", req$method, "-", res$status, "\n" ,sep = " ")
    futile.logger::flog.info(msg, name = "jug")
  })

  on(jug, event="error", func = function(event, req, res, err, err_msg){
    msg <- paste(toupper(req$protocol), "|", req$path,"-", req$method, "- error encountered:", "\n" ,
               err_msg, sep = " ")
    futile.logger::flog.info(msg, name = "jug")
  })
}

