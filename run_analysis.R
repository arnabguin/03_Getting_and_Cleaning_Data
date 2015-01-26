library(plyr)

## Read training and test features from UCI data set
Xtrain <- read.csv("./UCI/train/X_train.txt",sep=" ",header=FALSE)
Xtest <- read.csv("./UCI/test/X_test.txt",sep=" ",header=FALSE)
## Extract feature list
Xfeatures <- read.csv("./UCI/features.txt",sep=" ",header=FALSE)

## Assign feature column names to training and test sets

colnames(Xfeatures) <- c("index","feature")
colnames(Xtrain) <- Xfeatures$feature
colnames(Xtest) <- Xfeatures$feature

## Filter column names to include only mean and std measurements

Xtrain <- Xtrain[,grep ("std|mean",colnames(Xtrain))]
Xtest  <- Xtest[,grep ("std|mean",colnames(Xtest))]

# Read output classification training and test data
Ytrain <- as.list(read.csv("./UCI/train/y_train.txt",sep=" ",header=FALSE))
Ytest  <- as.list(read.csv("./UCI/test/y_test.txt",sep=" ",header=FALSE))

# Read activity labels and augment training/test data by replacing indices with actual class string labels

Yact <- read.csv("./UCI/activity_labels.txt",sep=" ",header=FALSE)
colnames(Yact) <- c("index","label")
Yclassify <- Yact$label

Ytrainclassify <- data.frame(activity=lapply(Ytrain,function(x) { Yclassify[as.numeric(x)] }))
colnames(Ytrainclassify) <- c("activity")
Ytestclassify  <- data.frame(activity=lapply(Ytest, function(x) { Yclassify[as.numeric(x)] }))
colnames(Ytestclassify) <- c("activity")


trainingSet <- cbind(Xtrain,Ytrainclassify)

testSet <- cbind(Xtest,Ytestclassify)

## Annotate subject as a separate column in the training/test data set

Xtrainsubject <- read.csv("./UCI/train/subject_train.txt",header=FALSE,sep=" ")
Xtestsubject <- read.csv("./UCI/test/subject_test.txt",header=FALSE,sep=" ")
colnames(Xtrainsubject) <- c("subject")
colnames(Xtestsubject) <- c("subject")

trainingSet <- cbind(Xtrainsubject,trainingSet)
testSet <- cbind(Xtestsubject,testSet)

## Merge training and test sets

allSet <- rbind(trainingSet,testSet)

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyDataSet <- ddply(allSet,.(activity,subject),function(x) { colMeans(subset(x,select=-c(activity,subject),na.rm=TRUE)) } )
write.table(tidyDataSet,file="tidy.csv",row.names=FALSE,sep=" ")

