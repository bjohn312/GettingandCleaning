## This is the R analysis for the Course Project for Getting and Cleaning Data (getdata-014)
## You will need the dyplr & plyr packages to run this code they can be loaded as follows: 
install.packages("dplyr"); install.packages("plyr"); library(dplyr); library(plyr)
## data located at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## create a variable called "fileUrl" to store the Url for the data
## file can be expanded in the files window or unzipped using the unz() function
## The following 3 lines ead the Train Folder into R
Create tables to temporarily hold the training files
## rename (y_train) column to train_activity; rename train_sub (subject_train) column to train_subject
## you can rename the data frames to avoid the overwriting on this step if you want
## Use cbind() the "train" data sets together into a table called "train_data"
Repeat the table construction methods with the test data similar to the training data
## if test_sub has different dimensions it may needs to be subset to match the other tables
## rename (y_train) column to train_activity; rename train_sub (subject_train) column to train_subject
## you can rename the data frames to avoid the overwriting on this step if you want
## Use cbind() the "test" data sets together into a table called "test_data"
## merge the data tables; new table should have 10,299 observations & 563 variables
## Read the features.txt file into R so it can be used to efficiently subset
## Use grep() to find the "mean" and "std" (standard deviation) variables
## Create subsets of allData using the grep search results
## Use cbind() combined the extracted data sets
## Create subsets of allData using the grep search results
## rewrite activity label as a descriptive activity label name with mutate()
## merge the data tables back together
## Remove the V at the beginning of the column names then sort the data set
## Use dplyr::rename to descriptively name the variables in the data set
