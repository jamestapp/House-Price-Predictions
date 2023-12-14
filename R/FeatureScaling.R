#'Transform a numeric vector into a normalised vector of values between 0 and 1
#'
#'This function will return a vector between 0 and 1.
#'@param Vector
#'A Vector of numeric values.
#'@return A normalised vector of numeric values between 0 and 1.
#'@examples
#'FeatureScaling(c(252,325,39,103))
#'@export

FeatureScaling <- function(x){(x-min(x))/(max(x) - min(x))}
