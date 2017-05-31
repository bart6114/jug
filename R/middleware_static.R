#' Middleware to serve static files
#'
#' Binds to get requests that aren't handled by specified paths. Should support
#' all filetypes; returns image, octet-stream and pdf types as a raw string.
#'
#' Note: the \code{path} argument is not related to the file being served. If
#' \code{path} is given, the static file middleware will bind to \code{path},
#' however for finding the files on the local filesystem it will strip
#' \code{path} from the file location. For example, let's assume
#' \code{path='my_path'}, the following url \code{/my_path/file/to/serve.html}
#' will serve the file \code{file/to/serve.html} from the \code{root_path} folder.
#'
#' The \code{unproxy} argument allows you to remove extra path components
#' that might be set up in your apache config file. These path components
#' exist only in URLs and are not reflected in file paths.
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#' @param root_path the file path to set as root for the file server
#' @param unproxy the ProxyPass component of the path to be removed
#'
#' @export
serve_static_files<-function(jug, path=NULL, root_path=getwd(), unproxy=NULL){
  get(jug, path = NULL, function(req, res, err){

    # If req$path ends in "/", add "index.html"
    if(substring(req$path, nchar(req$path)) == "/"){
      req$path <- paste0(req$path, "index.html")
    }

    # Remove any PoxyPass setting from the request path to get a relative path
    if ( is.null(unproxy) ) {
      relative_path <- req$path
    } else {
      relative_path <- sub(unproxy,'',req$path)
    }

    # Determine the absolute file path
    if(is.null(path)){
      file_path <- paste0(root_path, '/', relative_path)
    } else {
      partial_file_path <- gsub(paste0('.*', path, '(.*)'), '\\1', relative_path)
      file_path <- paste0(root_path, '/', partial_file_path)
    }

    bound <- ifelse(is.null(path), TRUE, substr(relative_path, 2, nchar(path) + 1) == path)

    if(file.exists(file_path) & bound){
      mime_type <- mime::guess_type(file_path)
      res$content_type(mime_type)

      data <- readBin(file_path, 'raw', n=file.info(file_path)$size)

      if(grepl("image|octet|pdf", mime_type)){ # making a lot of assumptions here
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
