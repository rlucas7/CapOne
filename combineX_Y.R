################################################################################################################################
# combineX_Y.R
# 11.3.2013
################################################################################################################################
library(gtools)
X_M155 <- read.csv("~/Desktop/X_data/X_M155.csv")
X_M216 <- read.csv("~/Desktop/X_data/X_M216.csv")
X_M218 <- read.csv("~/Desktop/X_data/X_M218.csv")
X_M274 <- read.csv("~/Desktop/X_data/X_M274.csv")
X_M340 <- read.csv("~/Desktop/X_data/X_M340.csv")
X_M410 <- read.csv("~/Desktop/X_data/X_M410.csv")
X_M753 <- read.csv("~/Desktop/X_data/X_M753.csv")
X_M919 <- read.csv("~/Desktop/X_data/X_M919.csv")
X_M1108 <- read.csv("~/Desktop/X_data/X_M1108.csv")
X_M1369 <- read.csv("~/Desktop/X_data/X_M1369.csv")
X_M1444 <- read.csv("~/Desktop/X_data/X_M1444.csv")
X_M1600 <- read.csv("~/Desktop/X_data/X_M1600.csv")
X_M1739 <- read.csv("~/Desktop/X_data/X_M1739.csv")
X_M2024 <- read.csv("~/Desktop/X_data/X_M2024.csv")
X_M2042 <- read.csv("~/Desktop/X_data/X_M2042.csv")
X_M2198 <- read.csv("~/Desktop/X_data/X_M2198.csv")
X_M2295 <- read.csv("~/Desktop/X_data/X_M2295.csv")
X_M2352 <- read.csv("~/Desktop/X_data/X_M2352.csv")
X_M2563 <- read.csv("~/Desktop/X_data/X_M2563.csv")
X_M3497 <- read.csv("~/Desktop/X_data/X_M3497.csv")
X_M3589 <- read.csv("~/Desktop/X_data/X_M3589.csv")
X_M3841 <- read.csv("~/Desktop/X_data/X_M3841.csv")
X_M3892 <- read.csv("~/Desktop/X_data/X_M3892.csv")
X_Val <- read.csv("~/Desktop/X_data/X_Validation.csv")


big_X <- smartbind(X_M155,X_M216,X_M218,X_M274,X_M340,X_M410,X_M753,X_M919,X_M1108,X_M1369,X_M1444,X_M1600,X_M1739,X_M2024,
                       X_M2042,X_M2198,X_M2295,X_M2352,X_M2563,X_M3497,X_M3589,X_M3841,X_M3892)
big_X_unique <- big_X[!duplicated(big_X$acct_id_code),]
big_X_unique[is.na(big_X_unique)] <- 0
write.csv(big_X_unique,'~/Desktop/X_data/all_X.csv')

Y_M155 <- read.csv("~/Desktop/Y_data/Y_155.csv")
Y_M216 <- read.csv("~/Desktop/Y_data/Y_216.csv")
Y_M218 <- read.csv("~/Desktop/Y_data/Y_218.csv")
Y_M274 <- read.csv("~/Desktop/Y_data/Y_274.csv")
Y_M340 <- read.csv("~/Desktop/Y_data/Y_340.csv")
Y_M410 <- read.csv("~/Desktop/Y_data/Y_410.csv")
Y_M753 <- read.csv("~/Desktop/Y_data/Y_753.csv")
Y_M919 <- read.csv("~/Desktop/Y_data/Y_919.csv")
Y_M1108 <- read.csv("~/Desktop/Y_data/Y_1108.csv")
Y_M1369 <- read.csv("~/Desktop/Y_data/Y_1369.csv")
Y_M1444 <- read.csv("~/Desktop/Y_data/Y_1444.csv")
Y_M1600 <- read.csv("~/Desktop/Y_data/Y_1600.csv")
Y_M1739 <- read.csv("~/Desktop/Y_data/Y_1739.csv")
Y_M2024 <- read.csv("~/Desktop/Y_data/Y_2024.csv")
Y_M2042 <- read.csv("~/Desktop/Y_data/Y_2042.csv")
Y_M2198 <- read.csv("~/Desktop/Y_data/Y_2198.csv")
Y_M2295 <- read.csv("~/Desktop/Y_data/Y_2295.csv")
Y_M2352 <- read.csv("~/Desktop/Y_data/Y_2352.csv")
Y_M2563 <- read.csv("~/Desktop/Y_data/Y_2563.csv")
Y_M3497 <- read.csv("~/Desktop/Y_data/Y_3497.csv")
Y_M3589 <- read.csv("~/Desktop/Y_data/Y_3589.csv")
Y_M3841 <- read.csv("~/Desktop/Y_data/Y_3841.csv")
Y_M3892 <- read.csv("~/Desktop/Y_data/Y_3892.csv")


big_Y <- smartbind(Y_M155,Y_M216,Y_M218,Y_M274,Y_M340,Y_M410,Y_M753,Y_M919,Y_M1108,Y_M1369,Y_M1444,Y_M1600,Y_M1739,Y_M2024,
                   Y_M2042,Y_M2198,Y_M2295,Y_M2352,Y_M2563,Y_M3497,Y_M3589,Y_M3841,Y_M3892)
big_Y_unique <- big_Y[!duplicated(big_Y$acct_id_code),]
big_Y_unique[is.na(big_Y_unique)] <- 0
write.csv(big_Y_unique,'~/Desktop/Y_data/all_Y.csv')