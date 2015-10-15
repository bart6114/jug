#' Middleware to serve static files
#'
#' Binds to get requests that aren't handled by specified paths.
#' Currently only works/tested for text files
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#' @param root_path the file path to set as root for the file server
#'
#' @importFrom mime guess_type
#' @export
serve_static_files<-function(jug, path=NULL, root_path=getwd()){
  get(jug, path = NULL, function(req, res, err){

    if(req$path == "/") req$path<-"index.html"

    file_path <- paste0(root_path, req$path)

    if(file.exists(file_path)){
      res$content_type(guess_type(file_path))
      paste0(readLines(file_path),collapse= "\n")
    } else {
      return(NULL)
    }

  })
}
