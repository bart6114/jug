say_hello_to<-function(name) paste("Hello", name)

library(jug)

jug() %>%
  get("/", decorate(say_hello_to)) %>%
  serve_it()
