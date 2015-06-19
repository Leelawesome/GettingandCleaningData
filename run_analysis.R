## Coursera Getting and Cleaning Data Course Project

# Raw data was downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


# Clean the workspace
rm(list=ls())

#Load plyr library
library(plyr)


#################################################################
# 1. Merges the training and the test sets to create one data set
#################################################################

#Read the data from the individual files
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# creates a data set using x_train and x_test
x_data <- rbind(x_train, x_test)

# creates a data set using y_train and y_test
y_data <- rbind(y_train, y_test)

# creates a data set using subject_train and subject_test
subject_data <- rbind(subject_train, subject_test)


###########################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
###########################################################################################

# extract the columns with mean() and std()
extract_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the extracted columns
x_data <- x_data[, extract_features]

# column names correction
names(x_data) <- features[extract_features, 2]


###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

#correct activity names
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"


######################################################################
# 4. Appropriately labels the data set with descriptive variable names
######################################################################

# column names correction
names(subject_data) <- "subject"

# bind data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

#####################################################################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#####################################################################################################################

tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)