library(shinyWidgets)
library(shiny)
library(ggplot2)
library(class)
library(kknn)
library(RMySQL)


#make a conncetion to the database, send querys and recieve the relevant data
con <- dbConnect(RMySQL::MySQL(), dbname = "houses", user="root", password="password", host="127.0.0.1", port=3306)

rs1 <- dbSendQuery(con, "select houses.id, neighborhood.neighborhood, exterior_quality.quality, kitchen_quality.quality, overallQual, totalbsmtsf, grlivingarea, totalrooms, totalcars, 
yearsSinceRemod, garagearea, fullBath, bsmtFullBath, halfBath
from houses 
join kitchen_quality on houses.kitchQual=kitchen_quality.id 
join exterior_quality on houses.exteriorQual=exterior_quality.id
join neighborhood on houses.neighborhood=neighborhood.id;")
?dbFetch

housesImport <- dbFetch(rs1,-1)

rs2 <- dbSendQuery(con, "select salePrice from houses")

housesTrueClass <- dbFetch(rs2,-1)

dbDisconnect(con)

names(housesImport) <- c("Id", "Neighborhood", "ExterQual", "KitchenQual", "OverallQual", "TotalBsmtSF", "GrLivArea", "TotRmsAbvGrd", "GarageCars", "GarageArea", "YrsSinceRemod", "FullBath", "BsmtFullBath", "HalfBath")


#define some function to transform the catergorical variables into numeric
t11 <- function(x){
  if(x=="Northridge"|x=="Northridge Heights"|x=="Stone Brook"){
    x <- 1
  }else if(x=="Briardale"|x=="Brookside"|x=="Edwards"|x=="Iowa DOT and Rail Road"|x=="Meadow Village"|x=="Old Town"){
    x <- 0
  }else{
    x <- 0.5
  }
}

t21 <- function(x){
  if(x == "Excellent"){
    x<-1
  }else if(x == "Good"){
    x <- 0.75
  }else if(x == "Average/Typical"){
    x <- 0.5
  }else if(x == "Fair"){
    x <- 0.25
  }else{
    x <- 0
  }
}

#a function to normalise all numeric fields
FeatureScaling <- function(x){(x-min(x))/(max(x) - min(x))}

#the main logic of the app, which will take in a data entry and return a prediction

Logic<- function(input){

  #make a conncetion to the database, send querys and recieve the relevant data
  con <- dbConnect(RMySQL::MySQL(), dbname = "houses", user="root", password="password", host="127.0.0.1", port=3306)

  rs1 <- dbSendQuery(con, "select houses.id, neighborhood.neighborhood, exterior_quality.quality, kitchen_quality.quality, overallQual, totalbsmtsf, grlivingarea, totalrooms, totalcars, garagearea, yearsSinceRemod, fullBath, bsmtFullBath, halfBath
from houses
join kitchen_quality on houses.kitchQual=kitchen_quality.id
join exterior_quality on houses.exteriorQual=exterior_quality.id
join neighborhood on houses.neighborhood=neighborhood.id;")

  housesImport <- dbFetch(rs1,-1)

  rs2 <- dbSendQuery(con, "select salePrice from houses")

  housesTrueClass <- dbFetch(rs2,-1)

  dbDisconnect(con)

  names(housesImport) <- c("Id", "Neighborhood", "ExterQual", "KitchenQual", "OverallQual", "TotalBsmtSF", "GrLivArea", "TotRmsAbvGrd", "GarageCars", "GarageArea", "YrsSinceRemod", "FullBath", "BsmtFullBath", "HalfBath")




  #define a new variable to use for KKNN
  housesImport$TotalBathrooms <- housesImport$FullBath +housesImport$BsmtFullBath +0.75*housesImport$HalfBath

  #transform catergorical to numeric
  housesImport$Neighborhood <- lapply(housesImport$Neighborhood,t11)
  housesImport$ExterQual <- lapply(housesImport$ExterQual,t21)
  housesImport$KitchenQual <- lapply(housesImport$KitchenQual,t21)

  #choose relevant columns
  housesImport<-housesImport[,c(2,3,4,5,6,7,8,9,10,11,15)]

  housesImport <- as.data.frame(lapply(housesImport,as.numeric))

  housesTrueClass <- as.data.frame(housesTrueClass)


  #once the data is ready for KKNN bind the set of true classifications to them
  #housesImport <- cbind(housesImport, housesTrueClass)

  #choose k value
  K_Value <- floor(sqrt(length(housesImport[,1])))

  #get the new row of inputted data
  testData<-(data.frame(t11(input$neighborhood), t21(input$exterQual), t21(input$kitchQual), input$overallQual, input$totbsmtsf, input$grlivingarea,
                        input$totalrooms, input$totalcars, input$garageArea, input$yearsRemod, (input$fullBathrooms + 0.75*input$halfBathrooms)))
  testData <- lapply(testData, as.numeric)
  names(testData) <- c("Neighborhood", "ExterQual", "KitchenQual", "OverallQual", "TotalBsmtSF", "GrLivArea", "TotRmsAbvGrd", "GarageCars", "GarageArea", "YrsSinceRemod", "TotalBathrooms")

  #normalise data
  housesImport <- rbind(housesImport, testData)
  housesImport <- as.data.frame(lapply(housesImport,FeatureScaling))

  #retrieve the test data again
  testData <- housesImport[length(housesImport[,1]),]

  #format the data for training
  housesImport <- housesImport[c( 1: (length(housesImport[,1])-1) ) ,  ]

  housesImport <- cbind(housesImport, housesTrueClass)


  #train model
  modelKKNNoutput <- train.kknn(salePrice~. ,housesImport, ks=K_Value)

  #get prediction
  prediction <- predict(modelKKNNoutput,testData)

  upperEstimate <- round(prediction*1.1, digits= -3)

  lowerEstimate <- round(prediction*0.9, digits = -3)

  return(c(round(prediction,digits=-3), upperEstimate, lowerEstimate))

}







server <- shinyServer(function(input,output){
  output$Predicted <- renderText({
    paste(c("predicted:", Logic(input)[1]))
  })
  output$Range <- renderText({
    paste(c("range:" , Logic(input)[2:3]))
  })
})


shinyApp(ui=ui, server=server)
