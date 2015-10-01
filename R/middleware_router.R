# #' MiddlewareRouter R6 class definition
# #'
# #' @import R6
# MiddlewareRouter<-
#   R6Class("MiddlewareRouter",
#           public=list(
#             get=list(),
#             post=list(),
#             add_path=function(path, func, method="GET"){
#               if(method=="GET"){
#                 self$get[[path]]<-func
#               } else {
#                 self$post[[path]]<-func
#               }
#             },
#             invoke=function(req, res){
#               path<-req$PATH_INFO
#
#             }
#           )
#   )
#
# #' Create the router middleware
# define_router<-function(){
#   MiddlewareRouter$new()
# }
#
# #' Add GET route
# #'
# #' @param router_ref the (reference) router object
# #' @param path path of the route
# #' @param func the function to be executed (if NULL will look for a file to load)
# get<-function(router_ref, path, func=NULL, method="GET"){
#   router_ref$add_path(path, func, method)
#
#   router_ref
# }
#
# #' Add POST route
# #'
# #' @param router_ref the (reference) router object
# #' @param path path of the route
# #' @param func the function to be executed (if NULL will look for a file to load)
# post<-function(router_ref, path, func=NULL, method="POST"){
#   router_ref$add_path(path, func, method)
#
#   router_ref
# }
#
# finish_router<-function(router_ref){
#   router_ref$invoke
# }
