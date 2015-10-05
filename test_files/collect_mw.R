library(jug)

jug() %>%
  require_middleware(my_mw, file_to_source = "test_files/collect_mw1.R")
