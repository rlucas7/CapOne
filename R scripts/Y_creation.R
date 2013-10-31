################################################################################################################################
# SQL_Commands Variable Creation.R
# Creates Y Matrix
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
dbListFields(mydb, 'SMC_Data' )

dbGetQuery(mydb, "SELECT distinct merchant_code from mysql.SMC_Data")

################################################################################################################################
# CREATE VARIABLES
################################################################################################################################
#proportion of purchases online
table_name <- c('M155','M216','M218','M274','M340','M410','M1108','M1369','M1444','M1600','M1739','M753','M919','M2024',
                'M2042','M2198','M2295','M2352','M2563','M3497','M3589','M3841','M3892')
y <- data.frame(as.matrix(character(0),ncol=15))

target_merchants <- c("M1008",'M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456',
                         'M382','M3868')

table_name <- c('M218','M274','M340','M410','M1108','M1369','M1444','M1600','M1739','M753','M919','M2024',
                'M2042','M2198','M2295','M2352','M2563','M3497','M3589','M3841','M3892')
for (t in table_name){
  #proportion of purchases online
  print(t)
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M1008 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M1008'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M1008 <- dbGetQuery(mydb, sql.y)
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M1707 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M1707'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M1707 <- dbGetQuery(mydb, sql.y)
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M1883 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M1883'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M1883 <- dbGetQuery(mydb, sql.y)  

  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M2168 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M2168'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M2168 <- dbGetQuery(mydb, sql.y)  

  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M2203 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M2203'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M2203 <- dbGetQuery(mydb, sql.y)  

  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M2493 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M2493'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M2493 <- dbGetQuery(mydb, sql.y)  

  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3123 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3123'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3123 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3126 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3126'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3126 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_3172 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3172'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3172 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3342 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3342'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3342 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3437 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3437'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3437 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3456 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3456'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3456 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M382 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M382'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M382 <- dbGetQuery(mydb, sql.y)  
  
  sql.y <- paste("SELECT acct_id_code, merchant_code as y_M3868 FROM mysql.cap1_disk1_build_auth_",t," WHERE substr(trxn_date,3,3) in ('JUL','AUG','SEP') AND substr(trxn_date,8,2) = ('11') AND merchant_code ='M3868'  GROUP BY acct_id_code", sep='') # TEST PERIOD
  y_M3868 <- dbGetQuery(mydb, sql.y)  
  
  sql.accts <- paste("SELECT distinct acct_id_code FROM mysql.cap1_disk1_build_auth_",t, sep='') # TEST PERIOD
  accts <- dbGetQuery(mydb, sql.accts)
  
  Y <- merge_recurse(list(y_M1008,y_M1707,y_M1883,y_M2168,y_M2203,y_M2493,y_M3123,y_M3126,y_M3172,
                          y_M3342,y_M3437,y_M3456,y_M382,y_M3868,accts), by = "acct_id_code")
  Y[,-1][Y[,-1] > 0] <- 1
  Y[is.na(Y)] <- 0
  Y <- Y[order(Y$acct_id_code),] # order by id code
  nam <- paste("Y", t, sep = "_")
  assign(nam, Y)
  dbWriteTable(mydb, nam, Y)
}


dbWriteTable(mydb, "Static_X", tmp.order )
#dbListFields(mydb, "Static_X_small")
#dbListTables(mydb)

dbDisconnect(mydb)

