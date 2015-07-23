setwd("C:/Users/bh17649/Documents/Data_Science/R Files/UCI HAR Dataset")
getwd()

library(data.table)

#Load feature data

#List of all features transposed to use as column names:
features <- read.csv("features.txt", sep="", header = FALSE)
features <- t(features)
features <- features[2, ]

##For more information on features: "features_info.txt"

##Load and inspect test data

#'test/subject_test.txt': Each row identifies the subject who performed the
# activity for each window sample. Its range is from 1 to 30. 
testing_subject <- read.csv("test/subject_test.txt", header = FALSE)
colnames(testing_subject)[1] <-"Subject"

##'test/y_test.txt': Testing activity type labels.
testing_labels <- read.csv("test/y_test.txt", header = FALSE)
colnames(testing_labels)[1] <-"Activity_Key"


##'test/X_test.txt': Testing set.
testing_set <- read.csv("test/x_test.txt", sep = "", header = FALSE)


#Append Column Names
colnames(testing_set) <- features
#Append Subject and Activity Type to results
testing_id_results <- cbind(testing_subject, testing_labels, testing_set)

       
##Load training data files
#'train/subject_train.txt': Each row identifies the subject who performed the
# activity for each window sample. Its range is from 1 to 30.
training_subject <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
colnames(training_subject)[1] <-"Subject"

##'train/y_train.txt': Training labels.
training_labels <- read.csv("train/y_train.txt", sep = "", header = FALSE)
colnames(training_labels)[1] <-"Activity_Key"

##'train/X_train.txt': Training set.
training_set <- read.csv("train/x_train.txt", sep = "", header = FALSE)
#Append Column Names
colnames(training_set) <- features

##Combine the three training datasets into one
training_id_results <- cbind(training_subject, training_labels, training_set)


##Merges the training and the test sets to create one data set.
total_results <- rbind(testing_id_results, training_id_results)


##Extracts only the measurements on the mean and standard deviation for each measurement. 
slim_total <- data.frame(total_results)
cols <- c(1, 2:8,  43:48,  83:88, 123:128, 163:168, 203, 204,  216, 217, 229, 
          230, 242, 243, 255, 256, 268:273, 347:352, 426:431, 505, 506, 518, 
          519, 531, 532, 544, 545)

slim_total <- slim_total[,cols]
names(slim_total)

#Descriptive activity names to name the activities in the data set
#'activity_labels.txt': Links the class labels with their activity name.
activity_labels <- read.csv("activity_labels.txt", sep=" ", header=FALSE)
        colnames(activity_labels)[1] <-"Activity_Key"
        colnames(activity_labels)[2] <-"Activity_Label"

 
library("data.table")
activity_labels <- data.table(activity_labels, key="Activity_Key")
slim_total <- data.table(slim_total, key="Activity_Key")

##Appropriately label the data set with descriptive variable names. 
slim_total<- merge(activity_labels, slim_total)

##From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
dt <- data.table(slim_total)
setkey(dt, Subject)
Mean_Results_by_Subj_Act <- dt[, lapply(.SD,mean),by = list(Subject, Activity_Label)]
View(Mean_Results_by_Subj_Act)

write.table(Mean_Results_by_Subj_Act, file = "Mean_Results_by_Subj_Act", row.names = FALSE,
            col.names = TRUE)

