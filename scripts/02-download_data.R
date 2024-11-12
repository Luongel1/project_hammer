#### Preamble ####
# Purpose: Loads data from uploaded files and tests the structure and validity 
#          of the Project Hammer dataset, specifically checking price consistency.
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed.


#### Workspace setup ####
library(tidyverse)

# Define the directory to store files and ensure it exists
file_directory <- "C:/Users/eliza/Downloads/hammer-3-compressed"
if (!dir.exists(file_directory)) {
  dir.create(file_directory, recursive = TRUE)
}

# Define file names and their URLs (replace <URL> with the actual URL for each file)
files <- list(
  "average_price_by_vendor.csv" = "<URL_to_average_price_by_vendor.csv>",
  "price_trends_over_time.csv" = "<URL_to_price_trends_over_time.csv>",
  "largest_price_fluctuations.csv" = "<URL_to_largest_price_fluctuations.csv>",
  "price_comparison_specific_product.csv" = "<URL_to_price_comparison_specific_product.csv>",
  "historical_price_specific_product.csv" = "<URL_to_historical_price_specific_product.csv>",
  "price_changes.csv" = "<URL_to_price_changes.csv>",
  "unique_products_per_vendor.csv" = "<URL_to_unique_products_per_vendor.csv>",
  "product.csv" = "<URL_to_product.csv>"
)

# Download files if they do not already exist
for (file_name in names(files)) {
  file_path <- file.path(file_directory, file_name)
  if (!file.exists(file_path)) {
    download.file(url = files[[file_name]], destfile = file_path, mode = "wb")
    message(paste("Downloaded:", file_name))
  } else {
    message(paste("File already exists, skipped download:", file_name))
  }
}

# Load each dataset from the specified directory
average_price_by_vendor <- read_csv(file.path(file_directory, "average_price_by_vendor.csv"))
price_trends_over_time <- read_csv(file.path(file_directory, "price_trends_over_time.csv"))
largest_price_fluctuations <- read_csv(file.path(file_directory, "largest_price_fluctuations.csv"))
price_comparison_specific_product <- read_csv(file.path(file_directory, "price_comparison_specific_product.csv"))
historical_price_specific_product <- read_csv(file.path(file_directory, "historical_price_specific_product.csv"))
price_changes <- read_csv(file.path(file_directory, "price_changes.csv"))
unique_products_per_vendor <- read_csv(file.path(file_directory, "unique_products_per_vendor.csv"))
product <- read_csv(file.path(file_directory, "product.csv"))

# Clean and convert current_price and old_price in 'price_changes'
price_changes <- price_changes %>%
  mutate(
    current_price = as.numeric(gsub("[^0-9.]", "", current_price)),
    old_price = as.numeric(gsub("[^0-9.]", "", old_price))
  )

# Check for any remaining NA values after cleaning and convert them to median values if present
median_current <- median(price_changes$current_price, na.rm = TRUE)
median_old <- median(price_changes$old_price, na.rm = TRUE)

price_changes <- price_changes %>%
  mutate(
    current_price = ifelse(is.na(current_price), median_current, current_price),
    old_price = ifelse(is.na(old_price), median_old, old_price)
  )

# Final check to confirm all values are numeric and imputed
if (any(is.na(price_changes$current_price)) || any(is.na(price_changes$old_price))) {
  stop("Test Failed: Some 'current_price' or 'old_price' values could not be converted or imputed.")
} else {
  message("Test Passed: All 'current_price' and 'old_price' values are numeric and any missing values have been imputed with column medians.")
}
