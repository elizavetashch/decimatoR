#' Replace non-digits in a vector
#'
#' @param strings is a column
#'
#' @return vector (aka column in a dataset) with replaced nondigits
#' @export
#'
#' @examples
replace_nondigits_vector <- function(strings) {
  new_strings <- base::lapply(strings, replace_nondigits_string)
  return(new_strings)
}
