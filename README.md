<p align="right">
  <img src="documentation/decimatoR_logo.png" alt="logo" width="100">
</p>

# decimatoR 
### The R package for converting coordinates formats to decimal degrees
decimatoR is a new R package for converting various formats of coordinates from published literature to decimal degrees. As a general approach, decimatoR identifies the alternative coordinate formats and then performs a set of wrangling actions on latitude and longitude data to convert all of them into decimal degrees. The novelty of this package is that it deals with different formats of reported coordinates: degrees-minutes-seconds (DMS) and degrees-decimal-minutes (DDM). Another novelty is that this package can function not only for single coordinate values, but also for coordinate intervals, which is a common method to report geographic ranges: 12ʹ45ʺ–12ʹ55ʺ. 


📊This package is useful for spatial **data syntheses** and **meta-analyses**, since coordinates can be reported in various formats in literature. 

### Installation 
In the R console: 

```R
install.packages("devtools")
devtools::install_github("elizavetashch/decimatoR")
```

### Usage Example
`coord_data` and `messy_coordinates` are two toy datasets available in the package, feel free to test it out yourself: 
```R
decimatoR::process_coordinates_to_dd(coord_data, longitude = Longitude, latitude = Latitude)
```

```R
View(messy_coordinates)
```

| ID  | Longitude            | Latitude             |
|-----|----------------------|----------------------|
| 1   | 108°7′              | 34°12′              |
| 2   | 116°35´16.24´´      | 39°35´47.03´´       |
| 3   | 115.670177          | 37.73892            |
| 4   | 108°2′              | 34°4′               |
| 5   | 117°41′37″          | 31°39′37″          |
| 6   | 48.983333330000001  | 125.2833333        |
| 7   | 38°12ʹE-38°19ʹE     | 11°32ʹN-12°16ʹN    |
| 8   | 0°22ʹW              | 51°48ʹN            |
| 9   | 54°13ʹ51ʺW         | 28°15ʹ59ʺS         |
| 10  | 34.24               | -13.23              |
| 11  | 111.4870419109      | 28.907120991100001  |
| 12  | 50°05ʹW             | 25°10ʹS            |

```R
decimatoR::process_coordinates_to_dd(messy_coordinates, longitude = Longitude, latitude = Latitude)
```
| ID  | Longitude            | Latitude             | long_coordinate_format | lat_coordinate_format | longitude_decimal | latitude_decimal |
|-----|----------------------|----------------------|------------------------|-----------------------|-------------------|------------------|
| 1   | 108°7′              | 34°12′              | DDM                    | DDM                   | 108.0             | 34.2             |
| 2   | 116°35´16.24´´      | 39°35´47.03´´       | DMS                    | DMS                   | 117.0             | 39.6             |
| 3   | 115.670177          | 37.73892            | DD                     | DD                    | 116.0             | 37.7             |
| 4   | 108°2′              | 34°4′               | DDM                    | DDM                   | 108.0             | 34.1             |
| 5   | 117°41′37″          | 31°39′37″          | DMS                    | DMS                   | 118.0             | 31.7             |
| 6   | 48.983333330000001  | 125.2833333        | DD                     | NA                    | 49.0              | 125.0            |
| 7   | 38°12ʹE-38°19ʹE     | 11°32ʹN-12°16ʹN    | DDM interval           | NA                    | 38.2              | 11.5             |
| 8   | 0°22ʹW              | 51°48ʹN            | DDM                    | DDM                   | -0.367            | 51.8             |
| 9   | 54°13ʹ51ʺW         | 28°15ʹ59ʺS         | DMS                    | DMS                   | -54.2             | -28.3            |
| 10  | 34.24               | -13.23              | DD                     | DD                    | 34.2              | -13.2            |
| 11  | 111.4870419109      | 28.9071209911000…  | DD                     | DD                    | 111.0             | 28.9             |
| 12  | 50°05ʹW             | 25°10ʹS            | DDM                    | DDM                   | -50.1             | -25.2            |


### Dependencies 

The package uses dplyr for data manipulation, tidyr for reshaping data, stringr for string handling, rlang for managing programming constructs, and purrr for applying functions to lists and vectors. These dependencies ensure efficient and flexible data processing.
```R
install.packages(c("dplyr", "tidyr", "stringr", "rlang", "purrr"))
library(dplyr)
library(tidyr
library(stringr)
library(rlang)
library(purrr)
```
### Package Workflow 
To see the description of each function included in the package, please check out the [workflow page on the wiki](https://github.com/elizavetashch/decimatoR/wiki/The-decimatoR-workflow)


