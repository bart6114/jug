rmarkdown::render("vignettes/jug.Rmd",
                  output_format = "md_document",
                  output_file = "README.md",
                  output_dir = getwd())

