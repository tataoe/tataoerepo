
setwd("C:/Users/GC/Desktop/DataScience/Coursera/JHU/2.Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

##Picking all meta data
#Label
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=F)
features <- read.table("features.txt",stringsAsFactors=F)

test_labels <- read.table("./test/y_test.txt")
train_labels <- read.table("./train/y_train.txt")
nrow(test_labels)
nrow(train_labels)

#Subject
test_subject <- read.table("./test/subject_test.txt")
train_subject <- read.table("./train/subject_train.txt")
nrow(test_subject)
nrow(train_subject)

##Read the test and train data
test <- read.table("./test/X_test.txt",header=F)
train <- read.table("./train/X_train.txt",header=F)

dim(test)
dim(train)

##Adding column names to test and train data
names(test) <- features[,2]
names(train) <- features[,2]


##Cbind the subject and activity number with test and train data
test_dat <- cbind(test,test_subject,test_labels)
train_dat <- cbind(train,train_subject,train_labels)

dim(test_dat)
dim(train_dat)

#Update the recently added columns with the correct colnames
colnames(test_dat)
colnames(test_dat)[562:563] <- c("subject","activity")
colnames(train_dat)[562:563] <- c("subject","activity")

#1. Merges the training and the test sets to create one data set.
all_data <- rbind(test_dat,train_dat)
dim(all_data)
colnames(all_data)

#2.Extracts only the measurements on the mean and std for each measurement.
str(features)

#Pick mean and std columns
fea1 <- grep("-mean()", features[,2], fixed=T)
fea2 <- grep("-std()", features[,2], fixed=T)

#Combine the columns
cols <- c(fea1, fea2)
cols <- sort(cols)

# Pick the selected columns
select_data <- all_data[,cols]
#Append the subject and activity coulmns
select_data <- cbind(select_data, all_data[,562:563])
str(select_data)

#3.Uses descriptive activity names to name the activities in the data set
for(i in 1:6){
        select_data[select_data$activity== i,"activity"] <- activity_labels[,2][[i]]
}
unique(select_data[,"activity"])

#4.Appropriately labels the data set with descriptive variable names. 
#Column names are added to test and train data initailly
colnames(select_data)

#5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

#Create a new data set agg using aggregate() by subject and activity to find the mean for all the columns
agg <- aggregate(select_data, by= list (select_data$activity,select_data$subject),FUN=mean)
colnames(agg)
colnames(agg)[1:2] <- c("activity", "subject")
agg <- agg[,-(69:70)]

##Writing data into txt file
write.table(agg, file="tidydata.txt",row.name=F,col.names=T, sep="\t")

## Adding codebook.md
#Pick all columnames to crete codebook
col_mean <- features[grep("-mean()", features[,2], fixed=T),2]
col_std <- features[grep("-std()", features[,2], fixed=T),2]
cols <- c(col_mean, col_std)

#Adding description to the column names
description <- cols

description <- gsub ("-mean()", " Mean value ",description)
description <- gsub ("-std()", " STD DeviaTion ",description)

description <- gsub ("t", "Time ",description)
description <- gsub ("f", "FFT ",description)

description <- gsub ("BodyAcc", " Body Acc ",description)
description <- gsub ("GravityAcc", " Gravity Acc ",description)
description <- gsub ("BodyAccJerk", " Body Acc Jerk",description)
description <- gsub ("BodyGyro", " Body Gyro",description)
description <- gsub ("BodyGyroJerk", " Body Gyro Jerk",description)
description <- gsub ("BodyAccMag", " Body Acc Magnitude",description)
description <- gsub ("GravityAccMag", " Gravity Acc Magnitude",description)
description <- gsub ("BodyAccJerkMag", " Body Acc Jerk Magnitude",description)
description <- gsub ("BodyGyroMag", " Body Gyro Magnitude",description)
description <- gsub ("BodyGyroJerkMag", " Body Gyro Jerk Magnitude",description)

code <- paste(cols, description, sep = "  --  ")
write.table(code, "codebook.md", row.name=F)

