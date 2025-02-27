# The decimatoR workflow

### 📖 Contents  
- [Basics: Problem, Solution, Types of Funcitons in the Package](#basics)
- [Step 0: Calling the process_coordinates_to_dd](#step-0) 
- [Step 1: Identifying Coordinate Formats](#step-1)  
- [Step 2: Handling DDM Intervals](#step-2)  
- [Step 3: Replacing Non-Digit Characters](#step-3)  
- [Step 4: Extracting Coordinate Components](#step-4)  
- [Step 5: Converting to Decimal Degrees](#step-5)  
- [Step 6: Extracting Coordinate Direction](#step-6)  
- [Step 7: Applying the Direction to Coordinate Values](#step-7)  
- [Step 8: Cleaning the Output](#step-8)  
 
## Basics  

A **dataframe** in R consists of **columns**, where each column is a **vector**. Each **row** represents an observation, containing values for each column. However, because observations are entered separately, inconsistencies can arise.  

### 🔹 The Problem: Inconsistent Data Formats  
Consider a dataframe containing geographic coordinates:  

- The **first observation** might be recorded in **decimal degree (DD) format**, making its value **numeric**.  
- The **second observation** might be recorded in **degrees, minutes, and seconds (DMS) format**, making its value a **character string**.  

Since R enforces **a single data type per column**, it **converts the entire column to character strings** if even one value is non-numeric.  

### 🔹 The Solution: Processing Each Value as a String  
To handle this, we need to:  
✅ Process **each value (string) individually**.  
✅ Apply a **function to the entire vector** (column).  

### 🔹 Two Types of Functions in the Package  
There are two categories of functions for processing coordinate data:  

1️⃣ **Functions for Individual Strings**  
   - Named **`_string` functions** (e.g., `extract_direction_string`).  
   - These operate on **a single string at a time**.  

2️⃣ **Functions for Vectors (Columns) of Strings**  
   - Named **`_vector` functions** (e.g., `extract_direction_vector`).  
   - These apply the corresponding **_string function** to each element in the vector.  
   - Essentially, they **iterate through the column**, applying the _string function to each value.  

🔹 **Key Insight:**  
The **_vector** function is just a wrapper that **applies the _string function to every row** in the column. The real work happens in the **_string function**.  

### ♣️ Two Special Case Functions  
There are **two exceptions** that work directly on dataframes:  

1. **`process_coordinates_to_dd`**  
   - Converts coordinates into **decimal degrees (DD)** format.  
   - Outputs four new columns:  
     - `long_coordinate_format` (factor)  
     - `lat_coordinate_format` (factor)  
     - `longitude_decimal` (numeric)  
     - `latitude_decimal` (numeric)  

2. **`identify_coordinate_format`**  
   - Identifies the **format of coordinates**.  
   - Outputs two new columns:  
     - `long_coordinate_format` (factor)  
     - `lat_coordinate_format` (factor)  

---

### 📌 Function Overview  

| **Function Name**              | **Input Arguments**                                                            | **Output**                                                              |
|--------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------|
| `process_coordinates_to_dd`    | `df` (dataframe), `longitude` (longitude column), `latitude` (latitude column) | df with four new columns: `long_coordinate_format`, `lat_coordinate_format`, `longitude_decimal`, `latitude_decimal` |
| `identify_coordinate_format`   | `df` (dataframe), `longitude` (longitude column), `latitude` (latitude column) | df with two new columns: `long_coordinate_format`, `lat_coordinate_format` |
| `_string`                      | string                                                                         | string                                                                 |
| `_vector`                      | vector (= column)                                                              | vector (= column)                                                       |

---
## The Workflow
## Step 0
### ☎️ calling the `process_coordinates_to_dd`
The `process_coordinates_to_dd` function is the main function for converting coordinates of various formats into decimal degrees. All the subsequent steps are wrapped within this function to ensure a seamless and structured workflow. 

🔹Users should only call this function to convert their dataset of coordinates. 

❗️The user must specify **three** arguments: `df` (dataset of coordinates), `longitude` (longitude column), `latitude` (latitude column). There is another `option` (“first” or “second”) argument, which refers to the preferred method of shortening ddm intervals (described later), and is set per default to “first”. 

 ---

## Step 1
### 💱 Identifying Coordinate Formats
The first step involves identifying the coordinate format of the `longitude` and `latitude` columns in the dataset using the `identify_coordinate_format` function. This function determines the format based on **regular expressions**, assigning one of five possible values:

🔹**DD**: Decimal Degrees

🔹**DMS**: Degrees, Minutes, and Seconds

🔹**DDM**: Degrees and Decimal Minutes

🔹**DDM interval**: Intervals of Degrees and Decimal Minutes (e.g., 12ʹ45ʺ–12ʹ55ʺ)

🔹**NA**: Unrecognized or invalid coordinates (e.g., values exceeding valid latitude/longitude ranges)

The input of the function is the `dataset`, the `longitude` and the `latitude` column. Therefore, it is the only function that can be called outside the `process_coordinates_to_dd` without any necessary adjustments. The output of this function are **two new columns** (`long_coordinate_format` and `lat_coordinate_format`) that store the identified **coordinate format** of longitude and latitude respectfully as one of the five factors above. The function ensures accurate format detection, which is critical for subsequent calculations. 

---

## Step 2
### 🖍 Handling DDM Intervals   

For coordinates in the **DDM interval format**, the `shorten_ddm_intervals_string` function extracts **one boundary of the interval**.  

🔹 Users can specify whether to extract the `"first"` or `"second"` boundary using the `option` argument.  
🔹 Example: The interval **12ʹ45ʺ–12ʹ55ʺ** becomes **12ʹ45ʺ** if `"first"` is selected.  

This step is **essential** because the package processes **one value per coordinate**, and **intervals cannot be directly converted to decimal degrees**.  

✅ The shortened coordinates are stored in **temporary columns** (`longitude_temp` and `latitude_temp`).  
✅ For **other formats**, these columns **mirror the original longitude and latitude values**.  

---

## Step 3
### 🔄 Replacing Non-Digit Characters  

The next step **standardizes** the coordinate strings by **replacing all non-digit characters** (except decimal points) with **semicolons (`;`)**.  

📌 This is done using the `replace_nondigits_vector` function, which applies `replace_nondigits_string` to **each value** in the `longitude_temp` and `latitude_temp` columns.  

✨ **Additional processing:**  
- **Unnecessary whitespaces** are removed.  
- **Resulting strings** (stored in `longitudecomma` and `latitudecomma`) contain **only digits, semicolons, and decimal points**, making it easier to extract coordinate components.  

---

## Step 4
### 🔍 Extracting Coordinate Components  

The `extract_digits_from_string` function **splits a cleaned coordinate string into three components**:  
1️⃣ Degrees  
2️⃣ Minutes  
3️⃣ Seconds  

🔹 The function works by **splitting the input string into three parts using semicolons (`;`)** as delimiters.  
🔹 Each part corresponds to a **potential coordinate component** (degrees, minutes, or seconds).  

🛠 **Processing Steps:**  
1. **Non-digit characters** (except for dots) are **removed** using a **regular expression**.  
2. If **fewer than three parts exist**, missing values are **replaced with `0`** (e.g., decimal degree coordinates will have the **first** value stored, and the **second/third** will be filled with `0`).  
3. The three extracted strings are stored in a **list of three lists**, named:  
   - **first** → Degrees  
   - **second** → Minutes  
   - **third** → Seconds  

📌 The corresponding `extract_digits_from_vector` function applies `extract_digits_from_string` **to every element in the column**, creating:  
- **New columns** (`longitudedigits` and `latitudedigits`) storing **lists of extracted strings**.  
- The **lists are unlisted** using `base::unlist`, converting elements into atomic vectors.  
- The **`tidyr::unnest_wider` function expands** these values into **six separate columns**:  
  - `longitudedigits_first`, `longitudedigits_second`, `longitudedigits_third` (**Longitude: Degrees, Minutes, Seconds**)  
  - `latitudedigits_first`, `latitudedigits_second`, `latitudedigits_third` (**Latitude: Degrees, Minutes, Seconds**)  

✅ This transformation ensures that **each coordinate component is stored separately** for easy numerical calculations in the next steps.  

---

## Step 5
### 🔢 Converting to Decimal Degrees  

Using the extracted components, the package **calculates decimal degrees** for longitude and latitude using the formula:  

📌 **Results:**  
- Decimal numbers are stored in the columns:  
  - `longitude_DD`  
  - `latitude_DD`  

---

## Step 6
### 🧭 Extracting Coordinate Direction  

The `extract_direction_string` function **determines the sign** of the coordinate string based on:  

🔹 The **presence of directional markers** (`"S"` for south, `"W"` for west).  
🔹 If the coordinate **starts with a negative sign (`-`)**.  

📌 **Function Output:**  
- Returns `"+"` for **northern or eastern** directions.  
- Returns `"-"` for **southern or western** directions.  

✨ The corresponding **vectorized function** (`extract_direction_vector`) applies this logic to **an entire column of coordinates**.  
✨ The result is a **new column**:  
  - `longitude_direction` or `latitude_direction`, specifying the **directional sign**.  

---

## Step 7
### ➕ Applying the Direction to Coordinate Values  

The `apply_direction_string` function **adjusts the sign** of numeric coordinate values based on the extracted directional component.  

🔹 **How it works:**  
✅ Takes the **absolute value** of the coordinate (`longitude_DD` or `latitude_DD`).  
✅ **Negates** the value if the direction is `"-"` (**south or west**).  

📌 **The vectorized function** (`apply_direction_vector`) applies `apply_direction_string` to **all values in the dataset**, generating:  
- `longitude_decimal`  
- `latitude_decimal`  

✅ These columns contain the **final converted coordinates in decimal degrees with the correct direction sign**.  

---

## Step 8
### 🧹 Cleaning the Output  

Finally, unnecessary intermediate and temporary columns are **removed** using `dplyr::select`.  

📌 **Final Output:**  
- The original dataset **plus new columns** for **coordinate formats** and **decimal degrees**:  
  - `long_coordinate_format`  
  - `lat_coordinate_format`  
  - `longitude_decimal`  
  - `latitude_decimal`  
