################################################################################################################################
# varCreation_inR_forVal.R
# creates `X' matrix, given a datafile
# runtime: 25 minutes on macBook Pro per files
# 11.3.2013
################################################################################################################################
#read data
#library(reshape)
t=Sys.time()

all <- read.csv("~/Desktop/M3841.csv")
head(all)

file.out = "~/Desktop/X_M3841.csv"
################################################################################################################################
# FUNCTIONS
################################################################################################################################
in_zips_shop <- function(id,pairs,merchant_zips){
  merch_z = pairs[pairs$acct_id_code == id,]
  out = rep(0,14)
  for (i in 1:14){
    out[i] <-  as.numeric(sum(merch_z[,2] %in% merchant_zips[[i]]) >0)
  }
  return(out)
}

in_zips <- function(zip,merchant_zips){
  out = rep(0,14)
  for (i in 1:14){
    out[i] <- as.numeric( zip %in% merchant_zips[[i]])
  }
  return(out)
}

at_industry = function(id, transactions, industry){
  out=rep(0,14)
  by_id <- transactions[transactions$acct_id_code == id,]
  for (i in 1:14){
    out[i] <- as.numeric(dim(by_id[by_id$Industry_Name ==industry[i],])[1] >0)
  }
  return(out)
}

at_industry_zip = function(id, transactions, industry,merchant_zips){
  out=rep(0,14)
  by_id <- transactions[transactions$acct_id_code == id,]
  for (i in 1:14){
    out[i] <- as.numeric(dim(by_id[by_id$Industry_Name ==industry[i] & (by_id$merchant_zip %in% merchant_zips[[i]]),])[1] >0)
  }
  return(out)
}
################################################################################################################################
# CREATE STATIC VARIABLES for VALIDATION SET
################################################################################################################################
s=Sys.time()
purchase_online <- aggregate(all$internet_trxn, by=list(all$acct_id_code), 'FUN' = mean)
colnames(purchase_online) <- c("acct_id_code","online_prob")
Sys.time()-s

s=Sys.time()
# aggregate purchases by industry
tmp_industry <- aggregate(rep(1,dim(all)[1]), by=list(all$acct_id_code, as.character(all$Industry_Name)), 'FUN' = sum)
colnames(tmp_industry) = c('acct_id_code', 'Industry_Name','n')
industry_counts <- reshape(tmp_industry, v.names = "n", idvar = "acct_id_code", timevar= "Industry_Name",direction="wide",sep="_")
industry_counts[is.na(industry_counts)] <- 0
Sys.time()-s

s=Sys.time()
#total number of purchases
freq_count <- aggregate(rep(1,dim(all)[1]), by=list(all$acct_id_code), 'FUN' = sum)
colnames(freq_count) <- c('acct_id_code','trans_freq')
Sys.time()-s

s=Sys.time()
# number of purchases in previous 3 months
last3 <- subset(all, substr(all$trxn_date,3,5) %in% c('APR','MAY','JUN'))
freq_count_last3 <- aggregate(rep(1,dim(last3)[1]), by=list(last3$acct_id_code), 'FUN' = sum)
colnames(freq_count_last3) <- c('acct_id_code','freq_prev3')
Sys.time()-s

# Number of Merchants and Merchant ZipCodes
num_zips <- aggregate(rep(1,dim(all)[1]), by=list(all$acct_id_code, as.character(all$merchant_zip)), 'FUN' = sum)
zip_count <- aggregate(rep(1,dim(num_zips)[1]),list(num_zips$Group.1),sum)
colnames(zip_count) =c('acct_id_code','Num_ZIP')

num_merch <- aggregate(rep(1,dim(all)[1]), by=list(all$acct_id_code, as.character(all$merchant_code)), 'FUN' = sum)
merchant_count <- aggregate(rep(1,dim(num_merch)[1]),list(num_merch$Group.1),sum)
colnames(merchant_count) =c('acct_id_code','Num_Merchant')

# aggregate purchases by industry
all_online <- subset(all, all$internet_trxn ==1)
tmp_industry_online <- aggregate(rep(1,dim(all_online)[1]), by=list(all_online$acct_id_code, as.character(all_online$Industry_Name)), 'FUN' = sum)
colnames(tmp_industry_online) = c('acct_id_code', 'Industry_Name','n_o')
industry_counts_online <- reshape(tmp_industry_online, v.names = "n_o", idvar = "acct_id_code", timevar= "Industry_Name",
                                  direction="wide",sep='_')
industry_counts_online[is.na(industry_counts_online)] <- 0

# combine `static' variables
tmp <- merge_recurse(list(merchant_count, zip_count, freq_count_last3, freq_count, industry_counts, purchase_online, 
                          industry_counts_online), by = "acct_id_code")
