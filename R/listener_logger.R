#' Basic logger
#'
#' This logger uses futile.logger to implement logging functionality
#'
#' @param jug a jug instance
#' @param threshold the threhold as from what type of message to activate the logger (check the documentation of \pkg{futile.logger} for possibilities)
#' @param log_file if given, the file to which the log is written
#' @param console if TRUE will (also) print to console
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
    futile.logger::flog.error(msg, name = "jug")
  })
}

