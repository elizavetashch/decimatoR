
#' Shorten DDM intervals within a string
#'
#' @param coordinate_strings is a coordinate column
#' @param option "first" or "second"
#'
#' @return coordinate string with where interval is cut to the first or second part
#' @export
#'
#' @examples
#' shorten_ddm_intervals_string("12ʹ45ʺ-12ʹ55ʺ", option = "first")

shorten_ddm_intervals_string <- function(coordinate_strings, option = "first") {
  # Extract the first part of the interval
  first <- stringr::str_extract(coordinate_strings, "^[^-]+")

  # Extract the second part of the interval
  second <- stringr::str_extract(coordinate_strings, "(?<=-).*")

  # Return the selected option
  result <- switch(option,
                   "first" = first,  # Take the first part of the interval
                   "second" = second,  # Take the second part of the interval
                   stop("Invalid option. Choose 'first' or 'second'."))

  return(result)
}
