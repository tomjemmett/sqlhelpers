context("test-fixdates")

library(testthat)
library(sqlhelpers)
library(mockery)

test_that("it passes the ... objects to map", {
  m <- mock()

  with_mock(map = m, {
    fixDates(a = 1, b = 2)
  }, .env = "purrr")

  expect_args(m, 1, list(a = 1, b = 2), convertDateToString)
})

test_that("if a list is the argument then it passes that to map", {
  m <- mock()

  with_mock(map = m, {
    fixDates(list(a = 1, b = 2))
  }, .env = "purrr")

  expect_args(m, 1, list(a = 1, b = 2), convertDateToString)
})

test_that("it returns a list", {
  ret <- fixDates(list(a = 1,
                       b = "2",
                       c = lubridate::ymd(20180101),
                       d = lubridate::ymd_hms("20180101 01:23:45")))

  expect_equal(ret, list(a = 1,
                         b = "2",
                         c = "20180101",
                         d = "20180101 01:23:45"))
})
