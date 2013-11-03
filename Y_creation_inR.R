################################################################################################################################
# Y_creation_inR.R
# Creates Y Matrix
# 10.30.2013
################################################################################################################################
get_y = function(id, transactions, target_merchants){
  sub <- transactions[transactions$acct_id_code == id,]
  out = rep(0,14)
  for (i in 1:14){
    out[i] =target_merchants[i] %in% sub$merchant_code
  }
  return(out)
}
all.vals <- c("~/Desktop/M1108.csv","~/Desktop/M1369.csv","~/Desktop/M1444.csv","~/Desktop/M1600.csv","~/Desktop/M1739.csv")
file.vals <- c("Y_1108","Y_1369","Y_1444","Y_1600","Y_1739")
file.out.vals <- c("~/Desktop/Y_data/Y_1108.csv","~/Desktop/Y_data/Y_1369.csv","~/Desktop/Y_data/Y_1444.csv",
                   "~/Desktop/Y_data/Y_1600.csv","~/Desktop/Y_data/Y_1739.csv")
for (i in 1:5){
  all <- read.csv(all.vals[i])
  file <- file.vals[i]
  file.out = file.out.vals[i]
  target_merchants <- c("M1008",'M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456',
                        'M382','M3868')
  
  Y_period <-all[substr(all$trxn_date,3,5) %in% c('JUL','AUG','SEP') & substr(all$trxn_date,8,9) %in% c('11') & all$merchant_code %in% target_merchants,]
  
  ################################################################################################################################
  # CREATE VARIABLES
  ################################################################################################################################

  
  customers <- unique(all$acct_id_code)
  Y_out = sapply(customers,get_y, transactions=Y_period, target_merchants = target_merchants)
  Y_out = cbind(customers, t(Y_out))  
  colnames(Y_out) = c("acct_id_code",'y_M1008','y_M1707','y_M1883','y_M2168','y_M2203','y_M2493','y_M3123','y_M3126','y_M3172',
                      'y_M3342','y_M3437','y_M3456','y_M382','y_M3868')
  assign(file,Y_out)
  write.csv(Y_out,file.out)
}
system("say I am done")