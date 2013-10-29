################################################################################################################################
# SQL_Commands.R
# 10.25.2013
################################################################################################################################

# Intialize DataBase
install.packages("RMySQL") 
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
dbListTables(mydb)
dbListTables(mydb, "cap1 disk1 build_auth_155")
relevant_ids <- dbGetQuery(mydb, "SELECT count(distinct acct_id_code) from mysql.SMC_Data")
relevant_merchants <- dbGetQuery(mydb, "SELECT distinct merchant_code from mysql.SMC_Data")
merchant_metrics <- dbGetQuery(mydb, "SELECT * from mysql.cap1_disk1_merchant_metrics where merchant_code in 
                  ('M1008','M1707','M1883','M2168','M3868')")
merchant_type <- dbGetQuery(mydb, "SELECT distinct Industry_Name, merchant_code from mysql.cap1_disk4_validation_auth where merchant_code 
                in ('M1008','M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456','M382','M3868')")

merchant_type2 <- dbGetQuery(mydb, "SELECT distinct Industry_Name, merchant_code from mysql.cap1_disk1_build_auth_M155 where merchant_code 
                in ('M1008','M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456','M382','M3868')")



dbDisconnect(mydb)

