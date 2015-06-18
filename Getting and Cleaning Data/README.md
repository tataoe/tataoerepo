Human Activity Recognition Using Smartphones Dataset
============================================================

## The Following steps are considered to create the final tidy data set.

1. Pick all meta data including:
	- activity_labels = data read from "activity_labels.txt"
	- features = data read from "features.txt"
	- test_labels = data read from "test/subject_test.txt"
	- train_labels = data read from "test/subject_test.txt"
	- test_subject = data read from "test/subject_test.txt"
	- train_subject = data read from "train/subject_train.txt"
	
2. Read the test and train data	
	- test = data read from "test/X_test.txt"
	- train = data read from "train/X_train.txt"
	
3. Add the column names to test and train data using features
4. Cbind the subject and activity number with test and train data
5. Update the recently added columns with the correct colnames
6. Merge the training and the test sets to create one data set called all_data using rbind
7. Extract only the measurements on the mean and std for each measurement using the grep() for mean and and std
8. Combine both the values to create sorted columns for the entire data set
9. Create new data set called select_data with the selected column
10. Append the subject and activity columns to the new data set 
11. Use descriptive activity names to name the activities in the data set using for loop for picking 1:6 values and renaming them to activity names
12. Make sure the correct columns are included in  select_data
13. Create a new data set agg using aggregate() by subject and activity to find the mean for all the columns
14. Save the tidy data created agg in a txt format using write.table()
15. For creating codebook do the following
	- extract the columns to be selected using grep()
	- using gsub() write description to the column variables
	- using paste() combine the column name and the description
16. Store theses values in .md format in file codebook.md