library(jug)

collected_mw2<-
  collector() %>%
  get("/", function(req,res,err){
    return("test2")
  })

