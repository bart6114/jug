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
      res$status=500L

      paste0(
        '<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <title>Error</title>
        </head>
        <body>
        <p>An error occurred</p>
        <p>',paste(err$errors, collapse="\n"),'</p>
        </body>
        </html>'
      )
    } else {
      res$status=404L

      cat<-ifelse(to_cat_or_not_to_cat=="cat", '<img src="http://thecatapi.com/api/images/get?format=src&type=gif">', "")

      paste0(
        '<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <title>Not found</title>
        </head>
        <body>
        <p>No handler bound to path</p>
        ',cat,'
        </body>
        </html>
        '
      )
    }
    })
    }
