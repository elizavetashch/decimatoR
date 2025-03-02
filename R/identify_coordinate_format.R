
#' Identify coordinate format
#'
#' @description
#' This function takes a dataset as an input and then adds another column with longitude and latitude corrected.
#'
#' @param df a dataset
#' @param longitude unorganised string
#' @param latitude unorganised string
#'
#' @return a dataset with 2 new columns for long and lat formats
#' @export
#'
#' @examples
#' identify_coordinate_format(
#' df = coord_data,
#' longitude = "Longitude",
#' latitude = "Latitude"
#' )
identify_coordinate_format <- function(df, longitude, latitude) {
  # Filter rows where longitude is not NA
  df <- dplyr::filter(df, !is.na(!!rlang::sym(longitude))) # dplyr for filtering rows
  df <- dplyr::filter(df, !(!!rlang::sym(longitude) %in% "NA")) # dplyr for filtering rows

  # Mutate to determine coordinate format for longitude and latitude
  df <- dplyr::mutate(df, # dplyr for adding new columns
                      long_coordinate_format = dplyr::case_when( # dplyr for conditional transformations
                        stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?((1[0-7]\\d|[1-9]?\\d)(\\.\\d{1,})?|180)\\D*[EWew]?$") ~ "DD", # stringr for pattern matching
                        stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?((1[0-7]\\d|[1-9]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|180(\\D+0)?)\\D+[EWew]?$") ~ "DDM", # stringr for pattern matching
                        stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?([1-7]?\\d{1,2}\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|180\\D+0\\D+0)\\D+[EWew]?$") ~ "DMS", # stringr for pattern matching
                        TRUE ~ NA_character_
                      ),
                      lat_coordinate_format = dplyr::case_when( # dplyr for conditional transformations
                        stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)(\\.\\d{1,})?|90)\\D*[NSns]?$") ~ "DD", # stringr for pattern matching
                        stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|90(\\D+0)?)\\D+[NSns]?$") ~ "DDM", # stringr for pattern matching
                        stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|90\\D+0\\D+0)\\D+[NSns]?$") ~ "DMS", # stringr for pattern matching
                        TRUE ~ NA_character_
                      )
  )

  # Handle DDM interval cases for longitude and latitude
  df <- dplyr::mutate(df, # dplyr for adding new columns
                      long_coordinate_format = dplyr::if_else( # dplyr for conditional logic
                        is.na(long_coordinate_format),
                        dplyr::case_when( # dplyr for conditional transformations
                          stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?((1[0-7]\\d|[0-9]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|180(\\D+0)?)\\D+[EWew]?-[\\+-]?((1[0-7]\\d|[0-9]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|180(\\D+0)?)\\D+[EWew]?$") ~ "DDM interval", # stringr for pattern matching
                          stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?((1[0-7]\\d|[1-9]?\\d)(\\.\\d{1,})?|180)\\D*[EWew]?-[\\+-]?((1[0-7]\\d|[1-9]?\\d)(\\.\\d{1,})?|180)\\D*[EWew]?$") ~ "DD interval", # DD interval
                          stringr::str_detect(!!rlang::sym(longitude), "^[\\+-]?([1-7]?\\d{1,2}\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|180\\D+0\\D+0)\\D+[EWew]?-[\\+-]?([1-7]?\\d{1,2}\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|180\\D+0\\D+0)\\D+[EWew]?$") ~ "DMS interval" # DMS interval
                        ),
                        long_coordinate_format
                      ),
                      lat_coordinate_format = dplyr::if_else( # dplyr for conditional logic
                        is.na(lat_coordinate_format),
                        dplyr::case_when( # dplyr for conditional transformations
                          stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|90(\\D+0)?)\\D+[NSns]?-[\\+-]?(([1-8]?\\d)\\D+[0-6]?\\d(\\.\\d{1,})?|90(\\D+0)?)\\D+[NSns]?$") ~ "DDM interval", # stringr for pattern matching
                          stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)(\\.\\d{1,})?|90)\\D*[NSns]?-[\\+-]?(([1-8]?\\d)(\\.\\d{1,})?|90)\\D*[NSns]?$") ~ "DD interval", # stringr for pattern matching
                          stringr::str_detect(!!rlang::sym(latitude), "^[\\+-]?(([1-8]?\\d)\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|90\\D+0\\D+0)\\D+[NSns]?-[\\+-]?(([1-8]?\\d)\\D+([0-5]?\\d|60)\\D+([0-5]?\\d|60)(\\.\\d+)?|90\\D+0\\D+0)\\D+[NSns]?$") ~ "DMS interval" # stringr for pattern matching
                        ),
                        lat_coordinate_format
                      )
  )

  # Convert formats to factors
  df$long_coordinate_format <- as.factor(df$long_coordinate_format) # base R for factor conversion
  df$lat_coordinate_format <- as.factor(df$lat_coordinate_format) # base R for factor conversion

  return(df)
}
