library(randomForest)
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
dbListTables(mydb)
Y <- dbGetQuery(mydb, "SELECT * from Y")

big_data <- merge(Y,static_X, by ="acct_id_code")
big_data[is.na(big_data)] <- 0

s <- Sys.time()
t<-randomForest(x=big_data[,-c(1,2)], y=as.factor(big_data[,2]),type="classification", ntree=5)
Sys.time() - s
predict(t,big_data[10000:11000,-c(1,2)],type="prob")