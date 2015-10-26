#' Collector function for middlewares
#'
#' Basically constructs an empty jug instances that will be merged into the primary one later on
#'
#' @export
collector<-function(){
  return(Jug$new())
}


#' Include elsewhere constructed middleware with primary jug instance
#'
#' @param jug the primary jug instance
#' @param collector the variable containing the external middleware
#' @param source_file provide (relative) path if collector variable is located in another .R file
#'
#' @export
include<-function(jug, collector, source_file=NULL){

  if(is.null(source_file)){
    collector_obj<-eval(quote(collector))
  } else {
    tempenv=new.env()
    source(source_file, local=tempenv)
    collector_obj<-eval(quote(collector), envir = tempenv)
  }

  jug$add_collected_middelware(collector_obj)

  jug
}

