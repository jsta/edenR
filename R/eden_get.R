#' getstage
#'@title Retrieve stage data from the EDEN Database
#'@param sites character
#'@param end date in POSIX
#'@param start date in POSIX
#'@export
#'@import httr
#'@importFrom utils read.csv
#'@import RCurl
#'@examples
#'\dontrun{#'
#'
#'\url{http://sofia.usgs.gov/eden/eve/index.php?timeseries_start=2015-05-07&timeseries_end=2015-06-16&site_list[]=NMP&water_level=stage&day_hour=daily&max=5&dry=dry&hydrograph_query=Update+Selection}
#'
#'dt<-getstage(sites="NMP",start="2015-05-07",end="2015-06-15")
#'plot(dt[,1],dt[,2])
#'dt<-getstage(sites="NMP",start="2013-06-15",end="2015-06-15")
#'plot(dt[,1],dt[,2])
#'}

getstage<-function(sites="NMP",start="2013-06-15",end="2015-06-15"){
  
  servfull <- "http://sofia.usgs.gov/eden/eve/index.php"
  
  qy<-list(timeseries_start=start,timeseries_end=end,"site_list[]"=sites,water_level="stage")
  
  res<-httr::GET(servfull,query=qy)
  
  nrec <-as.POSIXct(end)-as.POSIXct(start)
  
  dt <- read.csv(text=httr::content(res,"text"),skip=83,header=FALSE,stringsAsFactors = FALSE)
  dt <- dt[2:nrec, which(apply(dt,2,function(x) mean(nchar(x)))>0)]
  dt <- dt[,which(apply(dt,2,function(x) mean(nchar(x)))>0)]
  
  names(dt) <- c("date","navd88ft","ngvd29ft")
  dt$date   <- as.POSIXct(dt$date)
  dt[,2:3]  <- apply(dt[,2:3],2,as.numeric)
  dt
}    
  


