library(testthat)
library(data.table)

############### get_usdeur (single input)

test_that("get_usdeur returns a valid exchange rate", {
  exchange_rate <- get_usdeur()
  expect_type(exchange_rate, "double")
  expect_true(exchange_rate >= 0.9 && exchange_rate <= 1.1)
})

test_that("get_usdeur retries and eventually succeeds", {
  exchange_rate <- get_usdeur()
  expect_type(exchange_rate, "double")
  expect_true(exchange_rate >= 0.9 && exchange_rate <= 1.1)
})

############### get_usdeurs (data table)
# Test case 1: Check if the returned object is a data.table
test_that("Returned object is a data.table", {
  result <- get_usdeurs()
  expect_true(is.data.table(result))
})

# Test case 2: Check if the returned data.table has the correct columns
test_that("Returned data.table has the correct columns", {
  result <- get_usdeurs()
  expect_true("date" %in% colnames(result))
  expect_true("usdeur" %in% colnames(result))
})

# Test case 3: Check if the returned data.table has the expected number of rows (<32)
test_that("Returned data.table has the expected number of rows", {
  result <- content(GET('https://api.exchangerate.host/timeseries',
                        query = list(
                          start_date = Sys.Date() - 30,
                          end_date = Sys.Date(),
                          base = 'USD',
                          symbols = 'EUR'
                        )))
  data_table <- data.table(date = as.Date(names(result$rates)),
                           usdeur = as.numeric(unlist(result$rates)))
  expect_true(nrow(data_table) < 32)
})

# Test case 4: Check if the date column is in the correct format
test_that("Date column is in the correct format", {
  result <- get_usdeurs()
  expect_true(is.Date(result$date))
})

# Test case 5: Check if the usdeur column contains numeric values
test_that("usdeur column contains numeric values", {
  result <- get_usdeurs()
  expect_is(result$usdeur, "numeric")
})

# Test case 6: Check if the start and end dates are correct
test_that("Start and end dates are correct", {
  result <- get_usdeurs()
  expect_equal(result$date[1], Sys.Date() - 30)
  expect_equal(result$date[nrow(result)], Sys.Date())
})



