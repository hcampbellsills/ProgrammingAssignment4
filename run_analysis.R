setwd("Documents/DataScience/3.Data/assignment/")
library(dplyr)
library(tidyr)

# Download file if not present
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "dataset.zip"
if (!file.exists(file)) { download.file(file_url,file_name) }

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

# Merge training and test datasets
x_all <- rbind(x_train,x_test)
names(x_all) <- features
x_all <- x_all[,grepl("mean\\(\\)|std\\(\\)",features)]

# Merge and label training and test activities
act_all <- c(act_train,act_test)
act_all <- activity[match(act_all,activity[,1]),2]

# Merge training and test subjects
subj_all <- c(subj_train,subj_test)

# Merge all data
data_all <- cbind(subj_all,act_all,x_all)
names(data_all)[1:2] <- c("subject","activity")

dataset <- as_tibble(data_all)
dataset <- group_by(dataset,subject,activity)
datasum <- dataset %>% summarise_all(mean)
