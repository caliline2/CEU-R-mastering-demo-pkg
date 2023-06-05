#' Look up the value of a US Dollar in EURs
#' @param retried number of times the function already failed
#' @return number
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom logger log_error log_info
#' @importFrom checkmate assert_number
#' @importFrom httr
#' @importFrom data.table
#'
get_usdeur <- function(retried = 0) {
  tryCatch({
    ## httr
    usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
    assert_number(usdeur, lower = 0.9, upper = 1.1)
  }, error = function(e) {
    log_error(e$message)
    if (retried > 3) {
      stop('Gave up')
    }
    Sys.sleep(1 + retried ^ 2)
    get_usdeur(retried = retried + 1)
  })
  log_info('1 USD={usdeur} EUR')
  usdeur
}


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

get_usdeurs()

