#' Apply the direction to the decimal coordinate within a string
#'
#' @param string_decimal numeric
#' @param string_direction minus or plus
#'
#' @return string
#' @export
#'
#' @examples
apply_direction_string <- function(string_decimal, string_direction) {
  result <- base::ifelse(string_direction == "-", -base::abs(string_decimal), base::abs(string_decimal))
  return(result)
}

