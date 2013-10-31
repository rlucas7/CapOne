################################################################################################################################
# SQL_Commands Variable Creation.R
# Creates Customer Specific X Matrix
# 10.29.2013
################################################################################################################################

# Intialize DataBase
#install.packages("RMySQL") 
#install.packages("reshape")
library(reshape)
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
dbListTables(mydb)

################################################################################################################################
# CREATE VARIABLES
################################################################################################################################
#proportion of purchases online
table_name <- c('M155',"M216")
purchase_online <- data.frame(as.matrix(character(0),ncol=2))
industry_counts <- data.frame(as.matrix(character(0),ncol=2))
freq_count <- data.frame(as.matrix(character(0),ncol=2))
freq_count_last3 <- data.frame(as.matrix(character(0),ncol=2))
count_merchants <- data.frame(as.matrix(character(0),ncol=2))

for (t in table_name){
  #proportion of purchases online
  sql.q <- paste("SELECT acct_id_code, Avg(Internet_trxn) FROM mysql.cap1_disk1_build_auth_",t," GROUP BY acct_id_code", sep='')
  purchase_online <- rbind(purchase_online,dbGetQuery(mydb, sql.q))
  
  # aggregate purchases by industry
  sql.q2 <- paste("SELECT acct_id_code, Industry_Name, Count(Industry_Name) as n FROM mysql.cap1_disk1_build_auth_",t," 
                  Group by acct_id_code, Industry_Name", sep='')
  tmp_industry <- dbGetQuery(mydb, sql.q2) # Need to unpack industry by users??? -- use reshape
  industry <- reshape(tmp_industry, v.names = "n", idvar = "acct_id_code", timevar= "Industry_Name",direction="wide")
  industry[is.na(industry)] <- 0
  industry_counts <- rbind(industry_counts,industry)
  
  #total number of purchases
  sql.q3 <- paste("SELECT acct_id_code, Count(*) as trans_freq FROM mysql.cap1_disk1_build_auth_",t," GROUP BY acct_id_code", sep='')
  freq_count <- rbind(freq_count,dbGetQuery(mydb, sql.q3))
  
  # number of purchases in previous 3 months
  sql.q4 <- paste("SELECT acct_id_code, Count(*) FROM mysql.cap1_disk1_build_auth_",t," WHERE 
                   substr(trxn_date,3,3) in ('APR','MAY','JUN') GROUP by acct_id_code", sep='')
  freq_count_last3 <- rbind(freq_count_last3, dbGetQuery(mydb,sql.q4))  

  # Number of Merchants and Merchant ZipCodes
  sql.q5 <- paste("SELECT acct_id_code, count(distinct merchant_zip5) as Num_ZIP, count(distinct merchant_code) as Num_Merchant
                  FROM mysql.cap1_disk1_build_auth_",t," GROUP by acct_id_code", sep='')
  count_merchants <- rbind(count_merchants, dbGetQuery(mydb,sql.q5))
  
  # aggregate purchases by industry
  sql.q6 <- paste("SELECT acct_id_code, Industry_Name, Count(Industry_Name) as n FROM mysql.cap1_disk1_build_auth_",t," 
                  WHERE internet_trxn = 1 Group by acct_id_code, Industry_Name", sep='')
  tmp_industry_online <- dbGetQuery(mydb, sql.q6) 
  industry_online <- reshape(tmp_industry_online, v.names = "n", idvar = "acct_id_code", timevar= "Industry_Name",direction="wide")
  industry_online[is.na(industry_online)] <- 0
  industry_counts_online <- rbind(industry_counts_online,industry_online)
  
}
tmp <- merge_recurse(list(count_merchants, freq_count_last3, freq_count, industry_counts, purchase_online, 
                          industry_counts_online), by = "acct_id_code")
tmp.reduce <- tmp[-(1:dim(tmp)[1])[duplicated(tmp$acct_id_code)],] # remove duplicates
tmp.order <- tmp.reduce[order(tmp.reduce$acct_id_code),] # order by id code

#dbWriteTable(mydb, "Sample_X", tmp.order )
dbListTables(mydb)
samp_out <- dbGetQuery(mydb, "SELECT * from Sample_X")

dbDisconnect(mydb)
