#' Extract digits from a vector after replace_nondigits_string/vecotr was applied
#'
#' @param strings is the output of the extract_digits_from_string function
#'
#' @return vector of lists aka a column
#' @export
#'
#' @examples
extract_digits_from_vector <- function(strings) {
  results <- purrr::map(strings, extract_digits_from_string)
  return(results)
}
