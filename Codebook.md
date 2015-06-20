# Code Book

This document describes the functionality of the R script ***run_analysis.R***

**Important:** This script has to be run in the data root of the be read data. (This means that the directory, containing *run_analysis.R* should include the subdirectory *UCI HAR Dataset*) 

## Functionality##
The script has 3 functions and the main routine.

### Function *merge_train_and_test_data*:
For the two types of data (test and train) does the following:

* reads the actual measurements into a data.frame, taken from test/X_test.txt, resp. from train/X_train.txt
* sets the labels for the data.frame with the information from UCI HAR Dataset/features.txt
* reads the associated subjects from test/subject.txt, resp. from train/subject.txt into a data.frame and labels the column 'subject'
* reads the associated activities (taken from \*/y_\*.txt) into a data.frame with two columns: column one holds the read information, column two all NAs and labels the columns activityid and activity
* sets activity with the correponding activity name for activityid taken from UCI HAR Dataset/activity_labels.txt

After creating the two data.frames, these data.frames are merged and the merged data.frame is returned

### Function *get_mean_std*:
Is passed the merged data.frame as parameter, filters out all columns with labels containing the string '-std' or '-mean'and returns a data.frame containing a subject column, an activity column and all std and mean columns.

### Function *get_average_mean_std*:
Is passed the data.frame from function get_mean_std() and creates the averages of all mean and std columns, grouped by activity / subject .

### Main
* calls get merge_train_and_test_data() with no parameter
* calls get_mean_std() with result from previous call
* calls get_average_mean_std() with result previous call
* writes result from call to get_average_mean_std() to the file tidydata.txt in the current directory with write.file(..., row.name=FALSE)

## Resulting Output File tidydata.txt
* header line containing all labels: "subject", "activity", "tBodyAcc-mean()-X", ....
* one line for every values

## Meaning of Columns
* activity:	activity name
* subject:	subject id
* means:		like tBodyAcc-mean()-X, etc.
* deviations: like tBodyAcc-std()-X, etc.

All values are blank separated.

**Example:**

"subject" "activity" "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" ...

1 LAYING 0.22159824394 -0.0405139534294 ...

2 LAYING 0.281373403958333 -0.0181587397583333 ...

...

1 SITTING 0.261237565425532 -0.00130828765170213 ...

...

## Further Information

For more information see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
