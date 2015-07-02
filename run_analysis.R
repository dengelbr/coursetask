#!/usr/bin/env Rscript

library(dplyr)

# this script has to be started from the data root

# function merge_train_and_test_data reads all data and descriptive files
# and returns one huge data.frame with the merged data
merge_train_and_test_data <- function() {
    
    # read activity names
    activity_names<-read.table("UCI HAR Dataset/activity_labels.txt")
    names(activity_names)<-c("Id","Name")
    
    # read feature descriptions
    features_df<-read.table("UCI HAR Dataset/features.txt")
    features<-as.vector(features_df$V2)
    
    # read test X data as data.frame and set features as labels
    test_data<-read.table("UCI HAR Dataset/test/X_test.txt")
    names(test_data)<-features;
    
    # read test subject data and set label
    test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
    names(test_subject) <- "subject"
    
    # read test activities and map id to name
    test_activity<-cbind(read.table("UCI HAR Dataset/test/y_test.txt"),NA)
    names(test_activity) <- c("activityid","activity")
    test_activity$activity<-activity_names$Name[test_activity$activityid]
    
    # create one data.frame for test data
    test_data<-cbind(test_subject,test_activity,test_data)
    
    # read train X data as data.frame and set features as labels
    train_data<-read.table("UCI HAR Dataset/train/X_train.txt")
    names(train_data)<-features;
    
    # read train subject data and set label
    train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
    names(train_subject) <- "subject"
    
    # read train activities and map id to name
    train_activity<-cbind(read.table("UCI HAR Dataset/train/y_train.txt"),NA)
    names(train_activity) <- c("activityid","activity")
    train_activity$activity<-activity_names$Name[train_activity$activityid]
    
    # create one data.frame for train data
    train_data<-cbind(train_subject,train_activity,train_data)
    
    # create a common data.frame for test and train data and return it
    return(rbind(test_data,train_data))
}

# filter only subject, activity name, mean and deviation and return data frame
get_mean_std <- function(df) {
    return(select(df[!duplicated(names(df))],
        matches("subject|^activity$|-mean|-std")))
}

get_average_mean_std <- function(df) {
    ams<-aggregate(mean_dev[,3:ncol(df)],list(df$subject,df$activity),mean)
    names(ams)[1]<-"subject";
    names(ams)[2]<-"activity";
    return(ams)
}    

#####
# start of main script
#####

# get merged data
data<-merge_train_and_test_data()

# get mean and deviation
mean_dev<-get_mean_std(data)

# get averages of mean and deviation
avg_mean_std<-get_average_mean_std(mean_dev)

# write file
write.table(avg_mean_std,"tidydata.txt",row.name=FALSE)
