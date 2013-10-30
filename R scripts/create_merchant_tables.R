### 
###	Code that writes tables for each specific merchant iterating across 
### all merchants and 24 tables creating 14 tables
### where one table is all the information for each specific merchants 
###
###
###
###========================================================



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

###===========================================

#first get a list of all account_ids 

#then scroll through the 23 databases until the first time you find 

#the database, then output that data to the file and loop over the 

# the customers in the separate customer table. 



####=========================================

# for loop that creates the tables in Razor SQL 

table_names<-c("M155","M216","M218","M274","M340", "M410", "M1108", "M1369","M1444", "M1600", "M1739","M753", "M919", "M2024","M2042", "M2198", "M2295", "M2352", "M2563", "M3497", "M3589", "M3841")

for(i in 1:14){
	# code to iterate over merchants...
	
	for(1:23){
		# code to iterate over tables...
		fuck_shit<-paste("cap1_disk1_build_auth_", table_names[i],sep="")
		dbGetQuery(mydb, paste("SELECT * FROM",fuck_shit, "WHERE merchant_code=''") )
	}
	
	
	
}