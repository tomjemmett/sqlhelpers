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
#' Altenatively, you can create an environment variable called R_DB_\[SERVER\]
#' as a json string that contains all of the parameters to pass to dbConnect.
#'
#' Parameters can be used in queries by either specifying each parameter and
#' it's value after the query parameter, or by specifying all of the parameters
#' in a named list.
#'
#' @param server The name of the DSN for the server you want to connect to, or the name
#'     of a environment variable (with the prefix R_DB_)
#' @param database The name of the database that you want to run the query against
#' @param query The query as a string that you want to run against the database
#' @param ... Named parameters to interpolate into the query
#'
#' @return The results of the query as a tibble
#' @export
#'
#' @importFrom DBI dbConnect sqlInterpolate dbGetQuery dbDisconnect
#' @importFrom odbc odbc odbcListDataSources
#' @importFrom tibble as_tibble
#' @importFrom jsonlite parse_json
#' @importFrom stringr str_replace
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

  if (!server %in% odbc::odbcListDataSources()$name) {
    x <- Sys.getenv(paste0("R_DB_", server))
    if (x == "") {
      stop ("No odbc or environment variable found for ", server)
    }

    x <- jsonlite::parse_json(str_replace(x, "\\\\", "\\\\\\\\"))
  } else {
    x <- list()
    x$dsn <- server
  }

  x$drv <- odbc::odbc()
  x$database <- database

  tryCatch({
    con <- do.call(DBI::dbConnect, x)

    query <- DBI::sqlInterpolate(con,
                                 query,
                                 .dots=params)

    df <- DBI::dbGetQuery(con, query)
  },
  catch = function(e) {
    stop(e)
  },
  finally = {
    DBI::dbDisconnect(con)
  })

  return (tibble::as_tibble(df))
}
