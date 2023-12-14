#install.packages("RMySQL")
library(RMySQL)

setwd('C:/Users/Admin/Downloads')

houses <- read.csv('train.csv',header=TRUE)

t3 <- function(x){
  if(x == "Blmngtn"){
    x <- 1
  }else if(x=="Blueste"){
    x<-2
  }else if(x == "BrDale"){
    x <- 3
  }else if(x=="BrkSide"){
    x <- 4
  }else if(x=="ClearCr"){
    x <- 5
  }else if(x=="CollgCr"){
    x <-6
  }else if(x=="Crawfor"){
    x <-7
  }else if(x=="Edwards"){
    x <-8
  }else if(x=="Gilbert"){
    x<-9
  }else if(x=="IDOTRR"){
    x<-10
  }else if(x=="MeadowV"){
    x <- 11
  }else if(x=="Mitchel"){
    x<-12
  }else if(x == "NAmes"){
    x <-13 
  }else if(x=="NoRidge"){
    x <- 14
  }else if(x=="NPkVill"){
    x <- 15
  }else if(x=="NridgHt"){
    x <-16
  }else if(x=="NWAmes"){
    x <-17
  }else if(x=="OldTown"){
    x <-18
  }else if(x=="SWISU"){
    x<-19
  }else if(x=="Sawyer"){
    x<-20
  }else if(x=="SawyerW"){
    x <- 21
  }else if(x=="Somerst"){
    x <-22
  }else if(x=="StoneBr"){
    x <-23
  }else if(x=="Timber"){
    x<-24
  }else if(x=="Veenker"){
    x<-25
  }
}

t4 <- function(x){
  if(x == "Ex"){
    x<-5
  }else if(x == "Gd"){
    x <- 4
  }else if(x == "TA"){
    x <- 3
  }else if(x == "Fa"){
    x <- 2
  }else{
    x <- 1
  }
}

houses$YrsSinceRemod <- houses$YrSold - houses$YearRemodAdd
houses$TotalBathrooms <- houses$FullBath +houses$BsmtFullBath +0.75*houses$HalfBath

housesMySQL <- houses[,c(1,13,28,54,18,39,47,55,62,63,82,50,48,51,81)]
someNames <- names(housesMySQL)
names(housesMySQL)  <- c("id", "neighborhood", "exteriorQual", "kitchQual", "overallQual", "totalbsmtsf", "grlivingarea", "totalrooms", "totalcars", "garagearea", "yearsSinceRemod", "fullBath", "bsmtFullBath", "halfBath", "salePrice")

housesMySQL$neighborhood <- lapply(housesMySQL$neighborhood,t3)
housesMySQL$kitchQual <- lapply(housesMySQL$kitchQual,t4)
housesMySQL$exteriorQual <- lapply(housesMySQL$exteriorQual,t4)

housesMySQL <- as.data.frame(lapply(housesMySQL,as.numeric))


con <- dbConnect(RMySQL::MySQL(), dbname = "houses", user="root", password="10038Sh1mSh4m")
#con <- (user = "root", password="password", db_name="houses", host="127.0.0.1", port=3306)




?dbWriteTable
#dbWriteTable(con, "houses", housesMySQL, overwrite=TRUE, row.names=FALSE)
#dbListTables(con)



dbDisconnect(con)

?names
