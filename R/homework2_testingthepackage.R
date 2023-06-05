#' Look up the value of a US Dollar in EURs
#' @param retried number of times the function already failed
#' @return number
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom logger log_error log_info
#' @importFrom checkmate assert_number
#' @importFrom httr
#' @importFrom data.table
#' @importFrom testthat
#'
library(httr)
library(data.table)
get_usdeurs <- function() {
  response <- GET(
    'https://api.exchangerate.host/timeseries',
    query = list(
      start_date = Sys.Date() - 30,
      end_date = Sys.Date(),
      base = 'USD',
      symbols = 'EUR'
    )
  )

  content <- content(response)

  get_usdeurs <- data.table(
    date = as.Date(names(content$rates)),
    usdeur = as.numeric(unlist(content$rates))
  )

  return(get_usdeurs)
}

