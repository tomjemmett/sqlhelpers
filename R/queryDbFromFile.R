#' Run a query against a database
#'
#' This function allows you to run a query against a database, returning the
#' results in a tibble.
#'
#' The query is read from the file that is passed as an argument. See
#' \link{queryDb} if you want to pass the query as a string instead.
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
#' @param filename A path to a file to read the query from.
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
#' queryDbFromFile("MyServerName", "MyDatabase", "file.sql")
#'
#' queryDbFromFile("MyServerName",
#'                 "MyDatabase",
#'                 "file.sql",
#'                 id = 1,
#'                 date = Sys.Date())
#'
#' params <- list(id = 1, date = Sys.Date())
#' queryDbFromFile("MyServerName",
#'                 "MyDatabase",
#'                 "file.sql",
#'                 params)
#' }
queryDbFromFile <- function (server,
                             database,
                             filename,
                             ...) {
  query <- readr::read_file(filename)
  queryDb(server, database, query, ...)
}
