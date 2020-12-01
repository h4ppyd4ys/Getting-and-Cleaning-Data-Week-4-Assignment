##Create a temporary file to store the file to be downloaded:
temp <- tempfile()
##Download the file from the url:
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

## load library packages
library(data.table)
library(dplyr)

##read test files
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

##read train files
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

##read features.txt
features <- read.table("features.txt")

# read activity labels
activity_labels <- read.table("activity_labels.txt")


# 1. Merges the training and the test sets to create one data set.
X_Data <- bind_rows(X_train, X_test)
y_Data <- bind_rows(y_train, y_test)
subject_data <- bind_rows(subject_train, subject_test)

# 2. Extracts only the rows which contain mean and standard deviation for each measurement.
selected_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_Data <- X_Data[,selected_var[,1]]

# 3. Uses descriptive activity names to the data set. maps the acvitity labels to the activities in y_Data
colnames(y_Data) <- "activity"
y_Data$activitylabel <- factor(y_Data$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_Data[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_Data) <- features[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)