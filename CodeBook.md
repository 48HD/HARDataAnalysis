---
title: "CodeBook"
author: "Jessica"
date: "June 2, 2017"
output: html_document
---

---
## Introduction
### Data Source
The data source for the dataset in the fold is the Human Activity Recognition Using Smartphones Dataset (Version 1.0) by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto, Smartlab - Non Linear Complex Systems Laboratory. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The detailed introduction on how the experiments were designed, and how the data was collected could is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the original data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Signals
The signals selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).


Here is the list of the signals:  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions, the first letter indicates in which domain ("t"=time or "f"=frequency) this signal is available.

* tBodyAcc-XYZ              
* fBodyAcc-XYZ
* tGravityAcc-XYZ         
* tBodyAccJerk-XYZ
* fBodyAccJerk-XYZ
* tBodyGyro-XYZ
* fBodyGyro-XYZ
* tBodyGyroJerk-XYZ      
* tBodyAccMag  
* fBodyAccMag 
* tGravityAccMag           
* tBodyAccJerkMag
* fBodyAccJerkMag
* tBodyGyroMag           
* fBodyGyroMag
* tBodyGyroJerkMag         
* fBodyGyroJerkMag

The mean and standard deviation of the above signals in each experiment trial are selected in the datasets in this fold.

**NOTE:** All mean and standard deviation values are normalized and bounded within [-1,1].

### Datasets
There is one data set included in the fold.

1.'HARDataMean.txt':  containing the mean values of mean and stand deviation for each singal in the corresponding domain grouped by subjects, activity.

## HARDataMean.txt
###Variables
There are 6 variables in this dataset. 

1. **subject**: labeling the 30 volunteers participating in this experiments. Takes one of the values in the range [1:30]

2. **activity**: indicating the activities taken in that measurement. Takes one of the six values (walking, walkingupstairs, walkingdownstairs, sitting, standing, laying)
               
3. **signal**: indicating which signal is considered. Takes one of the following 20 values, where the ending xyz indicating the axial information (bodyaccjerkmag, bodyaccjerkx, bodyaccjerky, bodyaccjerkz, bodyaccmag, bodyaccx, bodyaccy, bodyaccz, bodygyrojerkmag, bodygyrojerkx, bodygyrojerky, bodygyrojerkz, bodygyromag, bodygyroX, bodygyroY, bodygyroZ, gravityaccmag, gravityaccx, gravityaccy, gravityaccz).

4. **domain**: indicating the signal is in which domain. Takes one of the two values (time, freq). "freq" represents "frequency".

5. **mean**: the average of all the mean values having the correspoding subject, activity, signal and domain.

6. **std**: the average of all the std values having the correspoding subject, activity, signal and domain.

### Unit
**NOTE:** All the numeric values in this data set are normalized and bounded within [-1,1].

## Data Tidying
To tidy the data, several tasks have been down.

1. The six activity values (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) have been updated to (walking, walkingupstairs, walkingdownstairs, sitting, standing, laying) to remove "_" and to be all lower cases.

2. Merg the train and test sets into one data set named as **HARData** and select only the variables using mean() or std().

3. Group **HARData** by subject and activity, then summarise each variables with function mean(), using summarise_each() function. 

4. The original column variables excepet **subject** and **activity** contains all the information of domain(time/freq), signals, and method("mean", "std") and axis. Therefore, four columns are created (**signal**,**domain**,**mean**,**std**).  

        * domain: (time/freq).  
        * signal: merging signal and axis information (bodyaccjerkmag, bodyaccjerkx, bodyaccjerky, bodyaccjerkz, bodyaccmag, bodyaccx, bodyaccy, bodyaccz, bodygyrojerkmag, bodygyrojerkx, bodygyrojerky, bodygyrojerkz, bodygyromag, bodygyroX, bodygyroY, bodygyroZ, gravityaccmag, gravityaccx, gravityaccy, gravityaccz).
        * mean: indicating the average of mean() on the signal in the domain for the subject and activity.
        * std: indicating the average of std() on the signal in the domain for the subject and activity.  
To create these four columns, the original column variables, excepet **subject** and **activity**, are first gathered into one column calls **measure** and the values are stored in **value**, then **measure** is separated into four columns (**domain**, **signal**, **method**, **axis**), then **signal** and **axis** merged into **signal**, **method** is spreaded, and the values in the column **signal** are converted to lower case.

