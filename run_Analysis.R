##Load the libraries
library(dplyr)

#Read in all test and training files
features_txt <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")

subject_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\subject_train.txt")
x_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\x_train.txt")
y_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")

subject_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
x_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\x_test.txt")
y_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")

##Combine Training and Testing data
subject_test_train <- rbind(subject_train, subject_test)
x_test_train <- rbind(x_test, x_train)
y_test_train <- rbind(y_test, y_train)

##Rename the columns in subject data set and activity dataset
colnames(subject_test_train)[1] <- "subject"
colnames(y_test_train)[1] <- "activity"

##Rename the columns in x dataframe
colnames(x_test_train) <- as.matrix(features_txt[2])

##Get from features_txt, the columns that contain mean or std
colContaingMeanOrStd <- features_txt[grep("mean\\(\\)|std\\(\\)", features_txt$V2, perl=TRUE),]
colNumbersToSubset <- colContaingMeanOrStd[,1]

##Select only the columns with mean or std from x_train
mean_std_data <- x_test_train[,colNumbersToSubset]

##Combine all Subject, Activity and Data into 1 dataset
mergedData <- cbind(subject_test_train, y_test_train, mean_std_data)

##Sort by Subject then Activity
mergedData <- mergedData[order(mergedData$subject, mergedData$activity),]

##Use descriptive activity names
mergedData$activityFullName <- ""
mergedData$activityFullName[mergedData$activity == "1"] <- "WALKING"
mergedData$activityFullName[mergedData$activity == "2"] <- "WALKING_UPSTAIRS"
mergedData$activityFullName[mergedData$activity == "3"] <- "WALKING_DOWNSTAIRS"
mergedData$activityFullName[mergedData$activity == "4"] <- "SITTING"
mergedData$activityFullName[mergedData$activity == "5"] <- "STANDING"
mergedData$activityFullName[mergedData$activity == "6"] <- "LAYING"

##Re-order the columns
mergedData <- data.frame(mergedData$subject, mergedData$activityFullName, mergedData[3:68])
colnames(mergedData)[1] <- "subject"
colnames(mergedData)[2] <- "activity"

##Create a 2nd tidy data set with average of each variable for each activity and each subject
by_subj_activity <- group_by(mergedData, subject, activity)
summary <- summarise_each(by_subj_activity, funs(mean))
write.table(summary, file="tidy.txt", row.names=FALSE)