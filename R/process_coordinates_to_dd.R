#' Process the dataset and covert all types of coordinates to decimal degrees.
#'
#' @param df is a dataset
#' @param longitude its longitude column
#' @param latitude its latitude column
#' @param option is the parameter that is being passed to shorten_ddm_intervals_string, and can be set to "first" or "second"
#'
#' @return a dataset with new columns with coordinates in decimal format
#' @export
#'
#' @examples
#' process_coordinates_to_dd(
#' df = coord_data,
#' longitude = "Longitude",
#' latitude = "Latitude")
#'
process_coordinates_to_dd <- function(df, longitude, latitude, option = "first") {
  # Ensure longitude and latitude are strings representing column names
  longitude <- rlang::as_string(rlang::ensym(longitude))
  latitude <- rlang::as_string(rlang::ensym(latitude))

  # Step 1: Identify coordinate format
  df <- identify_coordinate_format(df, longitude, latitude)

  # Step 2: Apply `shorten_ddm_intervals_string` to longitude and latitude
  df <- dplyr::mutate(
    df, # NA FILTERING MISSING: SET LONG TEMP TO NA
    longitude_temp = dplyr::case_when(
      stringr::str_detect(long_coordinate_format, "interval") ~ base::sapply(df[[longitude]], shorten_ddm_intervals_string, option = option),
      TRUE ~ df[[longitude]]
    ),
    latitude_temp = dplyr::case_when(
      stringr::str_detect(lat_coordinate_format, "interval") ~ base::sapply(df[[latitude]], shorten_ddm_intervals_string, option = option),
      TRUE ~ df[[latitude]]
    )
  )

  # Step 3: Replace non-digits in longitude and latitude
  df <- dplyr::mutate(
    df,
    longitudecomma = base::sapply(longitude_temp, replace_nondigits_vector),
    latitudecomma = base::sapply(latitude_temp, replace_nondigits_vector)
  )

  # Step 4: Extract digits
  df <- dplyr::mutate(
    df,
    longitudedigits = base::sapply(longitudecomma, extract_digits_from_vector),
    latitudedigits = base::sapply(latitudecomma, extract_digits_from_vector)
  )

  # Step 5: Unlist digit components
  df <- dplyr::mutate(
    df,
    longitudedigits = purrr::map(longitudedigits, base::unlist),
    latitudedigits = purrr::map(latitudedigits, base::unlist)
  )

  # Step 6: Unnest digits into separate columns
  df <- tidyr::unnest_wider(df, col = c(longitudedigits, latitudedigits), names_sep = "_")

  # Step 7: Convert digit columns to numeric
  df <- dplyr::mutate(
    df,
    dplyr::across(longitudedigits_first:latitudedigits_third, as.numeric)
  )

  # Step 8: Calculate decimal degrees
  df <- dplyr::mutate(
    df,
    longitude_DD = longitudedigits_first + longitudedigits_second / 60 + longitudedigits_third / 3600,
    latitude_DD = latitudedigits_first + latitudedigits_second / 60 + latitudedigits_third / 3600
  )

  # Step 9: Extract and apply directions
  df <- dplyr::mutate(
    df,
    longitude_direction = base::sapply(longitude_temp, extract_direction_vector),
    latitude_direction = base::sapply(latitude_temp, extract_direction_vector),
    longitude_decimal = base::mapply(apply_direction_vector, longitude_DD, longitude_direction),
    latitude_decimal = base::mapply(apply_direction_vector, latitude_DD, latitude_direction)
  )
 
  df <-  dplyr::select(df, -c(longitude_temp:latitude_direction))
  return(df)
}
