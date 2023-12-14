library(shinyWidgets)
library(shiny)
library(ggplot2)
library(class)
library(kknn)
library(RMySQL)



ui <- shinyUI(fluidPage(
  titlePanel("Iowa Move Price Estimate"),
  #defines inputs and outputs
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "totbsmtsf", label = "Total Basement Surface Area", value = 0, min = 0, step = 1),
      numericInput(inputId = "grlivingarea", label = "Above Grade Living Area", value = 0, min = 0, step = 1),
      numericInput(inputId = "totalrooms", label = "Total Rooms Above Grade", value = 0, min = 0, step = 1),
      numericInput(inputId = "totalcars", label = "Total Cars in Garage", value = 0, min = 0, step = 1),
      numericInput(inputId = "garageArea", label = "Garage Area", value = 0, min = 0, step = 1),
      numericInput(inputId = "fullBathrooms", label = "Number of Full Bathrooms", value = 0, min = 0, step = 1),
      numericInput(inputId = "halfBathrooms", label = "Number of Half Bathrooms Above Grade", value = 0, min = 0, step = 1),
      numericInput(inputId = "yearsRemod", label = "Years Since Last Remodelled", value = 0, min = 0, step = 1),
      sliderInput(inputId = "overallQual", label = "Overall Quality", min = 0, value = 0, step = 1, max = 10),
      selectInput(inputId = "neighborhood", label = "Neighborhood", choices = c("Bloomington Heights", "Bluestem", "Briardale", "Brookside", "Clear Creek", "College Creek", "Crawford", "Edwards", "Gilbert", "Iowa DOT and Rail Road", "Meadow Village", "Mitchell", "North Ames", "Northridge", "Northpark Villa", "Northridge Heights", "Northwest Ames", "Old Town", "South & West of Iowa State University", "Sawyer", "Sawyer West", "Somerset", "Stone Brook", "Timberland", "Veenker")),
      sliderTextInput(inputId = "exterQual", label = "Exterior Quality", choices = c("Excellent", "Good", "Average/Typical", "Fair", "Poor")),
      sliderTextInput(inputId = "kitchQual", label = "Kitchen Quality", choices = c("Excellent", "Good", "Average/Typical", "Fair", "Poor"))
      
    ),
    mainPanel(
      
      textOutput(outputId = "Predicted"),
      textOutput(outputId = "Range"),
      plotOutput(outputId = "Ploty")
    )
  )
)
)