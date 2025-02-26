<p align="right">
  <img src="documentation/decimatoR_logo.png" alt="logo" width="100">
</p>

# decimatoR 
### The R package for converting coordinates formats to decimal degrees
decimatoR is a new R package for converting various formats of coordinates from published literature to decimal degrees. As a general approach, decimatoR identifies the alternative coordinate formats and then performs a set of wrangling actions on latitude and longitude data to convert all of them into decimal degrees. The novelty of this package is that it deals with different formats of reported coordinates: degrees-minutes-seconds (DMS) and degrees-decimal-minutes (DDM). Another novelty is that this package can function not only for single coordinate values, but also for coordinate intervals, which is a common method to report geographic ranges: 12ʹ45ʺ–12ʹ55ʺ. 


📊This package is useful for spatial **data syntheses** and **meta-analyses**, since coordinates can be reported in various formats in literature. 


### Usage Example
```R
decimatoR::process_coordinates_to_dd(coord_data, longitude = Longitude, latitude = Latitude)
```

### Installation 
In the R console: 

```R
install.packages("devtools")
devtools::install_github("elizavetashch/decimatoR")
```

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
To see the description of each function included in the package, please check out the workflow file :) 
