library(jug)

my_mw<-
  collector() %>%
  get("/", function(req, res, err) "test" )
