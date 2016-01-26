library(data.table)

# 1.Merges the training and the test sets to create one data set.

training_subject = read.table("./data/wearable/train/subject_train.txt")
traindata_X = read.table("./data/wearable/train/X_train.txt")
traindata_Y = read.table("./data/wearable/train/Y_train.txt")
# 7352 obs in all three files above


test_subject = read.table("./data/wearable/test/subject_test.txt")
testdata_X = read.table("./data/wearable/test/X_test.txt")
testdata_Y = read.table("./data/wearable/test/Y_test.txt")
# 2947 obs. in all three files

joinSubject <- rbind(training_subject, test_subject)
joinX <- rbind(traindata_X, testdata_X)
joinY <- rbind(traindata_Y, testdata_Y)
# 10299 obs. in all three DF above


# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresDF <- read.table("./data/wearable/features.txt")
# 561 obs.
meanSDOnly <- grep("mean\\(\\)|std\\(\\)", featuresDF[, 2])
joinX <- joinX[,meanSDOnly]

# 3.Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("./data/wearable/activity_labels.txt")
head(activityLabels)
activityLabels[, 2] <- tolower(gsub("_", "", activityLabels[, 2]))
substr(activityLabels[2, 2], 8, 8) <- toupper(substr(activityLabels[2, 2], 8, 8))
substr(activityLabels[3, 2], 8, 8) <- toupper(substr(activityLabels[3, 2], 8, 8))

activityDesc <- activityLabels[joinY[, 1], 2]
joinY[, 1] <- activityDesc
names(joinY) <- "activity"


# 4.Appropriately labels the data set with descriptive variable names. 
names(joinSubject) <- "subject"
cleanMergedData <- cbind(joinSubject, joinX, joinY)
# 10299 obs.


# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mergedDT <- data.table(cleanMergedData)
calculatedDT <- mergedDT[, lapply(.SD, mean), by=c("subject", "activity")]
write.table(calculatedDT, "./data/wearable/output/calculated_tidy_data.txt", row.names = FALSE)
