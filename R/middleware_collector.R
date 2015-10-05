#' Collector function for middlewares
#'
#' Basically constructs an empty jug instances that will be merged into the primary one later on
#'
#' @export
collector<-function(){
  return(Jug$new())
}


#' Join elsewhere constructed middleware with primary jug instance
#'
#' @param jug the primary jug instance
#' @param collector the variable containing the external middleware
#'
#' @export
require_middleware<-function(jug, collector, file_to_source=NULL){
  if(is.null(file_to_source)){
    collector_obj<-get(deparse(substitute(collector)))
  } else {
    external_env<-new.env()
    source(file_to_source, local = external_env)
    collector_obj<-external_env[[deparse(substitute(collector))]]
  }

  jug$add_collected_middelware(collector_obj)

  jug
}

