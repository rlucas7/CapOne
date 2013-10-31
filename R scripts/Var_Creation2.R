################################################################################################################################
# SQL_Commands Variable Creation.R
# Creates Customer Specific X Matrix
# 10.30.2013
################################################################################################################################
# Intialize DataBase
#install.packages("RMySQL") 
#install.packages("reshape")
library(reshape)
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
dbListTables(mydb)

dbListFields(mydb, 'mysql.cap1_disk1_build_auth_M155' )

################################################################################################################################
# CREATE VARIABLES
################################################################################################################################
#proportion of purchases online
#table_name <- c('M155','M216','M218','M274','M340','M410','M1108','M1369','M1444','M1600','M1739','M753','M919','M2024',
#                'M2042','M2198','M2295','M2352','M2563','M3497','M3589','M3841','M3892')

table_name <- c('M218','M274','M340','M410','M1108','M1369','M1444','M1600','M1739','M753','M919','M2024',
                'M2042','M2198','M2295','M2352','M2563','M3497','M3589','M3841','M3892')

for (t in table_name){
  #proportion of purchases online
  print(Sys.time())
  print(t)
  mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
  sql.q <- paste("SELECT acct_id_code, Avg(Internet_trxn) as online_prob FROM mysql.cap1_disk1_build_auth_",t," 
                 WHERE (substr(trxn_date,3,3) in ('JAN','FEB','MAR','APR','MAY','JUN','OCT','NOV','DEC')) OR 
                 (substr(trxn_date,8,2) = ('10') ) GROUP BY acct_id_code", sep='') #EXCLUDE TEST PERIOD
  purchase_online <- dbGetQuery(mydb, sql.q)
  print(Sys.time())
  
  # aggregate purchases by industry
  sql.q2 <- paste("SELECT acct_id_code, Industry_Name, Count(Industry_Name) as n FROM mysql.cap1_disk1_build_auth_",t," 
                  WHERE (substr(trxn_date,3,3) in ('JAN','FEB','MAR','APR','MAY','JUN','OCT','NOV','DEC')) OR 
                  (substr(trxn_date,8,2) = ('10') ) Group by acct_id_code, Industry_Name", sep='')
  tmp_industry <- dbGetQuery(mydb, sql.q2) 
  industry_counts <- reshape(tmp_industry, v.names = "n", idvar = "acct_id_code", timevar= "Industry_Name",direction="wide")
  industry_counts[is.na(industry_counts)] <- 0
  print(Sys.time())
  
  #total number of purchases
  sql.q3 <- paste("SELECT acct_id_code, Count(*) as trans_freq FROM mysql.cap1_disk1_build_auth_",t," 
                  WHERE (substr(trxn_date,3,3) in ('JAN','FEB','MAR','APR','MAY','JUN','OCT','NOV','DEC')) OR 
                  (substr(trxn_date,8,2) = ('10') ) GROUP BY acct_id_code", sep='')
  freq_count <- dbGetQuery(mydb, sql.q3)
  print(Sys.time())
  
  # number of purchases in previous 3 months
  sql.q4 <- paste("SELECT acct_id_code, Count(*) as freq_prev3 FROM mysql.cap1_disk1_build_auth_",t," WHERE 
                  substr(trxn_date,3,3) in ('APR','MAY','JUN') GROUP by acct_id_code", sep='')
  freq_count_last3 <- dbGetQuery(mydb,sql.q4)  
  print(Sys.time())
  
  # Number of Merchants and Merchant ZipCodes
  sql.q5 <- paste("SELECT acct_id_code, count(distinct merchant_zip5) as Num_ZIP, count(distinct merchant_code) as Num_Merchant
                  FROM mysql.cap1_disk1_build_auth_",t," WHERE (substr(trxn_date,3,3) in 
                  ('JAN','FEB','MAR','APR','MAY','JUN','OCT','NOV','DEC')) OR 
                  (substr(trxn_date,8,2) = ('10') ) GROUP by acct_id_code", sep='')
  count_merchants <- dbGetQuery(mydb,sql.q5)
  print(Sys.time())
  
  # aggregate purchases by industry
  sql.q6 <- paste("SELECT acct_id_code, Industry_Name, Count(Industry_Name) as n_o FROM mysql.cap1_disk1_build_auth_",t," 
                  WHERE (substr(trxn_date,3,3) in ('JAN','FEB','MAR','APR','MAY','JUN','OCT','NOV','DEC')) OR 
                  (substr(trxn_date,8,2) = ('10') ) AND internet_trxn = 1 Group by acct_id_code, Industry_Name", sep='')
  tmp_industry_online <- dbGetQuery(mydb, sql.q6) 
  industry_counts_online <- reshape(tmp_industry_online, v.names = "n_o", idvar = "acct_id_code", timevar= "Industry_Name",direction="wide")
  industry_counts_online[is.na(industry_counts_online)] <- 0
  print(Sys.time())
  
  tmp <- merge_recurse(list(count_merchants, freq_count_last3, freq_count, industry_counts, purchase_online, 
                            industry_counts_online), by = "acct_id_code")
  tmp.order <- tmp[order(tmp$acct_id_code),] # order by id code
  nam <- paste("X", t, sep = "_")
  assign(nam, tmp.order)
  dbWriteTable(mydb, nam, tmp.order )
}
tmp <- industry_counts_online[!(duplicated(industry_counts_online$acct_id_code)),] #remove dups



#dbRemoveTable(mydb, "Static_X_small")
#dbListFields(mydb, "Static_X_small")
dbListTables(mydb)

dbDisconnect(mydb)
