#libraries
library(dplyr)
library(data.table)

### Preliminary step: download the dataset, unzip it, clean
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "UCI_HAR_DATASET.zip")
unzip("UCI_HAR_DATASET.zip", overwrite = TRUE)
file.remove("UCI_HAR_DATASET.zip")
unzippeddir <- "UCI HAR Dataset/"
### First step: Merge the training and the test sets to create one data set

# merge test files by columns after cheching that all have same number of rows
test_files <- dir(paste(unzippeddir,"test",sep = ""),pattern = "txt", full.names = TRUE)
tf1 <- read.table(test_files[1], header = FALSE) #subjects
tf2 <- read.table(test_files[2], header = FALSE) # measurements
tf3 <- read.table(test_files[3], header = FALSE) # activity labels
if(dim(tf1)[1]!=dim(tf2)[1] || dim(tf1)[1]!=dim(tf3)[1] || dim(tf2)[1] !=dim(tf3)[1]) {
  print("The test data files have different numbers of rows - cannot merge them by column!")
  return()
} 

test_dataset <-cbind(tf1,tf2)
test_dataset <-cbind(test_dataset,tf3)
remove(tf1)
remove(tf2)
remove(tf3)

# merge training files by columns after cheching that all have same number of rows
training_files <- dir(paste(unzippeddir,"train",sep = ""),pattern = "txt", full.names = TRUE)
tf1 <- read.table(training_files[1], header = FALSE) #subjects
tf2 <- read.table(training_files[2], header = FALSE) #measurements
tf3 <- read.table(training_files[3], header = FALSE) # activity labels
if(dim(tf1)[1]!=dim(tf2)[1] || dim(tf1)[1]!=dim(tf3)[1] || dim(tf2)[1] !=dim(tf3)[1]) {
  print("The training data files have different numbers of rows - cannot merge them by column!")
  return()
} 

training_dataset <-cbind(tf1,tf2)
training_dataset <-cbind(training_dataset,tf3)
remove(tf1)
remove(tf2)
remove(tf3)

# merge training and test files after cheching that all have same number of columns
if(dim(training_dataset)[2]!=dim(test_dataset)[2]) {
  print("The training  and test data files have different numbers of columns - cannot merge them by row!")
  return()
} 

full_dataset <-rbind(training_dataset,test_dataset)

# name the dataset columns according to the "features.txt"
dataset_names <-"SubjectID"
features <- read.table(paste(unzippeddir,"features.txt",sep = ""),header = FALSE)
features_names <- features$V2
dataset_names <- append(dataset_names, as.character(features_names))
dataset_names <-append(dataset_names,"LabelsID")
names(full_dataset) <- dataset_names

### Second step: Extract only the measurements on the mean and standard deviation for each measurement.

partial_dataset <- full_dataset[,c(1,grep("mean()",names(full_dataset),fixed=TRUE),grep("std()",names(full_dataset)),dim(full_dataset)[2])]

### Third step: Use descriptive activity names to name the activities in the data set

labelNames <- read.table(paste(unzippeddir,"activity_labels.txt",sep = ""), header = FALSE)
r_partial_dataset <-inner_join(partial_dataset,labelNames, by = c("LabelsID" = "V1")) 
r_partial_dataset <-select(r_partial_dataset, -"LabelsID") %>% rename(activitylabels = V2)

### Forth Step: label the data set with descriptive variable names.

names(r_partial_dataset) <- sub("\\(\\)","", gsub("-","",sub("mean","Mean", sub("std","Std",names(r_partial_dataset)))))
names(r_partial_dataset) <- sub("BodyBody","Body",names(r_partial_dataset))
names(r_partial_dataset) <- sub("Acc","Acceleration",names(r_partial_dataset))
names(r_partial_dataset) <- sub("^f","frequency",names(r_partial_dataset))
names(r_partial_dataset) <- sub("^t","time",names(r_partial_dataset))

### Fifth Step creates a second tidy data set with the average of each variable for each activity and each subject.

tidy_dataset <- aggregate(. ~ SubjectID+ activitylabels, data = r_partial_dataset, FUN = mean)
write.table(tidy_dataset, file = "tidy_dataset.txt",
            sep = "\t", row.names = F)

# clean up
remove(test_dataset)
remove(training_dataset)
remove(full_dataset)
remove(labelNames)
remove(partial_dataset)
remove(r_partial_dataset)
remove(features)

