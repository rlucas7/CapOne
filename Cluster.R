X<-read.csv(#big_X)
  temp<-X[,c(2,3,4,6)];
  Data<-scale(temp[,2:4]); #keep trans_count, num_zips, num_merchants
  rownames(Data)<-temp$acct_id_code;
  
  #decision to  # of clusters
  wss <- (nrow(Data)-1)*sum(apply(Data,2,var))
  for (i in 2:40) wss[i] <- sum(kmeans(Data, centers=i)$withinss,iter.max=30)
  plot(1:40, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
  
  #No big difference in WSS, for less number of models, Implementing k means with k=10
  fit.k10 <- kmeans(Data, 10,iter.max=50) 
  cluster.k10<-fit.k10$cluster
  
  #Plotting customers in training set based on the cluster
  library(rgl)
  plot3d(x = temp[,2], y =temp[,3], z = temp[,4],col=cluster.k10,xlab="# of ZIP",ylab="# of Merchants",zlab="Trxn Frequencies")