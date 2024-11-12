#### Preamble ####
# Purpose: Models Project Hammer data to predict current grocery prices using stan_glm with efficient memory handling.
# Author: Elizabeth Luong and Abdullah Motasim
# Date: 14 November 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse`, `rstanarm`, `arrow`, `data.table` packages must be installed and loaded
#   - The cleaned dataset must be available as `cleaned_price_changes.csv`

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(data.table)

#### Read data ####
# Load the cleaned data with data.table for efficiency
analysis_data <- fread("C:/Users/eliza/Downloads/hammer-3-compressed/cleaned_price_changes.csv")

# Split data into training and testing sets
set.seed(853)
train_indices <- sample(seq_len(nrow(analysis_data)), size = 0.8 * nrow(analysis_data))
analysis_data_train <- analysis_data[train_indices]
analysis_data_test <- analysis_data[-train_indices]


### Model data ####
# Define a Bayesian regression model to predict `price_current`
model <- stan_glm(
  formula = price_current ~ price_old + as.factor(vendor_name) + price_difference,
  data = analysis_data_train,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  model,
  file = "models/project_hammer_price_model.rds"
)

#### Model evaluation using data.table and chunking ####

# Define chunk size
chunk_size <- 50000  # Adjust based on available memory
num_chunks <- ceiling(nrow(analysis_data_test) / chunk_size)

# Initialize a vector to store predictions
predictions <- vector("numeric", nrow(analysis_data_test))

# Predict in chunks to manage memory usage
for (i in 1:num_chunks) {
  start <- ((i - 1) * chunk_size) + 1
  end <- min(i * chunk_size, nrow(analysis_data_test))
  
  # Subset chunk
  chunk_data <- analysis_data_test[start:end]
  
  # Predict and store in predictions vector
  predictions[start:end] <- predict(model, newdata = chunk_data)
}

# Calculate Mean Absolute Error (MAE) and Root Mean Squared Error (RMSE)
mae <- mean(abs(predictions - analysis_data_test$price_current))
rmse <- sqrt(mean((predictions - analysis_data_test$price_current)^2))

# Print evaluation metrics
cat("Model Evaluation Metrics:\n")
cat("Mean Absolute Error (MAE):", round(mae, 2), "\n")
cat("Root Mean Squared Error (RMSE):", round(rmse, 2), "\n")
