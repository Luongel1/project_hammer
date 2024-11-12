#### Preamble ####
# Purpose: Cleans the Project Hammer data recorded by various sources and formats it for analysis
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `janitor` packages must be installed
# Any other information needed? Ensure the data files have been downloaded and are in the specified directory

#### Workspace setup ####
library(tidyverse)
library(janitor)

# Define the directory where data files are located
file_directory <- "C:/Users/eliza/Downloads/hammer-3-compressed"

#### Clean data ####

# Load raw data from the price_changes file
raw_data <- read_csv(file.path(file_directory, "price_changes.csv"))

# Begin cleaning and formatting the data
cleaned_data <-
  raw_data |>
  janitor::clean_names() |>  # Clean column names to snake_case
  select(product_name, vendor, current_price, old_price, price_change) |>  # Select relevant columns
  mutate(
    # Clean current_price and old_price by removing non-numeric characters
    current_price = as.numeric(gsub("[^0-9.]", "", current_price)),
    old_price = as.numeric(gsub("[^0-9.]", "", old_price))
  ) |>
  mutate(
    # Handle missing values by imputing with column median
    current_price = if_else(is.na(current_price), median(current_price, na.rm = TRUE), current_price),
    old_price = if_else(is.na(old_price), median(old_price, na.rm = TRUE), old_price)
  ) |>
  rename(
    product = product_name,
    vendor_name = vendor,
    price_current = current_price,
    price_old = old_price,
    price_difference = price_change
  ) |>
  tidyr::drop_na()  # Remove rows with any remaining NAs

#### Save cleaned data ####
write_csv(cleaned_data, file.path(file_directory, "cleaned_price_changes.csv"))