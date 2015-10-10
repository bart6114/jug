library(rmarkdown)
render("vignettes/jug.Rmd",
                  # output_format = "html_document",
                  # output_file = "index.html",
                  # output_dir = getwd(),
                  html_document(toc=TRUE,
                                theme="flatly"))


file.copy("vignettes/jug.html", "../jug-gh-pages/index.html", overwrite = TRUE)
unlink("vignettes/jug.html")

proceed<-readline("push? (y/n)")
if(proceed=="y"){

  cwd<-getwd()

  setwd("../jug-gh-pages")
  system("git add .")
  system('git commit -am "copied vignette to gh-pages"')
  system('git push')

  setwd(cwd)
}
