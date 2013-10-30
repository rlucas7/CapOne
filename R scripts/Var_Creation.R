################################################################################################################################
# SQL_Commands Variable Creation.R
# 10.29.2013
################################################################################################################################

# Intialize DataBase
#install.packages("RMySQL") 
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
dbListTables(mydb)

################################################################################################################################
# CREATE VARIABLES
################################################################################################################################
#proportion of purchases online
table_name <- c('M155','M216')
purchase_online <- data.frame(as.matrix(character(0),ncol=2))
for (t in table_name){
  sql.q <- paste("SELECT acct_id_code, Avg(Internet_trxn) FROM mysql.cap1_disk1_build_auth_",t," GROUP BY acct_id_code", sep='')
  purchase_online <- rbind(purchase_online,dbGetQuery(mydb, sql.q))                           
}
dbListFields(mydb,"mysql.cap1_disk1_build_auth_M155")

for (t in table_name){
  sql.q <- paste("SELECT acct_id_code, Industry_Name, Count(Industry_Name) FROM mysql.cap1_disk1_build_auth_",t," Group by acct_id_code, Industry_Name", sep='')
  a <- dbGetQuery(mydb, sql.q)
  purchase_online <- rbind(purchase_online,dbGetQuery(mydb, sql.q))                           
}

dbDisconnect(mydb)
