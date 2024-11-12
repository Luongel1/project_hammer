#### Preamble ####
# Purpose: Simulates a dataset for Project Hammer, which aims to monitor grocery prices 
#          across vendors and products to analyze market competition in Canada.
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed.
# Note: Run this script in an R project workspace if needed.

#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate data ####

# Vendor names (8 vendors as described)
vendors <- c("Voila", "T&T", "Loblaws", "No Frills", "Metro", "Galleria", "Walmart", "Save-On-Foods")

# Product categories (for variety in products)
product_categories <- c("Dairy", "Produce", "Bakery", "Meat", "Beverages", "Snacks", "Frozen Foods", "Household Items")

# Product names (a simple list of items in each category)
product_names <- c("Milk", "Bread", "Apple", "Chicken Breast", "Soda", "Chips", "Frozen Pizza", "Detergent")

# Generate a date range for observation dates
date_range <- seq(as.Date("2024-02-28"), as.Date("2024-11-01"), by = "day")

# Create a simulated dataset by randomly assigning values to each variable
hammer_data <- tibble(
  product_id = 1:1000, # Unique ID for each product
  product_name = sample(product_names, size = 1000, replace = TRUE),
  category = sample(product_categories, size = 1000, replace = TRUE),
  vendor = sample(vendors, size = 1000, replace = TRUE),
  current_price = round(runif(1000, min = 1, max = 20), 2), # Random price between $1 and $20
  # Ensure old_price is within 1-20 by constraining it with pmin and pmax
  old_price = round(pmin(pmax(current_price * runif(1000, min = 0.9, max = 1.1), 1), 20), 2),
  nowtime = sample(date_range, size = 1000, replace = TRUE) # Random observation dates within the date range
)

#### Save data ####
write_csv(hammer_data, "data/00-simulated_data/project_hammer_simulated_data.csv")