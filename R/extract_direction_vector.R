#' Extract direction (East/South/West/North) as a minus or plus from a vector
#'
#' @param strings is a column in a dataset
#'
#' @return returns a vector (column) which contains directions of the coordinate string (plus or minus)
#' @export
#'
#' @examples
extract_direction_vector <- function(strings) {
  direction_strings <- base::lapply(strings, extract_direction_string)
  return(direction_strings)
}