tmp.order <- tmp[order(tmp$acct_id_code),] # order by id code
tmp.order[is.na(tmp.order)] <- 0
static_X <- tmp.order
################################################################################################################################
# CREATE Merchant Specific VARIABLES for VALIDATION SET
################################################################################################################################
# Freq at Target Merchant
target_merchants <- c('M1008','M1707','M1883','M2168','M2203','M2493','M3123',
                      'M3126','M3172','M3342','M3437','M3456','M382','M3868')
at_merch <- all[all$merchant_code %in% target_merchants,]

freq <- aggregate(rep(1,dim(at_merch)[1]),by=list(at_merch$acct_id_code,at_merch$merchant_code),sum)
colnames(freq)=c('acct_id_code','Merchant','Freq')
freq2 <- reshape(freq, v.names = "Freq", idvar = "acct_id_code", timevar= "Merchant",direction="wide",sep="_")
freq2[is.na(freq2)] <- 0

# Live in same Zip as Merchant
for (i in target_merchants){
  small <- (subset(at_merch, at_merch$merchant_code ==i ))
  zips <-as.character(unique(as.character(small$merchant_zip5)))
  nam <- paste('z',i,sep="_") 
  assign(nam, zips)
}
merchant_zips =list(z_M1008,z_M1707,z_M1883,z_M2168,z_M2203,z_M2493,z_M3123,
                    z_M3126,z_M3172,z_M3342,z_M3437,z_M3456,z_M382,z_M3868)
small<-all[!duplicated(paste(all$acct_id_code,all$customer_zip5)),]
a<-strptime(small$trxn_date, '%d%B%Y')
bytime <- small[order(a,decreasing =T),]
customer_zips <- bytime[!duplicated(bytime$acct_id_code),] # retain most recent zip
live_inzip <- sapply(customer_zips$customer_zip5,in_zips, merchant_zips=merchant_zips)
live_inzip <- cbind(customer_zips$acct_id_code,t(live_inzip))
colnames(live_inzip)=c('acct_id_code','live_M1008','live_M1707','live_M1883','live_M2168','live_M2203','live_M2493',
                       'live_M3123','live_M3126','live_M3172','live_M3342','live_M3437','live_M3456','live_M382','live_M3868')

# Shop in same Zip as Merchant
pairs <- unique(all[c("acct_id_code", "merchant_zip5")])
customers <- unique(pairs$acct_id_code)
shop_zip <- sapply(customers,in_zips_shop, pairs=pairs, merchant_zips=merchant_zips) # a bit slow (10 min)
shop_inzip <- cbind(customers,t(shop_zip))
colnames(shop_inzip)=c('acct_id_code','shop_M1008','shop_M1707','shop_M1883','shop_M2168','shop_M2203','shop_M2493',
                       'shop_M3123','shop_M3126','shop_M3172','shop_M3342','shop_M3437','shop_M3456','shop_M382','shop_M3868')

# Shop at industry
industry <- at_merch[!duplicated(at_merch$merchant_code),]
industry <- industry$Industry_Name
industries_only <- all[all$Industry_Name %in% industry,]
industries_only_unique <- unique(industries_only[c("acct_id_code", "Industry_Name")])
s=Sys.time()
shop_industry <- sapply(customers,at_industry, transactions =industries_only_unique, industry =industry)
Sys.time()-s
shop_industry <- cbind(customers,t(shop_industry))
colnames(shop_industry)=c('acct_id_code','shop_ind_M1008','shop_ind_M1707','shop_ind_M1883','shop_ind_M2168','shop_ind_M2203',
                          'shop_ind_M2493','shop_ind_M3123','shop_ind_M3126','shop_ind_M3172','shop_ind_M3342',
                          'shop_ind_M3437','shop_ind_M3456','shop_ind_M382','shop_ind_M3868')

# Shop at industry in zip
industries_zip_unique <- unique(industries_only[c("acct_id_code","merchant_zip5", "Industry_Name")])
s=Sys.time()
shop_industry_zip <- sapply(customers,at_industry_zip, transactions =industries_zip_unique, industry =industry, merchant_zips=merchant_zips)
Sys.time()-s
shop_industry_zip <- cbind(customers,t(shop_industry_zip))
colnames(shop_industry_zip)=c('acct_id_code','shop_ind_zip_M1008','shop_ind_zip_M1707','shop_ind_zip_M1883','shop_ind_zip_M2168',
                              'shop_ind_zip_M2203','shop_ind_zip_M2493','shop_ind_zip_M3123','shop_ind_zip_M3126','shop_ind_zip_M3172',
                              'shop_ind__zipM3342','shop_ind_zip_M3437','shop_ind_zip_M3456','shop_ind_zip_M382','shop_ind_zip_M3868')

################################################################################################################################
# Create Complete X matrix
################################################################################################################################
bigX <- merge_recurse(list(static_X, freq2, live_inzip, shop_inzip, shop_industry,shop_industry_zip), by = "acct_id_code")
bigX_order <- bigX[order(bigX$acct_id_code),] # order by id code
bigX_order[is.na(bigX_order)] <- 0
complete_X <- bigX_order

write.csv(complete_X, file.out)
Sys.time()-t
system("say I am done")