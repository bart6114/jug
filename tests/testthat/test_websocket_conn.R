library(jug)

context("testing websocket connection")

test_req<-RawTestRequest$new()
test_req$set_header("upgrade", "websocket")

# TO IMPLEMENT
