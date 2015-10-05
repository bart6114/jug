rmarkdown::render("vignettes/jug.Rmd",
                  output_format = "html_document",
                  output_file = "index.html",
                  output_dir = getwd())


file.copy("index.html", "../jug-gh-pages/index.html", overwrite = TRUE)
unlink("index.html")


cwd<-getwd()

setwd("../jug-gh-pages")
system("git a")
system('git commit -am "copied vignette to gh-pages"')
system('git push')

setwd(cwd)



