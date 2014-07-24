library(shiny)

shinyUI(pageWithSidebar(
          headerPanel("Harmful Events in USA from 2000 to 2010"),          
          sidebarPanel(
          numericInput("Lat","Latitude:",34.05, min = 0, max = 70),
          numericInput("Lon","Longitude:", 118.24, min = 0, max = 160),
          
          helpText("Latitude and longitude (above) indicates the position of the location in the map.",
                   "Only those events closer than the Radius in kilometeres (below) from the location will be taken into account"),
          
          sliderInput("Rad","Radius (in kilometers):", value = 500, min=1, max = 5000, step = 10),
          
          dateInput("fdate","From date:", 
                    value = as.Date("2000-01-01","%Y-%m-%d"), 
                    min = as.Date("2000-01-01","%Y-%m-%d"),
                    max = as.Date("2000-12-31","%Y-%m-%d"),
                    format = "dd-mm-yyyy"
                   ),
          dateInput("tdate","To date:",
                    value = as.Date("2010-12-31","%Y-%m-%d"), 
                    min = as.Date("2000-01-01","%Y-%m-%d"),
                    max = as.Date("2000-12-30","%Y-%m-%d"),
                    format = "dd-mm-yyyy"
                    ),
          helpText("These dates are used to restrict the period of time you want to evaluate.",
                   "By default the period is between 01/01/2000 and 31/12/2010"),
          p(". "),
          p("Data obtained from Atmospheric Administration (NOAA)."),
          p("More information in: http://www.nws.noaa.gov")
          ),
        mainPanel (
          plotOutput('exgraph'),
          p("Summary"),
          verbatimTextOutput("oSummary")
        )
  ) )
  