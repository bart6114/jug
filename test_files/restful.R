# RESTful example

test<-"/test/[id]"

library(stringi)
stringi::stri_detect("/test", regex="/test/(?<id>.*)")
stri_extract("/test/fsda", regex="/test/(?<id>.*)")

library(stringr)
str_match_perl("/test/fsda", "/test/(?<id>.*)")
str_match_all_perl
regexpr("/test/(?<id>.*)", "/test/dfsd",perl = T)
stri_match_all_regex("/test/fsda", "/test/(?<id>.*)")

