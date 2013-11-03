out <- read.csv('~/CapOne/bigout.csv')
out_little <- read.csv("~/Dropbox/littleout.csv")
final_out <- rbind(out[,-1],out_little[,-1])
final_out <- final_out[order(final_out$acct_id_code),]
write.csv(final_out,'~/CapOne/SMC_Output_30.csv')
