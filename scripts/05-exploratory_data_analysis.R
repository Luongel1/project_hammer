#### Preamble ####
# Purpose: Exploratory data analysis on cleaned Project Hammer data
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
#   - The cleaned dataset `cleaned_price_changes.csv` must be available


#### Workspace setup ####
library(tidyverse)

#### Read data ####
# Load the cleaned dataset
analysis_data <- read_csv("C:/Users/eliza/Downloads/hammer-3-compressed/cleaned_price_changes.csv")

# General overview of the dataset
glimpse(analysis_data)
summary(analysis_data)


#### Summary Statistics ####
# Summary of numeric columns
analysis_data %>%
  select_if(is.numeric) %>%
  summary()

# Count unique values in categorical columns
analysis_data %>%
  select_if(is.character) %>%
  summarise_all(~ n_distinct(.))


#### Missing Values Analysis ####
# Check for missing values in each column
analysis_data %>%
  summarise_all(~ sum(is.na(.)))


#### Univariate Analysis ####
# Distribution of current price
ggplot(analysis_data, aes(x = price_current)) +
  geom_histogram(bins = 20, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Current Price", x = "Current Price", y = "Count")

# Distribution of old price
ggplot(analysis_data, aes(x = price_old)) +
  geom_histogram(bins = 20, fill = "lightgreen", color = "black") +
  labs(title = "Distribution of Old Price", x = "Old Price", y = "Count")

# Distribution of price difference
ggplot(analysis_data, aes(x = price_difference)) +
  geom_histogram(bins = 30, fill = "coral", color = "black") +
  labs(title = "Distribution of Price Difference", x = "Price Difference", y = "Count")


#### Bivariate Analysis ####
# Relationship between current price and old price
ggplot(analysis_data, aes(x = price_old, y = price_current)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Current Price vs Old Price", x = "Old Price", y = "Current Price")

# Distribution of price difference by vendor
ggplot(analysis_data, aes(x = vendor_name, y = price_difference)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Price Difference by Vendor", x = "Vendor", y = "Price Difference") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Distribution of current price by vendor
ggplot(analysis_data, aes(x = vendor_name, y = price_current)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Current Price by Vendor", x = "Vendor", y = "Current Price") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#### Summary by Product ####
# Average current price per product
analysis_data %>%
  group_by(product) %>%
  summarise(avg_price_current = mean(price_current, na.rm = TRUE)) %>%
  arrange(desc(avg_price_current)) %>%
  head(10) %>%
  ggplot(aes(x = reorder(product, avg_price_current), y = avg_price_current)) +
  geom_col(fill = "purple") +
  labs(title = "Top 10 Products by Average Current Price", x = "Product", y = "Average Current Price") +
  coord_flip()


#### Trends Analysis ####
# Average price difference by vendor
analysis_data %>%
  group_by(vendor_name) %>%
  summarise(avg_price_difference = mean(price_difference, na.rm = TRUE)) %>%
  arrange(desc(avg_price_difference)) %>%
  ggplot(aes(x = reorder(vendor_name, avg_price_difference), y = avg_price_difference)) +
  geom_col(fill = "orange") +
  labs(title = "Average Price Difference by Vendor", x = "Vendor", y = "Average Price Difference") +
  coord_flip()
