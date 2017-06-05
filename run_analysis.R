library(dplyr)
library(tidyr)
library(stringr)

#read the activity_labels, and store them in a table tblActivity(id, activity)
tblActivity<-read.table(".\\UCI HAR Dataset\\activity_labels.txt",
                        stringsAsFactors = FALSE,header = FALSE,
                        col.names = c("id","activity"),
                        fill = FALSE)
#drop "_" in the table and convert upper case to lower case
tblActivity$activity<-tolower(sub("_","",tblActivity$activity))

#set the feature vector, which will be used as the column names below
vecFeature<-read.table(".\\UCI HAR Dataset\\features.txt",
                       stringsAsFactors = FALSE,header = FALSE,
                       col.names = c("id","feature"),fill=FALSE)$feature
#replace any characters other than a-zA-Z0-9 with "."
vecFeature <- gsub("[^a-zA-Z0-9]",".",vecFeature)

#set the vecTrainActivityId vector to add the trainactivityid column later
vecTrainActivityId <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt", 
                                 header = FALSE, 
                                 col.names = c("activityid"),
                                 fill=FALSE)$activityid

#set the vecTrainSub vector to add the trainsubject column later
vecTrainSub <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", 
                          header = FALSE, col.names = c("subject"),
                          fill=FALSE)$subject

#read the 'train/X_train.txt': Training set, and store them in a table 
#tblTrainSet, where the column names are the values in vecFeature
tblTrainSet <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", 
                          header = FALSE, col.names = vecFeature)


#select only the columns which are the mean() and std()
tblTrainSet <- select(tblTrainSet,contains(".mean."),contains(".std."))

#add subject and activityid column to tblTrainSet
#then the tblTrainSet becomes tblTrainSet(subject, activityid, [all the features using mean() or std()])
tblTrainSet <- cbind(subject=vecTrainSub, activityid=vecTrainActivityId,tblTrainSet)

#set the vecTestActivityId vector to add the testactivityid column later
vecTestActivityId <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt", 
                                header = FALSE, 
                                col.names = c("activityid"),
                                fill=FALSE)$activityid

#set the vecTestSub vector to add the testsubject column later
vecTestSub <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", 
                         header = FALSE, col.names = c("subject"),
                         fill=FALSE)$subject

#read the 'test/X_test.txt': Test set, and store them in a table 
#tblTestSet, where the column names are the values in vecFeature
tblTestSet <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", 
                         header = FALSE, col.names = vecFeature)

#select only the columns which are the mean() and std()
tblTestSet <- select(tblTestSet,contains(".mean."),contains(".std."))

#add subjectid and activityid column to tblTestSet
#then the tblTestSet becomes tblTestSet(subject, activityid, [all the features using mean() or std()])
tblTestSet <- cbind(subject=vecTestSub,activityid=vecTestActivityId,tblTestSet)

#merge tblTestSet and tblTrainSet into one dataset
HARData <- bind_rows(tblTrainSet,tblTestSet)

#remove variables which will not be used any more
remove("tblTrainSet","tblTestSet","vecFeature","vecTestActivityId","vecTestSub",
       "vecTrainActivityId","vecTrainSub")

#create a dataset named as HARData_mean with the average of each variable for each activity and 
#each subject
#first group HARData by subject and activityid, then summarise each column using mean()
HARData_mean<-HARData%>%group_by(subject,activityid)%>%summarise_each(funs(mean))

#substitute activityid column with activity name using inner join
HARData_mean<-HARData_mean%>%inner_join(tblActivity,by=c("activityid"="id"))%>%
        select(subject,activity,3:(length(names(HARData_mean))))

#remove variables which will not be used any more
remove("tblActivity","HARData")

#make HARData_mean tidy data HARData_mean(subject, activity, signal, domain, mean, std)
#first gather the feature columns into one column called measure
HARData_mean<-gather(HARData_mean,measure,value,-subject,-activity)
#get rid of .. and ... in the measure
HARData_mean$measure<-gsub("\\.\\.\\.","\\.",HARData_mean$measure)
HARData_mean$measure<-gsub("\\.\\.","\\.",HARData_mean$measure)
#separate the column measure to three columns (singal, method, axis)
HARData_mean<-separate(HARData_mean,measure,c("signal","method","axis"),sep="\\.")
#parse the first letter ("t"/"f") in the singal, used as the domain ("time" or "freq")
#and combin the rest of signal and axis together to form the column signal
#spread the method column into mean and std
HARData_mean<-HARData_mean%>%mutate(domain=substr(signal,1,1),
                                    signal=paste0(substr(signal,2,nchar(signal)),axis))%>%
        select(subject,activity,signal,domain,method,value)%>%
        spread(method,value) 
HARData_mean$domain<-sub("t","time",HARData_mean$domain)
HARData_mean$domain<-sub("f","freq",HARData_mean$domain)
#remove the typo in the feature list
#NOT that there are "fBodyBodyAccJerkMag-mean()","fBodyBodyAccJerkMag-std()",
#"fBodyBodyGyroMag-mean()", "fBodyBodyGyroMag-std()", "fBodyBodyGyroJerkMag-mean()" 
#"fBodyBodyGyroJerkMag-std()" in the feature.txt file, which should be 
#"fBodyAccJerkMag-mean()","fBodyAccJerkMag-std()", "fBodyGyroMag-mean()",
# "fBodyGyroMag-std()", "fBodyGyroJerkMag-mean()", "fBodyGyroJerkMag-std()"
HARData_mean$signal<-sub("BodyBody","Body",HARData_mean$signal)
# convert signal values to lower case
HARData_mean$signal<-tolower(HARData_mean$signal)

#write to .csv files
write.csv(HARData_mean,"HARDataMean.csv",row.names = FALSE)