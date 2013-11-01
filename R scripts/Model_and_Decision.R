################################################################################################################################
# Modeling and Opt Decision.R
# Creates Y Matrix
# 10.31.2013
################################################################################################################################

################################################################################################################################
# Functions
################################################################################################################################
decision_engine <- function(probs, loss_issue = c(25,20,15,10,5,-3), lost_noissue = -1){
  max_probs = tail(sort(probs),5)
  
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
  
  max_probs = tail(sort(pr),5)
  
  if (exp_loss > lost_noissue)  {
    pos <- (1:14)[pr %in% max_probs]
    response <- rep("No",14)
    response[pos] <- "Yes"
    return(list(response,exp_loss))
  } else {
    return(list(response,exp_loss))
  }
}
################################################################################################################################
# FIT RANDOM FOREST
################################################################################################################################
library(randomForest)
library(RMySQL)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
Y <- dbGetQuery(mydb, "SELECT * from Y")
static_X <- dbGetQuery(mydb, "SELECT * from static_X")
big_data <- merge(Y,static_X, by ="acct_id_code")
big_data[is.na(big_data)] <- 0

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t<-randomForest(x=big_data[,-c(1,2)], y=as.factor(big_data[,2]),type="classification", ntree=5)
Sys.time() - s
probs <- predict(t,big_data[10000:11000,-c(1,2)],type="prob")

################################################################################################################################
# Make Decision
################################################################################################################################
a <- decision_engine(pr, loss_issue = c(25,20,15,10,5,-3), lost_noissue = -1);a
