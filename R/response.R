#' Response class
#'
#' @importFrom base64enc base64encode
Response<-
  R6::R6Class("Response",
          public=list(
            headers=list("Content-Type"="text/html"),
            set_header=function(key, value) self$headers[[key]]<-value,
            content_type=function(type) self$headers[['Content-Type']]=type,
            status=200L,
            set_status=function(status) self$status=status,
            redirect=function(url){
              self$status=302L
              self$set_header("Location", url)
            },
            body=NULL,
            set_body=function(body){
              # hack avoid numeric response not working
              if(self$headers[['Content-Type']]=="text/html"){
                self$text(body)
              } else {
                self$body<-body
              }
            },
            json=function(obj){
              self$body<-jsonlite::toJSON(obj, auto_unbox = TRUE)
              self$content_type("application/json")
            },
            text=function(text){
              self$body<-as.character(text)
              self$content_type("text/html")
            },
            plot=function(plot_obj, base64=TRUE, ...){

              plot_file<-tempfile(pattern="jug")
              png(filename = plot_file, ...)
              print(plot_obj)
              dev.off()

              file_conn<-file(plot_file, "rb")
              binary_img<-readBin(file_conn, what="raw", n=1e6)

              if(base64){
                self$content_type("application/base64")
                self$body<-base64enc::base64encode(binary_img)
              } else {
                self$content_type("image/png")
                self$body<-binary_img
              }

              close(file_conn)
            },
            structured=function(protocol){
              switch(protocol,
                     "http"=list(
                       status=self$status,
                       headers=self$headers,
                       body=self$body),
                     "websocket"=self$body)
            }
          ))
