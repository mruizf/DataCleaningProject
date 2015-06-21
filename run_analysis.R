#
#Mauricio Ruiz 
#
#I suppose datafiles are in the original zip in the current working directory
#

##Readeing idlbel files (base directory)

featuresIdNames<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/features.txt"),sep=" ",header=FALSE)
colnames(featuresIdNames)<-c("Id","FeatureLabel")

activityIdNames<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/activity_labels.txt"),sep=" ",header=FALSE)
colnames(activityIdNames)<-c("Id","ActivityLabel")


print("Labels readed")
##Readeing test input set  files (data directory)

subjectIdTest<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/subject_test.txt"),sep=" ",header=FALSE)
colnames(subjectIdTest)<-c("IdSubject")

activityIdTest<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/y_test.txt"),sep=" ",header=FALSE)
colnames(activityIdTest)<-c("IdActivity")

activityIdTest<-merge(activityIdTest,activityIdNames,by.x="IdActivity",by.y="Id")

recordsTest<-read.table(unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/X_test.txt"),header=FALSE)
colnames(recordsTest)<-featuresIdNames[,2]#label properly each column

recordsTest<-cbind(activityIdTest,recordsTest)
recordsTest<-cbind(subjectIdTest,recordsTest)

print("Data readed")
#------------------------------
##Readeing train input set  files (data directory)

subjectIdTrain<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/subject_train.txt"),sep=" ",header=FALSE)
colnames(subjectIdTrain)<-c("IdSubject")

activityIdTrain<-read.csv(unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/y_train.txt"),sep=" ",header=FALSE)
colnames(activityIdTrain)<-c("IdActivity")

activityIdTrain<-merge(activityIdTrain,activityIdNames,by.x="IdActivity",by.y="Id")

recordsTrain<-read.table(unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/X_train.txt"),header=FALSE)
colnames(recordsTrain)<-featuresIdNames[,2] #label properly each column

recordsTrain<-cbind(activityIdTrain,recordsTrain)
recordsTrain<-cbind(subjectIdTrain,recordsTrain)

#Total data 
recordsTotal<-rbind(recordsTest,recordsTrain)

print("Data merged")
#mean and standar deviation

meansTotal<-sapply(recordsTotal,mean)
sdTotal<-sapply(recordsTotal,sd)

print("Mean and sd calculated")
#Write new data set


recordSplited<-split(recordsTotal,list(recordsTotal$IdSubject,recordsTotal$IdActivity))


for(elem in recordSplited) {
  if(nrow(elem)==0)
  { 
    next 
  }
  tmp<-sapply(elem,mean)
  if (!exists("clasifiedMean"))
  {
    clasifiedMean<-tmp
  }
  else{
    clasifiedMean<-rbind(clasifiedMean,tmp)
  }
}

write.table(clasifiedMean,file="newDataSet.txt",row.name=FALSE)
print("New data set created")
