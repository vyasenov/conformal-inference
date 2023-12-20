# install and load packages
library(devtools)
install_github(repo="ryantibs/conformal", subdir="conformalInference")

library(conformalInference)
library(glmnet)
library(tidyverse)

rm(list=ls())

# load data
data <- read_csv(file='/Users/vyasenov/Library/CloudStorage/OneDrive-Adobe/blog/titanic_dataset.csv')

# clean data
colnames(data) <- tolower(colnames(data))

data <- data %>%
  dplyr::mutate(age = replace(age, is.na(age), 99),
                male = ifelse(sex == 'male', 1, 0),
                cabin = substr(cabin, 1, 1),
                cabin = replace(cabin, is.na(cabin), 'Z')) %>%
  dplyr::select(-c(passengerid, name, ticket, sex))

# one-hot encode string vars
data <- data %>%
  mutate(embarkedC = as.integer(embarked == 'C'),
         embarkedQ = as.integer(embarked == 'Q'),
         embarkedS = as.integer(embarked == 'S'),
         cabinA = as.integer(cabin == 'A'),
         cabinB = as.integer(cabin == 'B'),
         cabinC = as.integer(cabin == 'C'),
         cabinD = as.integer(cabin == 'D'),
         cabinE = as.integer(cabin == 'E'),
         cabinF = as.integer(cabin == 'F'),
  ) %>%
  dplyr::select(-c(cabin,embarked))

data <- na.omit(data)
dim(data)
