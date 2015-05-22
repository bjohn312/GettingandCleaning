## This is the R analysis for the Course Project for Getting and Cleaning Data (getdata-014)
## You will need the dyplr & plyr packages to run this code they can be loaded as follows: 
install.packages("dplyr"); install.packages("plyr"); library(dplyr); library(plyr)
## data located at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## create a variable called "fileUrl" to store the Url for the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "workingdirectory/CourseProject.zip", method = "curl")
## file can be expanded in the files window or unzipped using the unz() function
unz("workingdirectory/CourseProject.zip")
## The following 3 lines ead the Train Folder into R
train1 <- read.table("data/UCI HAR Dataset/train/X_train.txt") 
train_act <- read.table("data/UCI HAR Dataset/train/y_train.txt")
train_sub <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
## rename (y_train) column to train_activity; rename train_sub (subject_train) column to train_subject
## you can rename the data frames to avoid the overwriting on this step if you want
train_act <- dplyr::rename(train_act, activitylabel = V1); train_sub <- dplyr::rename(train_sub, subjectid = V1)
## Use cbind() the "train" data sets together into a table called "train_data"
train_data <- cbind(train_act, train_sub, train1)
## The following 3 lines ead the Test Folder into R
test1 <- read.table("data/UCI HAR Dataset/test/X_test.txt") 
test_act <- read.table("data/UCI HAR Dataset/test/y_test.txt")
test_sub <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
## if test_sub has different dimensions it may needs to be subset to match the other tables
## rename (y_train) column to train_activity; rename train_sub (subject_train) column to train_subject
## you can rename the data frames to avoid the overwriting on this step if you want
test_act <- dplyr::rename(test_act, activitylabel = V1); test_sub <- dplyr::rename(test_sub, subjectid = V1)
## Use cbind() the "test" data sets together into a table called "test_data"
test_data <- cbind(test_act, test_sub, test1)
## merge the data tables; new table should have 10,299 observations & 563 variables
allData = merge(test_data, train_data, all=TRUE) # step 1 complete
## Read the features.txt file into R so it can be used to efficiently subset
features <- read.table("data/UCI HAR Dataset/features.txt")
## Use grep() to find the "mean" and "std" (standard deviation) variables
MeanTF <- grep("mean", features$V2); StdTF <- grep("std", features$V2)
## Create subsets of allData using the grep search results
ExtractMean <- allData[,MeanTF,]; ExtractStd <- allData[,StdTF,]
## Use cbind() combined the extracted data sets
dataSubset <- cbind(ExtractMean, ExtractStd) #step 2 complete
## Create subsets of allData using the grep search results
Walking <- grep("1", dataSubset$activitylabel)
WALKING_UPSTAIRS <- grep("2", dataSubset$activitylabel) 
WALKING_DOWNSTAIRS<- grep("3", dataSubset$activitylabel)
SITTING <- grep("4", dataSubset$activitylabel) 
STANDING <- grep("5", dataSubset$activitylabel)
LAYING <- grep("6", dataSubset$activitylabel)
## rewrite activity label as a descriptive activity label name with mutate()
WalkingSub <- dataSubset[Walking,,]; WalkingSub <- mutate(WalkingSub, descriptivelabel = "walking")
UpstairsSub <- dataSubset[WALKING_UPSTAIRS,,]; UpstairsSub <- mutate(UpstairsSub, descriptivelabel = "walking upstairs")
DownstairsSub <- dataSubset[WALKING_DOWNSTAIRS,,]; DownstairsSub <- mutate(DownstairsSub, descriptivelabel = "walking downstairs") 
SittingSub <- dataSubset[SITTING,,]; SittingSub <- mutate(SittingSub, descriptivelabel = "sitting")
StandingSub <- dataSubset[STANDING,,]; StandingSub <- mutate(StandingSub, descriptivelabel = "standing")
LayingSub <- dataSubset[LAYING,,]; LayingSub <- mutate(LayingSub, descriptivelabel = "laying")   
## merge the data tables back together
DescriptiveNames1 = merge(LayingSub, WalkingSub, all=TRUE)
DescriptiveNames2 = merge(StandingSub, SittingSub, all=TRUE)
DescriptiveNames3 = merge(DownstairsSub, UpstairsSub, all=TRUE)
AlmostDescriptive = merge(DescriptiveNames1, DescriptiveNames2, all=TRUE)
DescriptiveNames = merge(AlmostDescriptive, DescriptiveNames3, all=TRUE) # step 3 complete
## Remove the V at the beginning of the column names then sort the data set
dataSubset <- strsplit(names(DescriptiveNames), "V")
sortedSubset <- DescriptiveNames[,order(colnames(DescriptiveNames),decreasing=TRUE)] ## Found on Stack Overflow
## Use dplyr::rename to descriptively name the variables in the data set
Step4 <- dplyr::rename(sortedSubset, "tBodyAcc mean X" = V1, "tBodyAccJerk mean X" = V119, "tBodyAccJerk mean Y"=V120,"tBodyAccJerk mean Z" = V121, "tBodyGyro std X"=V122, "tBodyGyro std Y"=V123, "tBodyGyro std Z"=V124, "tBodyGyroJerk mean X"=V159 , "tBodyGyroJerk mean Y"= V160,"tBodyGyroJerk mean Z" =V161, "tBodyGyroJerk std X"=V162, "tBodyGyroJerk std Y"=V163, "tBodyGyroJerk std Z"=V164, "tBodyAccMag-mean" =V199, "tBodyAcc mean Y" = V2, "tBodyAccMag std" =V200, "tGravityAccMag-mean"=V212, "tGravityAccMag std"=V213, "tBodyAccJerkMag mean"=V225,"tBodyAccJerkMag-std"=V226,"tBodyGyroMag-mean"=V238,"tBodyGyroMag-std"=V239, "tBodyGyroJerkMag mean"=V251, "tBodyGyroJerkMag std"=V252, "fBodyAcc mean X"= V264,"fBodyAcc mean Y"=V265, "fBodyAcc mean Z"=V266, "fBodyAcc std X"=V267, "fBodyAcc std Y"=V268,"fBodyAcc-std()-Z"=V269,"fBodyAcc-meanFreq()-X"=V292,"fBodyAcc-meanFreq()-Y"=V293,"fBodyAcc-meanFreq()-Z"=V294,"tBodyAcc-mean()-Z"=V3,"fBodyAccJerk-mean()-X"=V343,"fBodyAccJerk-mean()-Y"=V344,"fBodyAccJerk-mean()-Z"=V345,"fBodyAccJerk-std()-X"=V346,"fBodyAccJerk-std()-Y"=V347,"fBodyAccJerk-std()-Z"=V348, "fBodyAccJerk-meanFreq()-X"=V371,"fBodyAccJerk-meanFreq()-Y"=V372,"fBodyAccJerk-meanFreq()-Z"=V373,"tGravityAcc-mean()-X"=V39,"tBodyAcc-std()-Z"=V4,"tGravityAcc-mean()-Y"=V40,"tGravityAcc-mean()-Z"=V41,"tGravityAcc-std()-X"=V42,"fBodyGyro-mean()-X"=V422,"fBodyGyro-mean()-Y"=V423,"fBodyGyro-mean()-Z"=V424,"fBodyGyro-std()-X"=V425,"fBodyGyro-std()-Y"=V426,"fBodyGyro-std()-Z"=V427,"tGravityAcc-std()-Y"=V43,"tGravityAcc-std()-Z"=V44,"fBodyGyro-meanFreq()-X"=V450,"fBodyGyro-meanFreq()-Y"=V451,"fBodyGyro-meanFreq()-Z"=V452,"fBodyAccMag-mean()"=V501,"fBodyAccMag-std()"=V502,"fBodyAccMag-meanFreq()"=V511,"fBodyBodyAccJerkMag-mean()"=V514,"fBodyBodyAccJerkMag-std()"=V515,"fBodyBodyAccJerkMag-meanFreq()"=V524,"fBodyBodyGyroMag-mean()"=V527,"fBodyBodyGyroMag-std()"=V528,"fBodyBodyGyroMag-meanFreq()"=V537,"fBodyBodyGyroJerkMag-mean()"=V540,"fBodyBodyGyroJerkMag-std()"=V541,"fBodyBodyGyroJerkMag-meanFreq()"=V550,"tBodyAccJerk-mean()-X"=V79,"tBodyAccJerk-mean()-Y"=V80,"tBodyAccJerk-mean()-Z"=V81,"tBodyAccJerk-std()-X"=V82,"tBodyAccJerk-std()-Y"=V83,"tBodyAccJerk-std()-Z"=V84)##Step 4 Complete
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject 
