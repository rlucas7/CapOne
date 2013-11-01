################################################################################################################################
# Modeling and Opt Decision.R
# Creates Y Matrix
# 10.31.2013
################################################################################################################################

################################################################################################################################
# Functions
################################################################################################################################
probs = P[3,]
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
library(RMySQL)
library(glmnet)
drv <- dbDriver("MySQL")
mydb <- dbConnect(drv, user='andy', password='andy', dbname='mysql', host='128.173.212.125')
Y <- read.csv("~/CapOne/Y.csv")
Y <- Y[,-c(1,2)] # drop row names
static_X <- read.csv ("~/CapOne/static_X.csv")
static_X <- static_X[,-c(1,2)]
big_data <- merge(Y,static_X, by ="acct_id_code")
big_data[is.na(big_data)] <- 0

test_size = 13000
test_set_pos <- sample(dim(big_data)[1],test_size)
test_set <- big_data[test_set_pos,]
train_set <- big_data[-test_set_pos,]


s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M1008<-randomForest(x=train_set[,-c(1,2)], y=as.factor(train_set[,2]),type="classification", ntree=10)
Sys.time() - s
probs_M1008_rf <- predict(t_M1008,test_set[,-c(1,2)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M1707<-randomForest(x=train_set[,-c(1,3)], y=as.factor(train_set[,3]),type="classification", ntree=10)
Sys.time() - s
probs_M1707_rf <- predict(t_M1707,test_set[,-c(1,3)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M1883<-randomForest(x=train_set[,-c(1,4)], y=as.factor(train_set[,4]),type="classification", ntree=10)
Sys.time() - s
probs_M1883_rf <- predict(t_M1883,test_set[,-c(1,4)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M2168<-randomForest(x=train_set[,-c(1,5)], y=as.factor(train_set[,5]),type="classification", ntree=10)
Sys.time() - s
probs_M2168_rf <- predict(t_M2168,test_set[,-c(1,5)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M2203<-randomForest(x=train_set[,-c(1,6)], y=as.factor(train_set[,6]),type="classification", ntree=10)
Sys.time() - s
probs_M2203_rf <- predict(t_M2203,test_set[,-c(1,6)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M2493<-randomForest(x=train_set[,-c(1,7)], y=as.factor(train_set[,7]),type="classification", ntree=10)
Sys.time() - s
probs_M2493_rf <- predict(t_M2493,test_set[,-c(1,7)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3123<-randomForest(x=train_set[,-c(1,8)], y=as.factor(train_set[,8]),type="classification", ntree=10)
Sys.time() - s
probs_M3123_rf <- predict(t_M3123,test_set[,-c(1,8)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3126<-randomForest(x=train_set[,-c(1,9)], y=as.factor(train_set[,9]),type="classification", ntree=10)
Sys.time() - s
probs_M3126_rf <- predict(t_M3126,test_set[,-c(1,9)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3172<-randomForest(x=train_set[,-c(1,10)], y=as.factor(train_set[,10]),type="classification", ntree=10)
Sys.time() - s
probs_M3172_rf <- predict(t_M3172,test_set[,-c(1,10)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3342<-randomForest(x=train_set[,-c(1,11)], y=as.factor(train_set[,11]),type="classification", ntree=10)
Sys.time() - s
probs_M3342_rf <- predict(t_M3342,test_set[,-c(1,11)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3437<-randomForest(x=train_set[,-c(1,12)], y=as.factor(train_set[,12]),type="classification", ntree=10)
Sys.time() - s
probs_M3437_rf <- predict(t_M3437,test_set[,-c(1,12)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3456<-randomForest(x=train_set[,-c(1,13)], y=as.factor(train_set[,13]),type="classification", ntree=10)
Sys.time() - s
probs_M3456_rf <- predict(t_M3456,test_set[,-c(1,13)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M382<-randomForest(x=train_set[,-c(1,14)], y=as.factor(train_set[,14]),type="classification", ntree=10)
Sys.time() - s
probs_M382_rf <- predict(t_M382,test_set[,-c(1,14)],type="prob")
s <- Sys.time()

s <- Sys.time()
# NEED TO ADD PREDICTIONS FOR ALL Y's
t_M3868<-randomForest(x=train_set[,-c(1,15)], y=as.factor(train_set[,15]),type="classification", ntree=10)
Sys.time() - s
probs_M3868_rf <- predict(t_M3868,test_set[,-c(1,15)],type="prob")
s <- Sys.time()

P <- cbind(probs_M1008_rf[,2],probs_M1707_rf[,2],probs_M1883_rf[,2],probs_M2168_rf[,2],probs_M2203_rf[,2],
           probs_M2493_rf[,2],probs_M3123_rf[,2],probs_M3126_rf[,2],probs_M3172_rf[,2],probs_M3342_rf[,2],
           probs_M3437_rf[,2],probs_M3456_rf[,2],probs_M382_rf[,2],probs_M3868_rf[,2])

################################################################################################################################
# Make Decision
################################################################################################################################

a <- apply(P,1, "FUN" =decision_engine)
exp_value <- apply(P,1, "FUN" =decision_engine, return_exp =T, return_coup=F)

not_issuing <-apply(t(a) =='No', 1, sum) == 14


realized_value <- apply(t(a =='Yes')*test_set[,2:15],1,sum)
realized_value <- realized_value * 5
realized_value[not_issuing] <- -1 
#realized_value[realized_value == 0] <- -3
#plot(exp_value,realized_value,xlim=c(-3,25),ylim=c(-3,25))

################################################################################################################################
# FORMAT OUTPUT
################################################################################################################################
score <- (matrix(t(P),ncol=1))
offer <- (matrix(a,ncol=1))
acct_id_code <- rep(test_set_pos,each=14)
merchant_codes <- c('M1008','M1707','M1883','M2168','M2203','M2493','M3123','M3126','M3172','M3342','M3437','M3456','M382','M3868')
merchant_code <- rep(merchant_codes,test_size )
out <- data.frame(acct_id_code,merchant_code,score,offer)
write.csv(out,'~/CapOne/sampleout.csv')