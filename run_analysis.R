# Loading required packages
library(dplyr)
library(tidyr)

######################################
## THIS PART OF THE SCRIPT CONCERNS ##
## GETTING AND LOADING THE DATA     ##
######################################

# Download file if not present and unzip it
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "dataset.zip"
file_folder <- "UCI HAR Dataset"
if (!file.exists(file_folder)) {
  if (!file.exists(file_name)) { download.file(file_url,file_name) }
  unzip(file_name)
  }

# Define function for reading lines from text file
read.file <- function(filename) {
 conn <- file(filename,open="r")
 myfile <- readLines(conn)
 close(conn)
 return(myfile)
}

# Load activity labels
activity <- read.file("UCI HAR Dataset/activity_labels.txt")
activity <- matrix(unlist(strsplit(activity," ")),6,2,byrow=T)

# Load activity data
act_train <- read.file("UCI HAR Dataset/train/y_train.txt")
act_test <- read.file("UCI HAR Dataset/test/y_test.txt")

# Load feature names
features <- read.file("UCI HAR Dataset/features.txt")
features <- sapply(strsplit(features," "),function(x) x[2])

# Load train and set subject labels
subj_train <- as.numeric(read.file("UCI HAR Dataset/train/subject_train.txt"))
subj_test <- as.numeric(read.file("UCI HAR Dataset/test//subject_test.txt"))

# Load train and test data
x_train <- read.fwf("UCI HAR Dataset/train/X_train.txt",widths=rep(16,561),header=F)
x_test <- read.fwf("UCI HAR Dataset/test/X_test.txt",widths=rep(16,561),header=F)


######################################
## THIS PART OF THE SCRIPT CONCERNS ##
## CLEANING THE DATA                ##
######################################

# Merge the training and the test sets to create one data set
x_all <- rbind(x_train,x_test)

# Appropriately labels the data set with descriptive variable names
names(x_all) <- features

# Extract only the measurements on the mean and standard deviation for each measurement 
x_all <- x_all[,grepl("mean\\(\\)|std\\(\\)",features)]

# Use descriptive activity names to name the activities in the data set
act_all <- c(act_train,act_test)
act_all <- activity[match(act_all,activity[,1]),2]

# Merge all data
subj_all <- c(subj_train,subj_test)
data_all <- cbind(subj_all,act_all,x_all)
names(data_all)[1:2] <- c("subject","activity")

# Create a second, independent tidy data set with the average of each variable for each activity
# and each subject
dataset <- as_tibble(data_all)
datasum <- dataset %>% group_by(subject,activity) %>% summarise_all(mean)

# Write output
write.table()