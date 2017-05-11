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

    if(substring(req$path, nchar(req$path)) == "/"){
      req$path <- paste0(req$path, "index.html")
    }

    if(is.null(path)){
      file_path <- paste0(root_path, '/', req$path)
    } else {
      partial_file_path <- gsub(paste0('.*', path, '(.*)'), '\\1', req$path)
      file_path <- paste0(root_path, '/', partial_file_path)
    }

    bound <- ifelse(is.null(path), TRUE, substr(req$path, 2, nchar(path) + 1) == path)

    if(file.exists(file_path) & bound){
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
