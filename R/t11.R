#'Transform categorical to normalised numeric on the Iowa houses db Neighborhoods
#'
#'This function will return a number between 0 and 1.
#'This depends on whether the neighborhood is high class, medium class, or lower class.
#'@param neighborhood
#'A valid Iowa homes neighborhood.
#'@return 0, 0.5 or 1
#'@examples
#'t11("Northridge")
#'@export

t11 <- function(x){
  if(x=="Northridge"|x=="Northridge Heights"|x=="Stone Brook"){
    x <- 1
  }else if(x=="Briardale"|x=="Brookside"|x=="Edwards"|x=="Iowa DOT and Rail Road"|x=="Meadow Village"|x=="Old Town"){
    x <- 0
  }else{
    x <- 0.5
  }
}
