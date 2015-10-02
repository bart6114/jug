#' Middleware to serve static files
#'
#' Binds to get requests that aren't handled by specified paths.
#' Currently only works/tested for text files
#'
#' @param jug the jug instance
#' @param the path to bind to, default = NULL (all paths)
#' @param root_path
#'
#' @import mime
#' @export
serve_static_files<-function(jug, path=NULL, root_path=getwd()){
  gett(jug, path = NULL, function(req, res, err){
    file_path <- gsub("^(\\/)", "", req$path)

    if(file.exists(file_path)){
      res$content_type(mime::guess_type(file_path))
      paste0(readLines(file_path),collapse= "\n")
    } else {
      return(NULL)
    }

  })
}
