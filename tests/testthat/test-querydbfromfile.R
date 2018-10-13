context("test-querydbfromfile")

library(testthat)
library(sqlhelpers)
library(mockery)

test_that("it calls readr::read_lines with the filename", {
  filename <- "test_file.sql"
  m <- mock()
  stub(queryDbFromFile, "queryDb", NULL)

  with_mock(read_lines = m, {
    queryDbFromFile("server",
                    "database",
                    filename)
  }, .env = "readr")

  expect_args(m, 1, file = filename)
})

test_that("it calls queryDb with the passed parameters and the contents of the file", {
  query <- "abc"
  m <- mock()
  stub(queryDbFromFile, "readr::read_lines", query)

  with_mock(queryDb = m, {
    queryDbFromFile("server",
                    "database",
                    "test_file.sql",
                    a = 1,
                    b = 2)
  })

  expect_args(m, 1,
              server = "server",
              database = "database",
              query = query,
              a = 1,
              b = 2)
})
