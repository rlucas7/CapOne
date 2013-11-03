################################################################################################################################
# Modeling and Opt Decision.R
# Fits Model and writes out predictions
# 10.31.2013
################################################################################################################################

################################################################################################################################
# Functions
################################################################################################################################
decision_engine <- function(probs, loss_issue = c(25,20,15,10,5,-3), lost_noissue = -1, return_exp =F, return_coup=T){
  pos <- rank(probs, ties.method ='random') %in% 10:14
  max_probs = probs[pos]
  
  redeem5 <- prod(max_probs)
  
  redeem4 <- prod(c((1-max_probs[1]),max_probs[-1])) + prod(c((1-max_probs[2]),max_probs[-2])) +
    prod(c((1-max_probs[3]),max_probs[-3])) +prod(c((1-max_probs[4]),max_probs[-4])) +
    prod(c((1-max_probs[5]),max_probs[-5]))
  
  redeem3 <- prod(c((1-max_probs[c(1,2)]),max_probs[-c(1,2)]))+prod(c((1-max_probs[c(1,3)]),max_probs[-c(1,3)]))+
    prod(c((1-max_probs[c(1,4)]),max_probs[-c(1,4)]))+prod(c((1-max_probs[c(1,5)]),max_probs[-c(1,5)]))+
    prod(c((1-max_probs[c(2,3)]),max_probs[-c(2,3)]))+prod(c((1-max_probs[c(2,4)]),max_probs[-c(2,4)]))+
    prod(c((1-max_probs[c(2,5)]),max_probs[-c(2,5)]))+prod(c((1-max_probs[c(3,4)]),max_probs[-c(3,4)]))+
    prod(c((1-max_probs[c(3,5)]),max_probs[-c(3,5)]))+prod(c((1-max_probs[c(4,5)]),max_probs[-c(4,5)]))
  
  redeem2 <- prod(c((1-max_probs[-c(1,2)]),max_probs[c(1,2)]))+prod(c((1-max_probs[-c(1,3)]),max_probs[c(1,3)]))+
    prod(c((1-max_probs[-c(1,4)]),max_probs[c(1,4)]))+prod(c((1-max_probs[-c(1,5)]),max_probs[c(1,5)]))+
    prod(c((1-max_probs[-c(2,3)]),max_probs[c(2,3)]))+prod(c((1-max_probs[-c(2,4)]),max_probs[c(2,4)]))+
    prod(c((1-max_probs[-c(2,5)]),max_probs[c(2,5)]))+prod(c((1-max_probs[-c(3,4)]),max_probs[c(3,4)]))+
    prod(c((1-max_probs[-c(3,5)]),max_probs[c(3,5)]))+prod(c((1-max_probs[-c(4,5)]),max_probs[c(4,5)]))
  
  redeem1 <- prod(c((1-max_probs[-1]),max_probs[1])) + prod(c((1-max_probs[-2]),max_probs[2])) +
    prod(c((1-max_probs[-3]),max_probs[3])) +prod(c((1-max_probs[-4]),max_probs[4])) +
    prod(c((1-max_probs[-5]),max_probs[5]))
  
  redeem0 <- prod(1-max_probs)
  
  exp_loss <- loss_issue[1]*redeem5 + loss_issue[2]*redeem4 + loss_issue[3]*redeem3 +
    loss_issue[4]*redeem2 + loss_issue[5]*redeem1 + loss_issue[6]*redeem0
    
  response <- rep("No",14)
  
  if (exp_loss > lost_noissue)  {
    response[pos] <- "Yes"
    if (return_coup & ! return_exp) out=response
    if (!return_coup & return_exp) out=exp_loss
    if (return_coup & return_exp) out=list(response,exp_loss)
    if (!return_coup & !return_exp) out=NULL    
    return(out)
  } else {
    if (return_coup & ! return_exp) out=response
    if (!return_coup & return_exp) out=exp_loss
    if (return_coup & return_exp) out=list(response,exp_loss)
    if (!return_coup & !return_exp) out=NULL    
    return(out)
  }
}
################################################################################################################################
# FIT RANDOM FOREST
################################################################################################################################
library(randomForest)

Y <- read.csv("~/Desktop/Y_data/all_Y.csv")
Y <- Y[,-c(1,2)] # drop row names
test_X <- read.csv ("~/Desktop/X_data/all_X.csv")
test_X <- test_X[,-c(1,2)] #drop row names
val_X <- read.csv('~/Desktop/X_data/X_Validation.csv')
val_X <- val_X[,-1]
val_X <- smartbind(test_X[1:5,],val_X) #ensure same variable ordering
val_X <- val_X[-(1:5),] #remove test obs
val_X[is.na(val_X)] <- 0
big_data <- merge(Y,test_X, by ="acct_id_code")
big_data[is.na(big_data)] <- 0
test_labels <- read.csv("~/Desktop/X_data/test_labels.csv")
test_labels <- test_labels[,-1]
val_labels <- read.csv("~/Desktop/X_data/val_labels.csv")
val_labels <- val_labels[,-1]

# Run Models for clusters 1-3
numtrees <- 100
train_set <- merge(big_data,test_labels, by ='acct_id_code')
val_set <- merge(val_X,val_labels, by ='acct_id_code')

tree_names <-c('t_M1008','t_M1707','t_M1883','t_M2168','t_M2203','t_M2493','t_M3123',
               't_M3126','t_M3172','t_M3342','t_M3437','t_M3456','t_M382','t_M3868')
prob_names <-c('probs_M1008_rf','probs_M1707_rf','probs_M1883_rf','probs_M2168_rf','probs_M2203_rf',
               'probs_M2493_rf','probs_M3123_rf','probs_M3126_rf','probs_M3172_rf','probs_M3342_rf',
               'probs_M3437_rf','probs_M3456_rf','probs_M382_rf','probs_M3868_rf') 
s <- Sys.time()
scores <- NULL
for (i in 1:3){
  train <- train_set[train_set$cluster ==i,]
  val <- val_set[val_set$ cluster ==i,]
  for (j in 1:14){
    print(j)
    tr<-randomForest(x=train[,-c(1:15)], y=as.factor(train[,(j+1)]),type="classification", ntree=numtrees)
    assign(tree_names[j],tr)
    pr <- predict(tr,val[,-1],type="prob")
    assign(prob_names[j],pr)
  }
  P<- cbind(probs_M1008_rf[,2],probs_M1707_rf[,2],probs_M1883_rf[,2],probs_M2168_rf[,2],probs_M2203_rf[,2],
           probs_M2493_rf[,2],probs_M3123_rf[,2],probs_M3126_rf[,2],probs_M3172_rf[,2],probs_M3342_rf[,2],
           probs_M3437_rf[,2],probs_M3456_rf[,2],probs_M382_rf[,2],probs_M3868_rf[,2])
  scores <- rbind(scores,cbind(val$acct_id_code,P))
}
Sys.time() - s
 # DONE AROUND 9:15???
################################################################################################################################
# Make Decision
################################################################################################################################

a <- apply(scores[,-1],1, "FUN" =decision_engine)


################################################################################################################################
# FORMAT OUTPUT
################################################################################################################################
score <- (matrix(t(scores[,-1]),ncol=1))
offer <- (matrix(a,ncol=1))
acct_id_code <- rep(scores[,1],each=14)
merchant_codes <- c('M1008','M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456','M382','M3868')
merchant_code <- rep(merchant_codes, dim(a)[2] )
out <- data.frame(acct_id_code,merchant_code,score,offer)
write.csv(out,'~/CapOne/bigout.csv')