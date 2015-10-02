library(jug)

my_first_name<-NULL
my_last_name<-NULL

jug() %>%
  post("/", function(req, res){
    my_first_name<<-req$post$first_name
    my_last_name<<-req$post$last_name
    return(TRUE)
  }) %>%
  get("/", function(req, res){
    paste("Hello",my_first_name, my_last_name)
  }) %>%
  serve_it()
