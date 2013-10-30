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
industry_counts <- data.frame(as.matrix(character(0),ncol=2))
freq_count <- data.frame(as.matrix(character(0),ncol=2))

for (t in table_name){
  #proportion of purchases online
  sql.q <- paste("SELECT acct_id_code, Avg(Internet_trxn) FROM mysql.cap1_disk1_build_auth_",t," GROUP BY acct_id_code", sep='')
  purchase_online <- rbind(purchase_online,dbGetQuery(mydb, sql.q))
  
  # aggregate purchases by industry
  sql.q2 <- paste("SELECT acct_id_code, Super_Industry_Name, Count(Super_Industry_Name) FROM mysql.cap1_disk1_build_auth_",t," 
                  Group by acct_id_code, Super_Industry_Name", sep='')
  tmp_industry <- dbGetQuery(mydb, sql.q2) # Need to unpack industry by users???
  
  #total number of purchases
  sql.q3 <- paste("SELECT acct_id_code, Count(*) as trans_freq FROM mysql.cap1_disk1_build_auth_",t," GROUP BY acct_id_code", sep='')
  freq_count <- rbind(freq_count,dbGetQuery(mydb, sql.q3))
  
  # number of purchases in previous 3 months
  tmp<- dbGetQuery(mydb, "SELECT acct_id_code, count(*) from mysql.cap1_disk1_build_auth_M155 WHERE 
                   substr(trxn_date,3,3) in ('APR','MAY','JUN') GROUP by acct_id_code")
  
}
dbListFields(mydb,"mysql.cap1_disk1_build_auth_M155")


tmp<- dbSendQuery(mydb, "select * from mysql.cap1_disk1_build_auth_M155 WHERE substr(trxn_date,3,3) in ('JAN','FEB')")
fetch(tmp,5)
dbDisconnect(mydb)
