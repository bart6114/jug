#' An error handler middleware
#'
#' @param jug the jug instance
#' @param path the path to bind to, default = NULL (all paths)
#' @param to_cat_or_not_to_cat the argument says it all
#'
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
