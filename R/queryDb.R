#' Run a query against a database
#'
#' This function allows you to run a query against a database, returning the
#' results in a tibble.
#'
#' The query is passed as an argument. See \link{queryDbFromFile} if you want to
#' read the query from a file.
#'
#' The connection to the server is made by odbc and uses the name of a DSN to
#' connect to. This removes any requirement to hard code in usernames, passwords
#' and connection strings into files.
#'
#' Parameters can be used in queries by either specifying each parameter and
#' it's value after the query parameter, or by specifying all of the parameters
#' in a named list.
#'
#' @param server The name of the DSN for the server you want to connect to
#' @param database The name of the database that you want to run the query against
#' @param query The query as a string that you want to run against the database
#' @param ... Named parameters to interpolate into the query
#'
#' @return The results of the query as a tibble
#' @export
#'
#' @importFrom DBI dbConnect sqlInterpolate dbGetQuery dbDisconnect
#' @importFrom odbc odbc
#' @importFrom tibble as.tibble
#'
#' @examples
#' \dontrun{
#' queryDb("MyServerName", "MyDatabase", "SELECT * FROM Table")
#'
#' queryDb("MyServerName",
#'         "MyDatabase",
#'         "SELECT * FROM Table WHERE Id = ?id AND Date = ?date",
#'         id = 1,
#'         date = Sys.Date())
#'
#' params <- list(id = 1, date = Sys.Date())
#' queryDb("MyServerName",
#'         "MyDatabase",
#'         "SELECT * FROM Table WHERE Id = ?id AND Date = ?date",
#'         params)
#' }
queryDb <- function (server,
                     database,
                     query,
                     ...) {
  params <- fixDates(...)

  tryCatch({
    con <- DBI::dbConnect(odbc::odbc(),
                          server,
                          database = database)

    query <- DBI::sqlInterpolate(con,
                                 query,
                                 .dots=params)

    df <- DBI::dbGetQuery(con, query)
  },
  finally = {
    DBI::dbDisconnect(con)
  })

  return (tibble::as.tibble(df))
}
