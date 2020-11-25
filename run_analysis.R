## Cleaning global environment and loading dplyr
    rm(list = ls())
    library(dplyr)

## Creating navigation menu
    myDir <- getwd()
    UCI_dir <- paste(myDir, "UCI HAR Dataset", sep = "/")
    test_dir <- paste(UCI_dir, "test", sep = "/")
    train_dir <- paste(UCI_dir, "train", sep = "/")
    
## Downloading and unzipping file if it does not exist
    if (!file.exists("./UCI HAR Dataset") & !file.exists("data.zip")) {
    myURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2
        FUCI%20HAR%20Dataset.zip"
    download.file(myURL, destfile = "data.zip")
    unzip("data.zip")
}

## Reading variables' names and activity labels
    setwd(UCI_dir)
    data_names <- read.table("features.txt")[,2]
    activity_labels <- read.table("activity_labels.txt")

## Reading test data
    setwd(test_dir)
    subject_test <- read.table("subject_test.txt")
    x_test <- read.table("X_test.txt")
        names(x_test) <- data_names
    y_test <- read.table("Y_test.txt")

## Reading trainging data
    setwd(train_dir)
    subject_train <- read.table("subject_train.txt")
    x_train <- read.table("X_train.txt")
        names(x_train) <- data_names
    y_train <- read.table("Y_train.txt")
    setwd(myDir)
    
## Matching labels with test and train data
    y_test_labeled <- sapply(y_test, factor, levels = activity_labels[,1], 
                            labels = activity_labels[,2])
    y_train_labeled <- sapply(y_train, factor, levels = activity_labels[,1], 
                             labels = activity_labels[,2])

## Binding test and train data subject with activities    
    test_subj_act_label <- cbind(subject_test, y_test_labeled)
        names(test_subj_act_label) <- c("Subject", "Activity")
    train_subj_act_label <- cbind(subject_train, y_train_labeled)
        names(train_subj_act_label) <- c("Subject", "Activity")
    
## Merging data
    x_data <- rbind(x_test, x_train)
    y_data <- rbind(test_subj_act_label, train_subj_act_label)
    merged_data <- cbind (y_data, x_data)
    
    mean_sd_data <- select(merged_data, "Subject", "Activity", contains("mean"), 
                           contains("std"))
    
## Renaming columns with new names
    names(mean_sd_data) <- gsub("^t", "Time Domain ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("^f", "Frequency Domain ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Acc", " Accelerometer ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("-mean\\(\\)", "Mean ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("-std\\(\\)", " STD ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("-meanFreq\\(\\)", "Frequency Mean ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("X$", " X", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Y$", " Y", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Z$", " Z", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Mean", " Mean", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Jerk", " Jerk ", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Mag", " Magnitude", names(mean_sd_data))
    names(mean_sd_data) <- gsub("Gyro", " Gyroscope", names(mean_sd_data))
    names(mean_sd_data) <- gsub("BodyBody", "Body", names(mean_sd_data))
    names(mean_sd_data) <- gsub("tBody", "Time Body", names(mean_sd_data))
    names(mean_sd_data) <- gsub("angle", "Angle", names(mean_sd_data))
    names(mean_sd_data) <- gsub("gravity", " Gravity", names(mean_sd_data))
    names(mean_sd_data) <- gsub("  ", " ", names(mean_sd_data))
    names(mean_sd_data) <- gsub(" $", "", names(mean_sd_data))

## Creating second dataset
    average_data <- mean_sd_data %>% group_by(Subject, Activity) %>% 
        summarise_all(.funs = mean)
    
## Data output
    write.table(average_data, "average_data.txt", row.names = FALSE)

## Cleaning global environment
    rm(list = ls())
    