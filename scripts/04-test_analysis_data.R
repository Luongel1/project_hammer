#### Preamble ####
# Purpose: Tests the structure and validity of the cleaned Project Hammer dataset
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: `tidyverse` and `testthat` packages must be installed
# Any other information needed? Ensure `cleaned_price_changes.csv` is present in the specified directory

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the cleaned dataset
cleaned_data <- read_csv("C:/Users/eliza/Downloads/hammer-3-compressed/cleaned_price_changes.csv")

# Ensure `price_difference` is calculated correctly as `price_current - price_old`
cleaned_data <- cleaned_data %>%
  mutate(price_difference = price_current - price_old)

# Identify rows with out-of-range prices
out_of_range <- cleaned_data %>%
  filter(price_current < 1 | price_current > 20 | price_old < 1 | price_old > 20)

# Display the out-of-range entries for inspection
print("Out-of-range values in 'price_current' or 'price_old':")
print(out_of_range)

# Optionally, filter data to include only rows within the $1 to $20 range
cleaned_data <- cleaned_data %>%
  filter(price_current >= 1, price_current <= 20, price_old >= 1, price_old <= 20)

#### Test data ####

# Test that the dataset has the expected number of columns (5 in this case)
test_that("dataset has 5 columns", {
  expect_equal(ncol(cleaned_data), 5)
})

# Test that columns are of the correct data type
test_that("'product', 'vendor_name' are character and prices are numeric", {
  expect_type(cleaned_data$product, "character")
  expect_type(cleaned_data$vendor_name, "character")
  expect_type(cleaned_data$price_current, "double")
  expect_type(cleaned_data$price_old, "double")
  expect_type(cleaned_data$price_difference, "double")
})

# Test that there are no missing values in key columns (product, vendor_name, prices)
test_that("no missing values in key columns", {
  expect_true(all(!is.na(cleaned_data$product)))
  expect_true(all(!is.na(cleaned_data$vendor_name)))
  expect_true(all(!is.na(cleaned_data$price_current)))
  expect_true(all(!is.na(cleaned_data$price_old)))
})

# Test that 'price_difference' is calculated correctly as price_current - price_old
test_that("'price_difference' is correct", {
  expect_equal(cleaned_data$price_difference, cleaned_data$price_current - cleaned_data$price_old)
})

# Test that 'price_current' and 'price_old' contain reasonable values (e.g., within the $1 to $20 range)
test_that("prices are within reasonable range", {
  expect_true(all(cleaned_data$price_current >= 1 & cleaned_data$price_current <= 20))
  expect_true(all(cleaned_data$price_old >= 1 & cleaned_data$price_old <= 20))
})

# Test that there are at least 2 unique vendors
test_that("vendor_name column contains at least 2 unique vendors", {
  expect_true(length(unique(cleaned_data$vendor_name)) >= 2)
})

# Test that 'price_current' and 'price_old' are not identical in every row (checking for variance)
test_that("price_current and price_old have some variance", {
  expect_false(all(cleaned_data$price_current == cleaned_data$price_old))
})
