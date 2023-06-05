#' Format a number to EUR
#' @param x number
#' @return string with euro
#' @export
#' @importFrom scales dollar
#' @examples string with the eur
#' euro(42)
#' (euro(4200000))

library(scales)
euro<-function(x) {
  dollar(x, prefix = "€")
}


#Devtools::test()
#usethis::use_testthat()
#usethis::use_test()
#usethis::use_testfile()

#Unit tests - basic functions - testing the building blocks - functions (Test of function)
#End-to-End Tests - when integrating R (backend) to another app for frontend (Selenium for testing)
#Integration Tests - what happens if I click on this panel (Selenium for testing)

#Cypres for Javascript applications
