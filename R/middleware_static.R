#' Middleware to serve static files
#'
#' Binds to get requests that aren't handled by specified paths.
#' Should support all filetypes; returns image and octet-stream types as a raw string.
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#' @param root_path the file path to set as root for the file server
#'
#' @export
serve_static_files<-function(jug, path=NULL, root_path=getwd()){
  get(jug, path = NULL, function(req, res, err){

    if(req$path == "/") req$path<-"index.html"

    file_path <- paste0(root_path, '/', req$path)

    if(file.exists(file_path)){
      mime_type <- mime::guess_type(file_path)
      res$content_type(mime_type)

      data <- readBin(file_path, 'raw', n=file.info(file_path)$size)

      if(grepl("image|octet", mime_type)){ # making a lot of assumptions here
        return(data)

      } else {
        return(rawToChar(data))

      }

    } else {
      res$set_status(404)
      return(NULL)
    }

  })
}
