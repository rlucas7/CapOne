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

#first get a list of all unique account_ids, 1 for each account. make a table of this in SQL 

table_names<-c("cap1_disk1_build_auth_M155",  "cap1_disk1_build_auth_M216" , "cap1_disk1_build_auth_M218" , "cap1_disk1_build_auth_M274",  "cap1_disk1_build_auth_M340",  "cap1_disk1_build_auth_M410",   "cap1_disk2_build_auth_M1108", "cap1_disk2_build_auth_M1369", "cap1_disk2_build_auth_M1444" ,"cap1_disk2_build_auth_M1600","cap1_disk2_build_auth_M1739", "cap1_disk2_build_auth_M753",  "cap1_disk2_build_auth_M919" , "cap1_disk3_build_auth_M2024", "cap1_disk3_build_auth_M2042" ,"cap1_disk3_build_auth_M2198","cap1_disk3_build_auth_M2295", "cap1_disk3_build_auth_M2352" ,"cap1_disk3_build_auth_M2563", "cap1_disk3_build_auth_M3497" ,"cap1_disk4_build_auth_M3589" ,"cap1_disk4_build_auth_M3841","cap1_disk4_build_auth_M3892")
length(table_names)

mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')


 	# for(i in 1:23){
		# # code to iterate over tables...
		# fuck_shit<-table_names[i]
		# table<-dbGetQuery(mydb, paste("SELECT distinct acct_id_code FROM",fuck_shit ) )
		
		# if(i==1){ # first case, here we need to initialize structure 
		# distinct_accounts<-table	
		# }else{ # here just bind the results together
		# distinct_accounts<-rbind(table, distinct_accounts)			
		# }

	# }
# dbWriteTable(mydb, name="distinct_accounts", value=distinct_accounts)	


#then scroll through the 23 databases until the first time you find the distinct account in
#the database, then output that data to the dataframe and loop over the distinct accounts 

# temp file comment this line out after ur done...
distinct_accounts<-dbGetQuery(mydb, paste("SELECT * FROM distinct_accounts"))
distinct_accounts<-distinct_accounts[,2]



for(i in 1:(length(distinct_accounts)) ){
	b_flag<-TRUE
	j<-1
	while(b_flag){
		if( j >23){# end of the string  
			b_flag<-FALSE
			}else{
				output<-dbGetQuery(mydb, paste("SELECT * FROM",table_names[j], "WHERE acct_id_code =   " , distinct_accounts[i], " " ))
				final_data<-0
				if(length(output)>0){ # append data
					final_data<-rbind(final_data, output)
					b_flag<-FALSE
					}else{ # there was no match in that file, simple move ahead
							j<-j+1
					}# end of inner else condition
				
			}# end of outer else condition
	}# end of while loop 
#	system("say dude Im done")
} # end of for loop
#create the customers in a separate customer table. 

system("say dude Im done")


####=========================================