library("RMySQL")
drv<-dbDriver("MySQL")
mydb=dbConnect(drv,user='yuhyun',password='yuhyun',host='128.173.212.125',dbname='mysql')
dbListTables(mydb)
dbListFields(mydb,'cap1_disk1_build_auth_M155')


#################################################################
#Frequent Merchant M155/M753/M1739/M2295/M3841/M3892            #
#M753 Not available yet                                         #
#################################################################

#M155:Online department Store
M155=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M155 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M155_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M155 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M155_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M155 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")


#M1739:Home Improvement Centers
#from the original tablem, auth_M1739, the distribution of freq. of trxn by customer id, mean of #trxn=175, 3rd quantile=216 
M1739=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk2_build_auth_M1739 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M1739_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk2_build_auth_M1739 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M1739_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk2_build_auth_M1739 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")


#M3841:General Merchandise Stores/Discount Department Stores
M3841=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3841 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M3841_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3841 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M3841_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3841 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")


#M3892:Grocery and Food Stores
M3892=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3892 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M3892_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3892 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M3892_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk4_build_auth_M3892 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")


#M2295:Eating Place
M2295=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk3_build_auth_M2295 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M2295_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk3_build_auth_M2295 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M2295_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk3_build_auth_M2295 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")



###################################################################
#Moderate Merchant                                                #
###################################################################

#M340:Sporting Goods and Hobby
M340=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M340 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M340_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M340 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M340_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M340 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")


#M410:Consumer Electronics and Computers/Consumer Electronics/Appliances
M410_org=dbGetQuery(mydb,"SELECT * from cap1_disk1_build_auth_M410 where trxn_amount>=200")

M410=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M410 GROUP By acct_id_code")
#merchant_zip5=customer_zip5
M410_1=dbGetQuery(mydb,"SELECT acct_id_code,sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M410 WHERE merchant_zip5=customer_zip5 GROUP By acct_id_code")
#merchant_zip5!=customer_zip5
M410_2=dbGetQuery(mydb,"SELECT acct_id_code, sum(trxn_amount), count(trxn_amount),sum(internet_trxn), count(internet_trxn),sum(internet_trxn)/count(internet_trxn) as prop,customer_zip5,merchant_zip5 from cap1_disk1_build_auth_M410 WHERE merchant_zip5!=customer_zip5 GROUP By acct_id_code")

write.table(M340,"M340.txt")
write.table(M2295,"M2295.txt")
write.table(M3892,"M3892.txt")
write.table(M3841,"M3841.txt")
write.table(M1739,"M1739.txt")
write.table(M155,"M155.txt")

