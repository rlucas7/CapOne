out <- read.csv('~/CapOne/bigout.csv')
out_little <- read.csv("~/Dropbox/littleout.csv")
final_out <- rbind(out[,1],out_little[,-1])
write.csv(final_out,'~/CapOne/SMC_Output_30.csv')
