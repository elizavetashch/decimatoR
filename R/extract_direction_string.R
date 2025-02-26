#' Extract direction (East/South/West/North) as a minus or plus from a string
#'
#' @param coordinate_string
#'
#' @return returns a coordinate string for further processing with extract_direction_vector
#' @export
#'
#' @examples
#' extract_direction_string("34.56E")
#' extract_direction_string("34.56W")
extract_direction_string <- function(coordinate_string) {
  direction_string <-  base::ifelse(stringr::str_detect(coordinate_string, "[SsWw]") | stringr::str_starts(coordinate_string, "^-"),    "-",    "+"
  )
  return(direction_string)
}
