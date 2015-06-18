
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

##Readng the test and train data
test <- read.table("./test/X_test.txt",header=F)
train <- read.table("./train/X_train.txt",header=F)

dim(test)
dim(train)

##Adding column names to test and train data
names(test) <- features[,2]
names(train) <- features[,2]

colnames(test_dat)
colnames(test_dat)[562:563] <- c("subject","activity")
colnames(train_dat)[562:563] <- c("subject","activity")


##Cbind the subject with the test data
test_dat <- cbind(test,test_subject,test_labels)
train_dat <- cbind(train,train_subject,train_labels)

dim(test_dat)
dim(train_dat)



#1. Merges the training and the test sets to create one data set.
all_data <- rbind(test_dat,train_dat)
dim(all_data)
colnames(all_data)
colnames(all_data)[562:563] <- c("subject","activity")


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
with the average of each variable for each activity and each subject.

library(dplyr)
library(tidyr)

dim(select_data)
#Convert the df into dplyr df format for better readability
tidy_dat <- tbl_df(select_data)

#Find column means using group by on activity

agg <- aggregate(select_data, by= list (select_data$activity,select_data$subject),FUN=mean)
colnames(agg)
colnames(agg)[1:2] <- c("activity", "subject")
agg <- agg[,-(69:70)]

#Writing data
write.table(agg, file="tidydata.txt",row.name=F,col.names=T, sep="\t")
by_activity <- tidy_dat %>% group_by(activity)
act_mean <- by_activity %>% summarise_each(funs(mean))


#Find column means using group by on subject
by_subject <- tidy_dat %>% group_by(subject)
sub_mean <- by_subject %>% summarise_each(funs(mean))
