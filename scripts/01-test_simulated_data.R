#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Project Hammer dataset, 
#          which includes grocery price data across vendors and products.
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
#   - 00-simulate_data.R must have been run
#   - Make sure you are in the correct project directory.


#### Workspace setup ####
library(tidyverse)

# Load the dataset
hammer_data <- read_csv("data/00-simulated_data/project_hammer_simulated_data.csv")

# Test if the data was successfully loaded
if (exists("hammer_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data structure ####

# Check if the dataset has 1000 rows (as per the simulated data)
if (nrow(hammer_data) == 1000) {
  message("Test Passed: The dataset has 1000 rows.")
} else {
  stop("Test Failed: The dataset does not have 1000 rows.")
}

# Check if the dataset has 7 columns
if (ncol(hammer_data) == 7) {
  message("Test Passed: The dataset has 7 columns.")
} else {
  stop("Test Failed: The dataset does not have 7 columns.")
}

# Check for column names and types
expected_columns <- c("product_id", "product_name", "category", "vendor", "current_price", "old_price", "nowtime")

if (all(names(hammer_data) == expected_columns)) {
  message("Test Passed: The dataset has the correct column names.")
} else {
  stop("Test Failed: The dataset does not have the correct column names.")
}

#### Test data validity ####

# Check if all values in 'vendor' column are valid vendor names
valid_vendors <- c("Voila", "T&T", "Loblaws", "No Frills", "Metro", "Galleria", "Walmart", "Save-On-Foods")
if (all(hammer_data$vendor %in% valid_vendors)) {
  message("Test Passed: The 'vendor' column contains only valid vendor names.")
} else {
  stop("Test Failed: The 'vendor' column contains invalid vendor names.")
}

# Check if all values in 'category' column are valid product categories
valid_categories <- c("Dairy", "Produce", "Bakery", "Meat", "Beverages", "Snacks", "Frozen Foods", "Household Items")
if (all(hammer_data$category %in% valid_categories)) {
  message("Test Passed: The 'category' column contains only valid categories.")
} else {
  stop("Test Failed: The 'category' column contains invalid categories.")
}

# Check if there are no duplicate product IDs
if (n_distinct(hammer_data$product_id) == nrow(hammer_data)) {
  message("Test Passed: All values in 'product_id' are unique.")
} else {
  stop("Test Failed: The 'product_id' column contains duplicate values.")
}

# Check if 'current_price' and 'old_price' columns have valid numeric values within expected range
if (all(hammer_data$current_price >= 1 & hammer_data$current_price <= 20)) {
  message("Test Passed: The 'current_price' column values are within the valid range.")
} else {
  stop("Test Failed: The 'current_price' column contains values outside the valid range.")
}

if (all(hammer_data$old_price >= 1 & hammer_data$old_price <= 20)) {
  message("Test Passed: The 'old_price' column values are within the valid range.")
} else {
  stop("Test Failed: The 'old_price' column contains values outside the valid range.")
}

# Check if all values in the 'nowtime' column are valid dates within the specified range
if (all(hammer_data$nowtime >= as.Date("2024-02-28") & hammer_data$nowtime <= as.Date("2024-11-01"))) {
  message("Test Passed: All values in 'nowtime' are within the valid date range.")
} else {
  stop("Test Failed: The 'nowtime' column contains dates outside the valid range.")
}

#### Check for missing or unexpected values ####

# Check if there are any missing values in the dataset
if (all(!is.na(hammer_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'product_name', 'category', 'vendor' columns
if (all(hammer_data$product_name != "" & hammer_data$category != "" & hammer_data$vendor != "")) {
  message("Test Passed: There are no empty strings in 'product_name', 'category', or 'vendor' columns.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

#### Additional consistency checks ####

# Identify rows where old_price is out of the 10% range and not at boundaries
outliers <- hammer_data %>%
  filter(!((abs(current_price - old_price) / current_price <= 0.1) | 
             old_price == 1 | old_price == 20))

# Print outliers for inspection
print(outliers)

# Adjusted test with a small tolerance (10.5%) to account for rounding issues
tolerance <- 0.105  # Adjust tolerance if necessary
boundary_check <- with(hammer_data, 
                       (abs(current_price - old_price) / current_price <= tolerance) | 
                         (old_price == 1) | (old_price == 20))

# Final test with adjusted tolerance
if (all(boundary_check)) {
  message("Test Passed: All 'old_price' values are within 10.5% of 'current_price' or at boundaries (1 or 20).")
} else {
  stop("Test Failed: Some 'old_price' values are not within 10.5% of 'current_price' and are not at boundaries.")
}

# Check if the 'category' column has at least two unique categories
if (n_distinct(hammer_data$category) >= 2) {
  message("Test Passed: The 'category' column contains at least two unique categories.")
} else {
  stop("Test Failed: The 'category' column contains less than two unique values.")
}
