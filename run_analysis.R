if(!file.exists("UCI HAR Dataset")) {
  unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header = F, col.names = "id")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header = F, col.names = "id")

xTest <- read.table(file = "UCI HAR Dataset//test/X_test.txt", sep = "", header=FALSE )
xTrain <- read.table(file = "UCI HAR Dataset//train/X_train.txt", sep = "", header=FALSE )

yTest <- read.table(file = "UCI HAR Dataset//test/y_test.txt", sep = "", header=FALSE )
yTrain <- read.table(file = "UCI HAR Dataset//train/y_train.txt", sep = "", header=FALSE )

features <- read.table("UCI HAR Dataset/features.txt", sep="", header = F, col.names = c("id","name"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", sep="", header = F, col.names = c("id","name"))

#Merge the training and the test sets to create one data set.
tidyData <- rbind(
  cbind(subjectTest, yTest, xTest),
  cbind(subjectTrain, yTrain, xTrain)
)

#Label the data set with descriptive variable names. 
colnames(tidyData) <- c("subject","activity",as.character(features$name))

#Use descriptive activity names to name the activities in the data set
tidyData$activity <- factor(x=tidyData$activity, activities$id, as.character(activities$name))
tidyData$subject <- as.factor(tidyData$subject)

#Extract only the measurements on the mean and standard deviation for each measurement. 
colsToKeep <- c("subject","activity", colnames(tidyData)[grepl("(.*-mean\\(\\).*|.*-std)", colnames(tidyData))])
tidyData <- tidyData[,colsToKeep]

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyAverages <- aggregate(tidyData[,c(-1,-2)], list(subject=tidyData$subject, activity=tidyData$activity), mean)
colnames(tidyAverages) <- c("subject","activity", paste("mean-",colnames(tidyAverages)[-1:-2], sep = ""))

