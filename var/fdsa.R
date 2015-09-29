library(interfacer)
library(infuser)



req<-list()

showReq<-function(req){req<<-req;paste(ls(req), collapse=",<br>")}
helloWorld<-function(x=6){paste("Hello world", x)}
headerTest<-function(HTTP_TEST){paste("Hello world", HTTP_TEST)}


library(magrittr)
interfacer() %>%
  add_func(showReq, res_content_type = "text/html") %>%
  add_func(helloWorld) %>%
  add_func(headerTest) %>%
  start_interface(verbose=T)
