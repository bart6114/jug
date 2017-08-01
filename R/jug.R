#' The Jug class
#'
#' @importFrom magrittr %>%
Jug<-R6::R6Class("Jug",
             public=list(
               request_handler=NULL,
               daemon_obj=NULL,
               app_definition=function(){
                 list(
                   call=function(req){
                     self$request_handler$invoke(req)
                   },
                   onWSOpen=function(ws){
                     ws$onMessage(function(binary, message) {
                       ws$send(self$request_handler$invoke(ws$request,
                                                              ws_message=message,
                                                              ws_binary=binary)
                       )
                     })
                   }
                 )
               },
               add_collected_middelware=function(collector){
                 self$request_handler$add_middleware(collector$request_handler$middlewares)
               },
               initialize=function(){
                 self$request_handler=RequestHandler$new()
                 options("jug.verbose"=FALSE) # set early for testing purposes were serve_it isn't called
               },
               start=function(host, port, daemonized){
                 if(daemonized){
                   self$daemon_obj<-
                     httpuv::startDaemonizedServer(host, port, self$app_definition())
                 } else {
                   httpuv::runServer(host, port, self$app_definition())
                 }

               },
               print=function(...){
                 cat("A Jug instance with ",length(self$request_handler$middlewares)," middlewares attached\n", sep="")
                 invisible(self)
               }
             )
)



#' RequestHandler R6 class definition
#'
#' @import R6
RequestHandler<-
  R6Class("RequestHandler",
          public=list(
            middlewares=c(),
            listeners=c(),

            add_middleware=function(mw){
              self$middlewares<-c(self$middlewares, mw)
            },
            add_listener=function(listener){
              self$listeners<-c(self$listeners, listener)
            },
            process_event=function(event, ...){
              listeners = Filter(function(l) l$event == event, self$listeners)
              lapply(listeners, function(l) l$func(event, ...))
            },
            invoke=function(req, ws_message = NULL, ws_binary = NULL){
              res<-Response$new()
              req<-Request$new(req)
              err<-new_error()

              body<-NULL

              self$process_event("start", req, res, err)


              for(mw in self$middlewares){

                # if there are named capture groups in the path, add them to req$params
                path_processed<-match_path(mw$path, req$path)

                req$add_params(path_processed$params)

                # REFACTOR!

                if(any(
                  (req$protocol=="http" && any(
                    path_processed$match && (mw$method == req$method),
                    path_processed$match && is.null(mw$method),
                    is.null(mw$path) && (mw$method == req$method),
                    is.null(mw$path) && is.null(mw$method)
                  )),
                  (req$protocol=="websocket" && any(
                    path_processed$match,
                    is.null(mw$path)
                  ))
                )){


                  body<-
                    try(
                      switch(req$protocol,
                             "http"=mw$func(req=req, res=res, err=err),
                             "websocket"=mw$func(binary=ws_binary, message=ws_message, res=res, err=err)),
                      silent=TRUE
                    )

                  if('try-error' %in% class(body)){
                    # process it further (should be catched by errorhandler)
                    self$process_event("error", req, res, err, as.character(body))
                    err$set(as.character(body))
                    body<-NULL
                  }

                  # if return values is not NULL, use it as body (unless set explicitely)
                  if(is.null(res$body) && !is.null(body)) res$set_body(body)

                  if(!is.null(res$body)){
                    break
                  }
                }
              }

              if(getOption("jug.verbose")){
                cat(toupper(req$protocol), "|", req$path,"-", req$method, "-", res$status, "\n" ,sep = " ")
              }

              # check for empty body after full processing and do a clean stop
              if(is.null(res$body)){
                err_msg <- "Request not handled or no body set by any middleware"
                self$process_event("error", req, res, err, err_msg)
                stop(err_msg)
              }

              self$process_event("finish", req, res, err)
              res$structured(req$protocol)

            }
          )
  )



#' New jug instance
#'
#' Creates a new jug instance which can be build upon with other functions (middlewares).
#'
#' @examples
#' \donttest{
#' \dontrun{
#' # This Hello World example will serve a jug instance on the default port.
#' # The jug instance will return "Hello World!" if a GET request is send to it.
#' jug() %>%
#'  get("/", function(req, res, err) "Hello World!" ) %>%
#'  simple_error_handler_json() %>%
#'  serve_it(verbose=TRUE)
#' }
#' }
#'
#' \donttest{
#' \dontrun{
#' # Introduction to jug
#' vignette("jug", package="jug")
#' }
#' }
#'
#' @export
jug<-function(){
  Jug$new()
}

#' Start serving the jug instance
#'
#' @param jug the jug instance
#' @param host the host address
#' @param port the port to host on
#' @param daemonized whether or not to start a daemonized server (experimental)
#' @param verbose verbose output?
#'
#' @export
serve_it<-function(jug, host="127.0.0.1", port=8080, daemonized=FALSE, verbose=FALSE){
  options("jug.verbose"=verbose)

  message(paste0("Serving the jug at http://",host,":",port))
  jug$start(host, port, daemonized)

  jug
}

#' Stop daemonized server
#'
#' @param jug the jug instance
#'
#' @export
stop_daemon<-function(jug){
  httpuv::stopDaemonizedServer(jug$daemon_obj)

  jug
}


