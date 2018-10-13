#' @importFrom purrr map
fixDates <- function(...) {
  dots <- list(...)

  # if ... was a single list, then we need to just select the first item of dots
  if (length(dots) == 1 && is.list(dots[[1]])) dots <- dots[[1]]

  purrr::map(dots, convertDateToString)
}
