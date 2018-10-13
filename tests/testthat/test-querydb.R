context("test-querydb")

library(testthat)
library(sqlhelpers)
library(mockery)

test_that("the query argument is used as the queries statement", {
  query <- "abc"
  m <- mock(123)

  s <- function(x, y, .dots) y

  stub(queryDb, "odbc::odbc", NULL)
  stub(queryDb, "DBI::dbConnect", NULL)
  stub(queryDb, "DBI::dbDisconnect", NULL)
  stub(queryDb, "tibble::as.tibble", NULL)

  with_mock(dbGetQuery = m, {
    with_mock(sqlInterpolate = s, {
      queryDb("server",
              "database",
              query)
    }, .env = "DBI")
  }, .env = "DBI")

  expect_args(m, 1, conn = NULL, statement = query)
})

test_that("it calls dbConnect with the passed parameters", {
  m <- mock()

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::sqlInterpolate", NULL)
  stub(queryDb, "DBI::dbGetQuery", NULL)
  stub(queryDb, "DBI::dbDisconnect", NULL)
  stub(queryDb, "tibble::as.tibble", NULL)

  with_mock(dbConnect = m, {
    queryDb("server",
            "database",
            "query")
  }, .env = "DBI")

  expect_args(m,
              1,
              drv = "odbc",
              server = "server",
              database = "database")
})

test_that("it calls dbDisconnect when the query succeeds", {
  m <- mock()

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::dbConnect", NULL)
  stub(queryDb, "DBI::sqlInterpolate", NULL)
  stub(queryDb, "DBI::dbGetQuery", NULL)
  stub(queryDb, "tibble::as.tibble", NULL)

  with_mock(dbDisconnect = m, {
    queryDb("server",
            "database",
            "query")
  }, .env = "DBI")

  expect_called(m, 1)
})

test_that("it calls dbDisconnect if the query failes", {
  m <- mock()

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::dbConnect", NULL)
  stub(queryDb, "DBI::sqlInterpolate", NULL)
  stub(queryDb, "tibble::as.tibble", NULL)

  e <- function() { stop ("An error") }

  with_mock(dbDisconnect = m, {
    with_mock(dbGetQuery = e, {
      expect_error(
        queryDb("server",
                "database",
                "query")
      )
    }, .env = "DBI")
  }, .env = "DBI")

  expect_called(m, 1)
})

test_that("it interpolates parameters", {
  m <- mock()

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::dbConnect", "con")
  stub(queryDb, "DBI::dbDisconnect", NULL)
  stub(queryDb, "DBI::dbGetQuery", NULL)
  stub(queryDb, "fixDates", list(a = 1, b = 2))

  with_mock(sqlInterpolate = m, {
    queryDb("server",
            "database",
            "query",
            a = 1,
            b = 2)
  }, .env = "DBI")

  expect_args(m, 1,
              con = "con",
              query = "query",
              .dots = list(a = 1, b = 2))
})

test_that("it returns a tibble", {
  df <- data.frame(a = 1:3, b = 4:6)
  m <- mock(df)

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::dbConnect", NULL)
  stub(queryDb, "DBI::dbDisconnect", NULL)
  stub(queryDb, "DBI::sqlInterpolate", NULL)

  with_mock(dbGetQuery = m, {
    ret <- queryDb("server",
                   "database",
                   "query")
  }, .env = "DBI")

  expect_true(tibble::is_tibble(ret))
})

test_that("it calls fixDates", {
  m <- mock()

  stub(queryDb, "odbc::odbc", "odbc")
  stub(queryDb, "DBI::dbConnect", NULL)
  stub(queryDb, "DBI::dbDisconnect", NULL)
  stub(queryDb, "DBI::sqlInterpolate", NULL)
  stub(queryDb, "DBI::dbGetQuery", NULL)
  stub(queryDb, "tibble::as.tibble", NULL)

  with_mock(fixDates = m, {
    queryDb("server",
            "database",
            "query",
            a = 1,
            b = 2)
  }, .env = "sqlhelpers")

  expect_args(m, 1, a = 1, b = 2)
})
