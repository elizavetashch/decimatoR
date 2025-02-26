#' Apply the direction to the decimal coordinate within coordinate vector (appled on a dataset)
#'
#' @param string_decimal numeric
#' @param string_direction plus or minus
#'
#' @return vector with applied direction vector
#' @export
#'
#' 
apply_direction_vector <- function(string_decimal, string_direction) {
  applied_string <- base::mapply(apply_direction_string, string_decimal, string_direction)
  return(applied_string)
}