5. Process the typos. **NOTE** that int the "UCI HAR Dataset/feature.txt" file, the features "fBodyBodyAccJerkMag-mean()","fBodyBodyAccJerkMag-std()", "fBodyBodyGyroMag-mean()", "fBodyBodyGyroMag-std()", "fBodyBodyGyroJerkMag-mean()", "fBodyBodyGyroJerkMag-std()" should be "fBodyAccJerkMag-mean()","fBodyAccJerkMag-std()", "fBodyGyroMag-mean()", "fBodyGyroMag-std()", "fBodyGyroJerkMag-mean()", "fBodyGyroJerkMag-std()". This kind of typo has been corrected.

## Data Processing Steps

1. Read the file ".\\UCI HAR Dataset\\activity_labels.txt", and store the content in a table **tblActivity(id, activity)**. Rename the activities as (walking, walkingupstairs, walkingdownstairs, sitting, standing, laying).
2. Read the file ".\\UCI HAR Dataset\\features.txt", and store the variables in the vector called **vecFeature**, then get rid of any characters other than a-zA-Z0-9, replace them with ".".
3. Generate one data set for the train set.  
        1) Read the train set files, training labels ".\\UCI HAR Dataset\\train\\y_train.txt", subject record ".\\UCI HAR Dataset\\train\\subject_train.txt", and store them in vectors **vecTrainActivityID**, **vecTrainSub**, respectively.   
        2) Read the train set file ".\\UCI HAR Dataset\\x_train.txt", and store it in table **tblTrainSet**. The column headers of tblTrainset is the vector obtained in step 2, **vecFeature**. Keep only the columns with ".mean." and ".std." in their headers since they corresponds to the variables generated by functions mean() and std().
        3) Add **vecTrainSub** and **vecTrainActivityID** to **tblTrainSet** as the first two columns named as **subject** and **activityid**. At this point, the tain data set **tblTrainSet** is **tblTrainSet(subject, activityid, [all the features using mean() or std()])**. 
4. Generate the data set for the test set, using the three sub-steps in step 3, where "Train" is replaced by "Test". Store the result in the table **tblTestSet**. 
5. Merge tblTestSet and tblTrainSet into one dataset named as **HARData** using bind_rows() function.
6. Group **HARData** by **subject** and **activityid**, then summarise each column using function mean(), store the result in a new dataset named as **HARData_mean**.
7. Replace the **activityid** column with **activity**, whose values are the names of the activities, using function inner_join() to joint **tblActivity(id, activity)** and **HARData_mean**, and remove the activityid column. At this point, **HARData_mean** is **HARData_mean(subject, activity, [all the features using mean() or std()])** 
8. Gather all the columns in **HARData_mean** other than **subject**, **activity** into one column named as **measure**, and the measured values are stored in the column **value**.
7. Separate the column **measure** into (**domain**, **signal**, **method**). **Note**: at this point, the values in the column **measure** have the same format as  

        * [domain][feature].[method]..(.[axis]):  
                * domain: one character either "f" or "t".  
                * signal: takes one of the values ("BodyAccJerkMag", "BodyAccJerk", "BodyAccMag", "BodyAcc", "BodyGyroJerkMag", "BodyGyroJerk", "BodyGyroMag", "BodyGyro", "GravityAccMag", "GravityAcc").  
                * method: either "mean" or "std".  
                * axis: axis takes one of the values ("X","Y","Z"). **NOTE**: features ("BodyAccJerkMag", "BodyAccMag", "BodyGyroJerkMag", "BodyGyroMag", "GravityAccMag") does not have the axis attribute.  
Accordingly, the measure column is separated into columns (**domain**, **signal**, **method**, **axis**). Then merge **signal** and **axis** into one column using function past0() to replace **signal**. Replace the values "f" and "t" in **domain** as "freq" and "time", respectively. Upto this point, **HARData_mean** have columns (**subject**, **activity**, **signal**, **domain**, **method**, **value**)
8. Spread the **method** column into **mean** and **std**, where column **value** is used to populate the cells in **mean** and **std**. 
9. Process the typos. **NOTE** that int the "UCI HAR Dataset\\feature.txt" file, the features "fBodyBodyAccJerkMag-mean()","fBodyBodyAccJerkMag-std()", "fBodyBodyGyroMag-mean()", "fBodyBodyGyroMag-std()", "fBodyBodyGyroJerkMag-mean()", "fBodyBodyGyroJerkMag-std()" should be "fBodyAccJerkMag-mean()","fBodyAccJerkMag-std()", "fBodyGyroMag-mean()", "fBodyGyroMag-std()", "fBodyGyroJerkMag-mean()", "fBodyGyroJerkMag-std()".  
10. COnvet values in the column **signal** be lower case. At this point, data set **HARData_mean**(**subject**, **activity**, **signal**, **domain**, **mean**, **std**) is established.
11. Write **HARData_mean** into file ".\\HARDataMean.txt".
                
## Reference
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012