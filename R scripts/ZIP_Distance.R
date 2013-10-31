zipcode <- '~/zipcode_1.0.tar.gz'
install.packages(zipcode,type='source')
library(zipcode)

data(zipcode)

distance <- function(pt1,pt2){
  # distance returns the distance between two GPS coordinates, pt1 and pt2
  # based on info from: http://www.movable-type.co.uk/scripts/latlong.html
  
  lat1 <- pt1[2]/180*pi
  lat2 <- pt2[2]/180*pi
  lon1 <- pt1[1]/180*pi
  lon2 <- pt2[1]/180*pi
  
  a <- sin((lat2-lat1)/2)^2+cos(lat1)*cos(lat2)*sin((lon2-lon1)/2)^2
  c <- 2*atan2(sqrt(a),sqrt(1-a))
  
  R <- 6371 # average radius of the earth
  
  return(R*c)
  
}

zip_distance <- function(zip1,zip2,data=zipcode){
	# returns the distance in km between two zip centroids
	
	pt1 <- as.numeric(data[data$zip==zip1,4:5])
	pt2 <- as.numeric(data[data$zip==zip2,4:5])
	system("say Marcos is a dud")
	return(distance(pt1,pt2))
	}
	
##################################################
######### Create Merchant ZIP Codes ##############
##################################################

install.packages("RMySQL") 
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='marcos', password='marcos', dbname='mysql', host='128.173.212.125')

dbListTables(mydb)
relevant_merchants <- dbGetQuery(mydb, "SELECT distinct merchant_code from mysql.SMC_Data")

table_names <- dbListTables(mydb)[(2:25)[-7]]

merchant_zips <- NULL

for(i in 1:length(table_names)){
	
	tmp_table <- table_names[i]
	SQL_command <- paste("SELECT distinct merchant_zip5, merchant_code from mysql.", tmp_table," where merchant_code in ('M1008','M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456','M382','M3868') group by merchant_code", sep="")
	
	merchant_zips <- unique(rbind(merchant_zips,dbGetQuery(mydb,SQL_command)))
	print(i)
	
	}
	

dbRemoveTable(mydb,'relevant_merchant_zips')
dbWriteTable(mydb,'relevant_merchant_zips',merchant_zips[order(merchant_zips[,2]),],row.names=FALSE)

dbClearResult(dbListResults(mydb)[[1]])
dbDisconnect(mydb)