# Pat measures
library("psych", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")
#Mean deviation(MD) (IPT Tuning)
#rm(deviation)
#rm(vec,c)
file_list_dev = ls(pattern="dev_NM_PAT_[A-Z]{2}[0-9]{2}[A-Z]{3}[0-9]{3}")
vec<-numeric(3*length(file_list_dev))
for (i in seq_along(file_list_dev)) {
  deviation = get(file_list_dev[[i]])
  colnames(deviation)<-c("c","note")
  
  c<-deviation$c

  MD = sum(c)/144 #sum all c over all 108 trails and devide by number of trials

  MAD = sum(abs(c))/144 #Mean absolute Deviation, A Measure of Accuracy

  #Standard deviation from own mean (SDfoM), AMeasure of Consistency
  SDfoM =sqrt(sum((c-MD)^2)/(144-1)) 
  vec[(i*3-2):(i*3)] <- c(MD,MAD,SDfoM)
}
dim(vec)<-c(3, length(file_list_dev)) # turn long vector into array(VP, AP_measures)
NM_AP_measures<-data.frame(vec) #turn into dataframe
NM_AP_measures<-t(NM_AP_measures)
colnames(NM_AP_measures)<-c("MD","MAD","SDfoM") #edit columnnames
rownames(NM_AP_measures)<-substring(file_list_dev,12)
i=i+1