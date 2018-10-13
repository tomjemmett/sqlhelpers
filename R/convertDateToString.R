#' @importFrom lubridate is.Date is.POSIXct
convertDateToString <- function(x) {
  if(lubridate::is.Date(x))    x = format(x, "%Y%m%d")
  else if(lubridate::is.POSIXct(x)) x = format(x, "%Y%m%d %H:%M:%S")
  x
}
