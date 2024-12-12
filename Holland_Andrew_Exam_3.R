##################################################
# ECON 418-518 Exam 3
# Andrew Holland
# The University of Arizona
# aholland2@arizona.edu 
# 09 December 2024
###################################################


#####################
# Preliminaries
#####################

# Clear environment, console, and plot pane
rm(list = ls())
cat("\014")
graphics.off()

# Turn off scientific notation
options(scipen = 999)

# Load packages
pacman::p_load(data.table, margins, sandwich, lmtest, tidyr, stringr, dplyr, 
               car, knitr, tidyverse, glmnet, caret)

# Load the Data-set into R
dt <- read.csv(
  "ECON_418_518_Exam_3_Data.csv",
               header = TRUE, sep = "," )

# Ensure the data is in the right format, small correction for possible conversion issues
dt <- data.table(dt)

###################
# Section 3
###################
#####
# (ii)
#####
# Create two columns, the first being a time period indicator for "Nov"
# and the second as an indicator for if the state is NJ
# We also want to find the mean total employment in each state for each time period

# First, we create the column for Nov to make it a discrete binary variable
dt[, time_period := ifelse(time_period == "Nov", 1, 0)]

# Now we create the state column for discrete binary variable for NJ
# I don't fully understand why this is here, as the column is already organized like this
dt[, state := ifelse(state == 1, 1, 0)]

# Pull the mean total employment for each state in Feb and Nov
mean_employment <- dt[, .(mean_total_emp = mean(total_emp, na.rm = TRUE)),
                      by = .(state, time_period)
                 ]

# Print the output
print(mean_employment)

#####
# (iii)
#####
# Want to find the DiD estimate from mean employment.
# Using mean_unemployment, I find the DiD estimate
# I want to do this by finding the average change in the treated and control groups
# Then, I take the difference of those two differences
DiD_val <- (mean_employment[4,3] - mean_employment[2,3]) -
  (mean_employment[3,3] - mean_employment[1,3])

# Show the estimate
DiD_val

# Round for a standard comparison
DiD_val <- round(DiD_val, digits = 2)

#####
# (iv)
#####
# Build the DiD lm() model
DiD_test <- lm(total_emp ~ state + time_period + I(state * time_period),
               data = dt)
summary(DiD_test)

# Quickly check to see if the estimator is the same as the one we found prior
DiD_lmest <- data.table(DiD_test$coefficients)
DiD_lmest <- round(DiD_lmest[4], 2)
if (DiD_lmest == DiD_val) {
  paste0("The value of the DiD estimator is ", DiD_val)
} else { paste0("The value of the DiD estimator is not ", DiD_val)
}

# Pull the variance for each group and period into a data table
var_dt <- dt %>% 
  group_by(state, time_period) %>%
  summarize(var_outcome = var(total_emp), n = n())
print(data.table(var_dt))

# Also pull the SE for the model output, β3 specifically (The ATT)
SE_DiD <- summary(DiD_test)$coefficients[,"Std. Error"]
B3_SE <- SE_DiD[4]
B3_SE

# Construct a 95% CI around the ATT (THIS IS A CHECK FOR MANUAL COMPUTATION)
CV95 <- 1.96
CI_B3 <- c(DiD_val - (CV95 * B3_SE), DiD_val + (CV95 * B3_SE))
CI_B3

#####
# (vii)
#####
# Add restaurant fixed effects to the DiD model
DiD_test2 <- lm(total_emp ~ state + time_period + I(state * time_period) +
                  factor(restaurant_id), data = dt)

# Let's check if the DiD estimator changed
DiD_estFE <-round(summary(DiD_test2)$coefficients[4], 2)
if (DiD_lmest == DiD_estFE) {
  paste0("The value of the DiD estimator is ", DiD_estFE)
} else { paste0("The value of the DiD estimator is not ", DiD_estFE)
}

