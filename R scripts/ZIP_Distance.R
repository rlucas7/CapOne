zipcode <- '~/zipcode_1.0.tar.gz'
install.packages(zipcode,type='source')
library(zipcode)

data(zipcode)

distance <- function(pt1,pt2){
  # distance returns the distance between two GPS coordinates, pt1 and pt2
  # based on info from: http://www.movable-type.co.uk/scripts/latlong.html
  
  lat1 <- pt1[2]/180*pi
  lat2 <- pt2[2]/180*pi
  lon1 <- pt1[1]/180*pi
  lon2 <- pt2[1]/180*pi
  
  a <- sin((lat2-lat1)/2)^2+cos(lat1)*cos(lat2)*sin((lon2-lon1)/2)^2
  c <- 2*atan2(sqrt(a),sqrt(1-a))
  
  R <- 6371 # average radius of the earth
  
  return(R*c)
  
}

