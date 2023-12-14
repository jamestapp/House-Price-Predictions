#'Transform categorical to normalised numeric on a levelled rating system.
#'
#'This function will return a number between 0 and 1.
#'This depends on whether the entry is Excellent(1) to Poor(0).
#'@param Rating
#'A valid rating, either "Excellent", "Good", "Average/Typical", "Fair" or "Poor"
#'@return 0, 0.25, 0.5, 0.75, 1
#'@examples
#'t21("Excellent")
#'@export

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
