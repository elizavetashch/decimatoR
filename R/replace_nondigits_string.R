
#' Replace non-digits within a string
#'
#' @param string is an unorganized string
#'
#' @return string with replaced nondigits
#' @export
#'
#' @examples
#' replace_nondigits_string("12ʹ45ʺ")
#' replace_nondigits_string("9.99\"00E")
replace_nondigits_string <- function(string) {
  # Remove leading "-" if present
  string <- stringr::str_replace(string, "^-", "") # stringr for pattern replacement

  # Remove all letters
  string <- stringr::str_remove_all(string, "[A-Za-z]") # stringr for removing all matching patterns

  # Remove whitespaces
  string <- stringr::str_replace_all(string, " ", "") # stringr for replacing whitespaces

  # Replace remaining non-digit characters except for "." with ";"
  new_string <- base::gsub("[^0-9\\.]", ";", string) # base R for general substitutions

  # Replace ";;" with ";"
  result_string <- base::gsub(";;", ";", new_string) # base R for general substitutions

  return(result_string)
}
