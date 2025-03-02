#' Extract digits from a string after replace_nondigits_string/vecotr was applied
#'
#' @param string is an unorganized string
#'
#' @return list with first second and third digits saved as elements
#' @export
#'
#' @examples
#' extract_digits_from_string("34.1';9E")
extract_digits_from_string <- function(string) {
  # Split the string into parts based on semicolons using base R strsplit
  parts <- base::strsplit(string, ";", fixed = TRUE)[[1]]

  # Extract digits and dots from each part using base R gsub
  first <- base::gsub("[^0-9\\.]", "", parts[1])
  second <- base::ifelse(length(parts) >= 2, base::gsub("[^0-9\\.]", "", parts[2]), 0)
  third <- base::ifelse(length(parts) >= 3, base::gsub("[^0-9\\.]", "", parts[3]), 0)

  # Replace NA values with 0 using base R ifelse
  first <- base::ifelse(base::is.na(first), 0, first)
  second <- base::ifelse(base::is.na(second), 0, second)
  third <- base::ifelse(base::is.na(third), 0, third)

  # Return the extracted digits as a list using base R list
  return(base::list(first = first, second = second, third = third))
}

