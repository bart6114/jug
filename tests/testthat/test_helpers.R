library(jug)

context("testing helper funcs")


test_that("match_path returns correct value",{
  path10<-"/"
  path11<-"/level1"
  path12<-"/level1/level2"
  path20<-"/test/(?<id>.*)/(?<id2>.*)"

  path10_proc <- match_path(path10, "/")
  path11_proc <- match_path(path11, "/level1")
  path11_neg_proc <- match_path(path11, "/level12")
  path12_proc <- match_path(path12, "/level1/level2")
  path12_neg_proc <- match_path(path12, "/level1/level3")
  path20_proc <- match_path(path20, "/test/val1/val2")

  expect_true(path10_proc$match)
  expect_true(path11_proc$match)
  expect_false(path11_neg_proc$match)
  expect_true(path12_proc$match)
  expect_false(path12_neg_proc$match)
  expect_true(path20_proc$match)
  expect_equivalent(path20_proc$params$id, "val1")
  expect_equivalent(path20_proc$params$id2, "val2")


})
