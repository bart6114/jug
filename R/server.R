.defaultReqHeaders = c("HTTP_ACCEPT","HTTP_ACCEPT_ENCODING","HTTP_ACCEPT_LANGUAGE","HTTP_CACHE_CONTROL","HTTP_CONNECTION","HTTP_HOST","HTTP_REFERER","HTTP_UPGRADE_INSECURE_REQUESTS","HTTP_USER_AGENT","httpuv.version","PATH_INFO","QUERY_STRING","REMOTE_ADDR","REMOTE_PORT","REQUEST_METHOD","rook.errors","rook.input","rook.url_scheme","rook.version","SCRIPT_NAME","SERVER_NAME","SERVER_PORT")


setClass("interfacer",
         slots=list(
           funcs="list"
         ),
         prototype = list(
           funcs=list()
         ))

setGeneric("add_func",
           def=function(obj, func, ...){
             standardGeneric("add_func")
           })

setMethod(f="add_func",
          signature = "interfacer",
          definition = function(obj, func, path=deparse(substitute(func)), res_content_type="application/json"){}
)



#' Helper function to deparse query params
#'
#' @param req the request object
#'
#' @export
#' @import stringi
get_passed_params<-function(query_string){

  params<-
    matrix(
      stringi::stri_match_all(query_string, regex="([^?=&]+)(=([^&]*))?")[[1]][,c(2,4)],
      ncol=2)

  params_list<-
    as.list(params[,2])

  names(params_list)<-
    params[,1]

  params_list
}

#' Add function to interface definition
#'
#' @param obj the interface definition
#' @param func the function to add
#' @export
#'
add_func<-function(obj, func, path=deparse(substitute(func)), res_content_type="application/json"){

  obj@funcs[[path]]<-list(
    func=func,
    res_content_type=res_content_type
  )

  obj
}


#' the main interfacer function
#'
#' Used to set-up the interface
#'
#' @export
#' @import httpuv jsonlite
interfacer<-function(host="0.0.0.0", port=8080){
  new("interfacer")
}

#' start the interface
#'
#' @param obj the interface object
#'
#' @export
#' @import httpuv jsonlite
start_interface<-function(obj, host="127.0.0.1", port=8083, verbose=getOption("verbose")){

  if(verbose) message(paste0("Starting interface... on http://",host,":",port, " (will not return as long as server is running)"))

  app_def<-list(
    call=function(req){

      # function called is based on path provided "/myfunc" will call "myfunc"
      path<-stringr::str_match(req$PATH_INFO, "\\/(.*)")[,2]

      if(verbose) message(paste("Function called:", path))

      # get the query string parameters
      passed_params<-
        get_passed_params(req$QUERY_STRING)

      if(verbose) message(paste("Query params provided:", passed_params))

      if(verbose) message(paste("Params provided in header:", setdiff(ls(req), .defaultReqHeaders)))

      # add header params to passed_params
      req_list<-as.list(req)
      req_list[names(req_list) %in% setdiff(ls(req), .defaultReqHeaders)]
      passed_params<-
        modifyList(passed_params, req_list)

      # check which parameters the function allows
      args_allowed<-
        names(formals(obj@funcs[[path]]$func))
      message(args_allowed)
      # drop not requested params from query params
      passed_params<-
        passed_params[names(passed_params) %in% args_allowed]

      # expose req obj if in function params
      if("req" %in% args_allowed){
        passed_params$req<-req
      }

      if(verbose) message(paste("Params that will be passed:", passed_params))

      # check if a function is linked to the path
      if(path %in% names(obj@funcs)){
        # execute function with provided parameters
        func_res<-
          do.call(obj@funcs[[path]]$func, passed_params)


        if(verbose) message(paste("Function responded with:", func_res))

        if(grepl("json", obj@funcs[[path]]$res_content_type)){
          func_res<-jsonlite::toJSON(func_res)
        }

        res<-
          list(
            status = 200L,
            headers = list(
              'Content-Type' = obj@funcs[[path]]$res_content_type
            ),
            body = func_res
          )

        return(res)

      } else {
        res<-
          list(
            status = 500L,
            headers = list(
              'Content-Type' = "text/html"
            ),
            body = "function/path not specified"
          )

        return(res)
      }
    }
  )


  httpuv::runServer(host, port, app_def)

}




