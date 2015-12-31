function(url){
  #require(leafletR)
  #devtools::install_github("rstudio/leaflet")
  require(leaflet)
  ## Loading required package: leaflet
  require(data.table)
  ## Loading required package: data.table
  require(dplyr)
  ## Loading required package: dplyr
  ## 
  ## Attaching package: 'dplyr'
  ## 
  ## The following objects are masked from 'package:data.table':
  ## 
  ##     between, last
  ## 
  ## The following object is masked from 'package:stats':
  ## 
  ##     filter
  ## 
  ## The following objects are masked from 'package:base':
  ## 
  ##     intersect, setdiff, setequal, union
  library(sp)
  library(rgdal)
  ## rgdal: version: 0.9-1, (SVN revision 518)
  ## Geospatial Data Abstraction Library extensions to R successfully loaded
  ## Loaded GDAL runtime: GDAL 1.7.3, released 2010/11/10
  ## Path to GDAL shared files: /usr/share/gdal/1.7
  ## GDAL does not use iconv for recoding strings.
  ## Loaded PROJ.4 runtime: Rel. 4.7.1, 23 September 2009, [PJ_VERSION: 470]
  ## Path to PROJ.4 shared files: (autodetected)
  library(maptools)
  ## Checking rgeos availability: TRUE
  library(KernSmooth)
  ## KernSmooth 2.23 loaded
  ## Copyright M. P. Wand 1997-2009
  
  ##theUrl <- "http://abuchel.physics.uwo.ca/~obuchel/angular/john_snow_map/deaths.csv"
  
  theUrl <- url
  
  tomato <-read.table(file=theUrl, header=TRUE, sep =",")
  
  
  
  
  df_deaths <- data.frame(tomato)
  
  coordinates(df_deaths)=~lng1+lat1
  proj4string(df_deaths)=CRS("+init=EPSG:3395") 
  df_deaths = spTransform(df_deaths,CRS("+datum=WGS84"))
  df <- data.frame(tomato)
  na.omit(df)
  lng=df$lng1
  lat=df$lat1
  clr="blue"
  
  library(KernSmooth)
  X=cbind(lng,lat)
  kde2d <- bkde2D(X, gridsize=c(1000,1000), bandwidth=c(bw.ucv(X[,1]),bw.ucv(X[,2])))
  
  
  kde2d[0]
  
  ##kde2d <-stat_density2d(data=df,aes(x=longitude,y=latitude), alpha =0.5, geom="polygon")
  ## Warning in bw.ucv(X[, 1]): minimum occurred at one end of the range
  x=kde2d$x1
  y=kde2d$x2
  z=kde2d$fhat
  CL=contourLines(x,y,z)
  return(CL)

}