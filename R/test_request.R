
#' Generate request for testing purposes
#'
#' solely used for testing purposes
#' @import R6
#'
#' @export
RawTestRequest<-R6Class("RawTestRequest", public=list(
  req=list(
    HTTP_CACHE_CONTROL = "no-cache",
    HTTP_CONNECTION = "keep-alive",
    HTTP_ACCEPT = "*/*",
    HTTP_ACCEPT_LANGUAGE = "nl-NL,nl;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2",
    QUERY_STRING = "",
    httpuv.version = list(c(1L, 3L, 3L)),
    SERVER_NAME = "127.0.0.1",
    SCRIPT_NAME = "",
    SERVER_PORT = "8080",
    REMOTE_PORT = "60144",
    PATH_INFO = "/",
    HTTP_CONTENT_TYPE = "application/x-www-form-urlencoded",
    REMOTE_ADDR = "127.0.0.1",
    CONTENT_TYPE = "application/x-www-form-urlencoded",
    rook.url_scheme = "http",
    rook.input = list(
      read_lines = function() return("")
    ),
    HTTP_ACCEPT_ENCODING = "gzip, deflate, sdch",
    HTTP_COOKIE = "",
    REQUEST_METHOD = "GET",
    HTTP_USER_AGENT = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36",
    HTTP_TREADS = "5",
    HTTP_HOST = "127.0.0.1:8080"),

  path=function(path) self$req$PATH_INFO<-path,
  method=function(method) self$req$REQUEST_METHOD<-method,
  query_string=function(qstring) self$req$QUERY_STRING<-qstring,
  post_data=function(post_data){
    self$req$rook.input$read_lines=function() return(post_data)
    },
  set_header=function(key, value){
    self$req[[paste0("HTTP_", toupper(key))]]<-value
  },
  print=function(...){
    cat("A RawTestRequest instance\n")
    invisible(self$req)
  }
)
)

#' Initialize process of test request
#'
#' @param jug the jug instance
#' @param test_request the RawTestRequest instance
#'
#' @export
process_test_request<-function(jug, test_request){
  jug$middleware_handler$invoke(test_request)
}
