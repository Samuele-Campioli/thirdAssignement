library(dplyr)
#reading the fregmented data:
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("id","features"))
sbj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
sbj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")
#create complete dataset
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
sbj <- rbind(sbj_train, sbj_test)
dt <- cbind(x,y,sbj)
#extract wanted feature
dt_mean_std <- select(dt,sbj, code, contains("mean"), contains("std"))
#rename activity
dt_mean_std$code <- activities[dt_mean_std$code, 2]
#rename columns with more descriptive name
names(dt_mean_std)<-gsub("Acc", "Accelerometer", names(dt_mean_std))
names(dt_mean_std)<-gsub("BodyBody", "Body", names(dt_mean_std))
names(dt_mean_std)<-gsub("Gyro", "Gyroscope", names(dt_mean_std))
names(dt_mean_std)<-gsub("Mag", "Magnitude", names(dt_mean_std))
names(dt_mean_std)<-gsub("^t", "time", names(dt_mean_std))
names(dt_mean_std)<-gsub("^f", "frequency", names(dt_mean_std))
names(dt_mean_std)[2] = "activity"
#new dt with average of activities and subject
dt_2 <- dt %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))