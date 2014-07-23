library(shiny)
library(ggplot2)
library(RCurl)

# Here we put the processing code

# Distance in kilometers between two points defined as longitud, latitud.
# The first parameter p1 is a vector with two values.
# The second parameter p2 should be a data.frame or matrix with two columns: latitude, longitude
distance <- function (p1, p2) {  
  dist <- matrix(0,nrow(p2),1)
  for (i in 1:nrow(p2)) {
    pr1 <- c(p1[1]*pi/180, p1[2]*pi/180)
    pr2 <- c(p2[i,1]*pi/180, p2[i,2]*pi/180)
    dx <- abs(pr1[1]-pr2[1])
    dy <- abs(pr1[2]-pr2[2])
  
    a <- (sin(dx/2)^2 + cos(pr1[1]))*cos(pr2[1])*sin(dy/2)^2
    c <- 2 * atan(sqrt(a)/sqrt(1-a))
    d = 6371 * c
    dist[i] <- d
  }
  
  return (as.data.frame(dist))
}

# This function divides the table theTable from
# two columns to 4 columns.
expandTable <- function(theTable) {
  
  numfil <- nrow(theTable)
  
  if(numfil==1) {
    t <- theTable
  } else {
    h <- round(numfil / 2)
    t1 <- theTable[1:h,]
    t2 <- theTable[(h+1):numfil,]
    if((numfil/2) != round(numfil/2)) {
      t2[,1] <- as.character(t2[,1])
      t2[,2] <- as.character(t2[,2])
      t2 <- rbind(t2,c("",""))
    }
    t <- cbind(t1,t2)
    colnames(t) <- c("YEAR","INJURIES/FATALITIES","YEAR","INJURIES/FATALITIES")
  }  
  return(t)
} 

# Read the dataSet: from my directory in github
#urlfile<-"https://raw.github.com/alberto-hevia/Developing_Product/master/StormData.txt"
#dataSet<-read.csv(url(urlfile))
dataSet <- read.csv(file = "StormData.txt", stringsAsFactors = FALSE, sep = ",")

dataSet[,"LATITUDE"] <- dataSet[,"LATITUDE"]/100
dataSet[,"LONGITUDE"] <- dataSet[,"LONGITUDE"]/100

shinyServer(
  function(input,output) {
    output$oLatLon <- renderPrint({paste("Latitude: ",input$Lat," , Longitude: ",input$Lon,sep="")})
    output$exgraph <- renderPlot({
    rad <- input$Rad
    
    # let's filter between two dates
    fdate <- as.Date(input$fdate,"%d-%m-%Y")
    tdate <- as.Date(input$tdate,"%d-%m-%Y")
    
    dataSet <- subset(dataSet,as.Date(as.character(dataSet$BGN_DATE),"%m/%d/%Y") >= fdate &
                        as.Date(as.character(dataSet$BGN_DATE),"%m/%d/%Y") <= tdate)

    if(nrow(dataSet)>0) {
      p1 <- c(input$Lat,input$Lon)
      p2 <- subset(dataSet, (dataSet$INJURIES + dataSet$FATALITIES) > 0,
                   select=c("LATITUDE","LONGITUDE"))
      
      # This function obtains the distance for each of the rows of the dataSet
      dist <- distance(p1,p2)
      colnames(dist) <- "DISTANCE"
      
      # Let's add the distance from the current point to each of the points in the dataSet
      dataSet <- cbind(dataSet,dist)
    
      data.inRadius <- subset(dataSet,dataSet$DISTANCE <= rad)

      # Let's add one column with the total harmful
      data.inRadius <- data.frame(data.inRadius, 
                                HARMFUL = (data.inRadius$FATALITIES + data.inRadius$INJURIES) )
      
      # Let's add one column with the year
      data.inRadius <- data.frame(data.inRadius,
                                 YEAR=format(strptime(data.inRadius$BGN_DATE,"%m/%d/%Y"),"%Y"))
      harmfulByYear <- aggregate(HARMFUL ~ YEAR, data.inRadius, sum)
    
      g <- ggplot(harmfulByYear, aes(x=YEAR, y=HARMFUL))
      p <- g + geom_point(aes(group=1), size=4,alpha=1/2) + 
               geom_line(aes(group=1), size=1,alpha=1/2) +
               labs(x = "Year", y="Number of Fatalities/Injuries",
               title="Total fatalities and injuries per year") +
               geom_smooth(aes(group=1),method="lm") 
      plot(p)

      output$oSummary <- renderPrint({expandTable(harmfulByYear)})      
    }
    
    })
  }
)