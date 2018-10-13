context("test-convertdatetostring")

library(testthat)
library(sqlhelpers)
library(mockery)

test_that("if the argument is a date it is returned as a string", {
  r <- convertDateToString(lubridate::ymd(20180101))
  expect_equal(r, "20180101")
})

test_that("if the argument is a datetime it is returned as a string", {
  r <- convertDateToString(lubridate::ymd_hms("20180101 01:23:45"))
  expect_equal(r, "20180101 01:23:45")
})


test_that("if the argument is a string it is returned unchanged", {
  r <- convertDateToString("abc")
  expect_equal(r, "abc")
})

test_that("if the argument is a number it is returned unchanged", {
  r <- convertDateToString(123)
  expect_equal(r, 123)

  r <- convertDateToString(123.456)
  expect_equal(r, 123.456)
})
