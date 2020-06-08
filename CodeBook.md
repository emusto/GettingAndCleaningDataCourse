# Getting and Cleaning Data Course Project

## SUMMARY

This work has been performed as final project for the Coursera'a Getting and Cleaning Data Course (https://www.coursera.org/learn/data-cleaning). 
The data provided represents data collected from the accelerometers from the Samsung Galaxy S smartphone (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). A detailed explanation of the experiments performed and of the collected data can be found in the README.txt of the data package (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The aim of this codebook is to describe the data, the variables and any transformations performed to clean up the data. The script performing these operation is called run_analysis.R and the output dataset is stored in a file called tidy_dataset.txt

## VARIABLES DESCRIPTION
From the provided data the mean and the standard deviation for the following features are selected:

- tBodyAcc-XYZ

- tGravityAcc-XYZ

- tBodyAccJerk-XYZ

- tBodyGyro-XYZ

- tBodyGyroJerk-XYZ

- tBodyAccMag

- tGravityAccMag

- tBodyAccJerkMag

- tBodyGyroMag

- tBodyGyroJerkMag

- fBodyAcc-XYZ

- fBodyAccJerk-XYZ

- fBodyGyro-XYZ

- fBodyAccMag

- fBodyAccJerkMag

- fBodyGyroMag

- fBodyGyroJerkMag

where in general t stands for time, f for frequency and X(Y,Z) corresponds to a physical direction. Moreover, the different measuerements are identified by the subject and type of activity. A detailed description of the variables themselves is provided in the "README.txt" file of the provided data.

## PERFORMED TRANSFORMATIONS
* ### Data download

In a preliminary step the data are download and unzipped. To save space, the downloaded .zip folder is removed.
The unzipped directory contains, among other files, two directories: test and train.

* ### Data aggregation

In the first step the training and the test sets are merged to create a combined data set. To achieve this goal both the files named "subject_test.txt" "X_test.txt" "y_test.txt" in the test directory and the files named "subject_train.txt" "X_train.txt" "y_train.txt" in the test directory are binded by column respectively in the test and train datasets; the two datasets are then binded by rows. 
The dataset column names are then assigned according to the file "features.txt".

* ### Data Pre-Selection

In the second step only the variables regarding the measurements on the mean and standard deviation are selected 

* ### Activities 

In the third step the activities are labelled according to the "activity_labels.txt" file.

* ### Variable names cleaning 

In the forth step the dataset column names are transformed in order to achieve more clarity (e.g. Acc --> Acceleration, t-->time, etc.).

* ### Tiding the dataset

In the fifth step a second tidy data set with the average of each variable for each activity and each subject is created and stored in the file "tidy_dataset.txt".

* ### Clean up

The intermediate R-objects are removed from memory.
