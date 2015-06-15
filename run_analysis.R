#!/usr/bin/env Rscript

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
    names(test_subject) <- "Subject"
    
    # read test activities and map id to name
    test_activity<-cbind(read.table("UCI HAR Dataset/test/y_test.txt"),NA)
    names(test_activity) <- c("ActivityId","ActivityName")
    test_activity$ActivityName<-activity_names$Name[test_activity$ActivityId]
    
    # create one data.frame for test data
    test_data<-cbind(test_subject,test_activity,test_data)
    
    # read train X data as data.frame and set features as labels
    train_data<-read.table("UCI HAR Dataset/train/X_train.txt")
    names(train_data)<-features;
    
    # read train subject data and set label
    train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
    names(train_subject) <- "Subject"
    
    # read train activities and map id to name
    train_activity<-cbind(read.table("UCI HAR Dataset/train/y_train.txt"),NA)
    names(train_activity) <- c("ActivityId","ActivityName")
    train_activity$ActivityName<-activity_names$Name[train_activity$ActivityId]
    
    # create one data.frame for train data
    train_data<-cbind(train_subject,train_activity,train_data)
    
    # create a common data.frame for test and train data and return it
    data<-rbind(test_data,train_data)
    data
}

# start of script

# receive data
data<-merge_train_and_test_data()

# get labels of data
v<-names(data)

# get all indexes for mean
mean<-grep("-mean",v,fixed=TRUE)

# get all indexes for std
std<-grep("-std",v,fixed=TRUE)

# filter data for ActivityName, mean and dev
mean_dev<-data[,c("Subject","ActivityName",v[mean],v[std])]

# create averages for each activity and column

# get all ActivityNames
activities<-sort(unique(mean_dev$ActivityName))

# get all subjects
subjects<-sort(unique(mean_dev$Subject))

# generate means for all subject / activity tuples
for (activity in activities) {
    for (subject in subjects) {
       sa_subset<-subset(mean_dev,Subject==subject & ActivityName==activity)
       x<-lapply(sa_subset[,c(v[mean],v[std])],mean,na.rm=TRUE)
       if (exists("new_data")) {
           new_data<-rbind(new_data,c(Subject=subject,ActivityName=activity,x))
       }
       else {
           new_data<-c(Subject=subject,ActivityName=activity,x)
       }
    }
}       

# write file
write.table(new_data,"data_file.txt",row.name=FALSE)
