# Loading required packages
library(dplyr)
library(tidyr)

######################################
## THIS PART OF THE SCRIPT CONCERNS ##
## DEFINING FUNCTIONS               ##
######################################

# Reading lines from text file
read.file <- function(filename) {
  conn <- file(filename,open="r")
  myfile <- readLines(conn)
  close(conn)
  return(myfile)
}

# Writing lines to text file
write.file <- function(data,filename) {
  file.create(filename)
  conn <- file(filename,open="w")
  writeLines(data,conn)
  close(conn)
}

# Merging Inertial Signals
mergeLines <- function(files,outputFile) {
  merged <- unlist(sapply(files,read.file))
  write.file(merged,outputFile)
  rm("merged")
}

merge.datasets <- function(folder,sets=c("train","test"),outDir="output") {
  if (!dir.exists(outDir)) { dir.create(outDir) }
  dataDirs <- file.path(folder,sets)
  fileNamesShort <- list.files(dataDirs,recursive=T)
  fileNamesFull <- list.files(dataDirs,recursive=T,full.names=T)
  pattern <- paste(sets,collapse="|")
  filePatterns <- unique(gsub(pattern,"",fileNamesShort))
  filenamesOut1 <- gsub("_\\..*","",filePatterns)
  filenamesOut2 <- sapply(strsplit(filePatterns,"\\."), function(x) x[length(x)])
  dir.create(file.path(outDir,unique(list.dirs(dataDirs,recursive=F,full.names=F))))
  outputNames <- file.path(outDir,paste(filenamesOut1,filenamesOut2,sep="."))
  filePairs <- lapply(sets,function(mySet) { list.files(file.path(folder,mySet),recursive=T,full.names=T) } )
  for (i in seq(along.with=outputNames)) { 
    filePair <- c(filePairs[[1]][i],filePairs[[2]][i])
    mergeLines(filePair,outputNames[i])
  }
}

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
  file.remove(file_name)
}

# Merge data from Inertial Signals
merge.datasets("UCI HAR Dataset/",c("train","test"))

# Load activity labels
activity <- read.file("UCI HAR Dataset/activity_labels.txt")
activity <- matrix(unlist(strsplit(activity," ")),6,2,byrow=T)

# Load activity data
act_all <- read.file("output/y.txt")

# Load feature names
features <- read.file("UCI HAR Dataset/features.txt")
features <- sapply(strsplit(features," "),function(x) x[2])

# Load subject labels
subj_all <- as.numeric(read.file("output/subject.txt"))

# Load train and test data
x_merge <- read.fwf("output/X.txt",widths=rep(16,561),header=F)


######################################
## THIS PART OF THE SCRIPT CONCERNS ##
## CLEANING THE DATA                ##
######################################

# Appropriately labels the data set with descriptive variable names
names(x_merge) <- features

# Extract only the measurements on the mean and standard deviation for each measurement 
x_all <- x_merge[,grepl("mean\\(\\)|std\\(\\)",features)]

# Use descriptive activity names to name the activities in the data set
act_all <- activity[match(act_all,activity[,1]),2]

# Merge all data
data_all <- cbind(subj_all,act_all,x_all)
names(data_all)[1:2] <- c("subject","activity")

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
dataset <- as_tibble(data_all)
datasum <- dataset %>% group_by(subject,activity) %>% summarise_all(mean)

# Write summarised output
if (!dir.exists("output")) { dir.create("output") }
write.table(datasum,"output/summarised_data.txt",row.name=FALSE)

