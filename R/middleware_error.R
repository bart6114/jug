#' An error handler middleware which returns a error description in HTML format
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#' @param to_cat_or_not_to_cat the argument says it all
#'
#' @seealso simple_error_handler_json
#' @export
simple_error_handler<-function(jug, path=NULL, to_cat_or_not_to_cat="cat"){
  use(jug, path = NULL, function(req, res, err){
    res$content_type("text/html")

    if(err$occurred){
      res$status<-500L
      errs_string<-paste(err$errors, collapse="\n")

      if(getOption("jug.verbose")) cat("ERROR:\n", errs_string, "\n")

      infuser::infuse(system.file("html_templates", "500.html", package="jug"),
                      errs=errs_string)
    } else {
      res$status=404L

      cat<-ifelse(to_cat_or_not_to_cat=="cat",
                  '<img src="http://thecatapi.com/api/images/get?format=src&type=gif">',
                  "")

      infuser::infuse(system.file("html_templates", "404.html", package="jug"),
                      cat=cat)
    }
  })
}

#' An error handler middleware which returns a error description in JSON format
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#'
#' @seealso simple_error_handler
#' @export
simple_error_handler_json<-function(jug, path=NULL){
  use(jug, path = NULL, function(req, res, err){
    res$content_type("application/json")

    if(err$occurred){
      res$status<-500L
      errs_string<-paste(err$errors, collapse="\n")

      if(getOption("jug.verbose")) cat("ERROR:\n", errs_string, "\n")

      res$json(list(status="error", status_code=500L, error=errs_string))
    } else {
      res$status=404L
      res$json(list(status="page not found", status_code=404L))
    }
  })
}

