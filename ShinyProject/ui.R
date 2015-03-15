library(shiny)
library(ggplot2)
library(caret)
library(AppliedPredictiveModeling)

data(FuelEconomy)

# Global Variables
cars2010 <- cars2010[order(cars2010$EngDispl),]
cars2011 <- cars2011[order(cars2011$EngDispl),]

cars2010a <- cars2010
cars2010a$Year <- "2010 Model Year"
cars2011a <- cars2011
cars2011a$Year <- "2011 Model Year"

plotData <- rbind(cars2010a, cars2011a)

dataset <- plotData

helpPage <- fluidRow(
                  column(12,
                        pre(includeText("include.txt"))
                  ),
                  column(12,
                        includeHTML("include.html")
                  ),
                  column(12,
                        includeMarkdown("include.md")
                  )
            )

# Vector of names(dataset)
namesVector <- c("Eng Displ"="EngDispl", "Num Cyl"="NumCyl", "Transmission", 
                 "Fuel Economy"="FE", "Air Aspiration Method"="AirAspirationMethod", 
                 "Num Gears"="NumGears", "Trans Lockup"="TransLockup", 
                 "Trans Creeper Gear"="TransCreeperGear", "Drive Desc"="DriveDesc",
                 "Intake Valve Per Cyl"="IntakeValvePerCyl",
                 "Exhaust Valves Per Cyl"="ExhaustValvesPerCyl",
                 "Carline Class Desc"="CarlineClassDesc", "Var Valve Timing"="VarValveTiming",
                 "Var Valve Lift"="VarValveLift", "Year")

shinyUI(pageWithSidebar(
      
      headerPanel("Course Project of Developing Data Products"),

      sidebarPanel(
            tabsetPanel(id = "tabs", 
                  tabPanel("Basic", value=1,
                        selectInput("variable", "Variable:",
                                    namesVector, namesVector[[4]]),
                        numericInput("obs", "Number of observations to view:", 10),
                        textInput("caption", "Caption:", "Data Summary"),   
                        helpText("Note: while the data view will show only the specified",
                                    "number of observations, the summary will still be based",
                                    "on the full dataset."),
                           
                        submitButton("Update Plot"),

                        includeHTML("forCreator.html")                      
                  ),
                  
                  tabPanel("Advanced", value=2,
                           # Modified and Refer sample codes of Ref: http://shiny.rstudio.com/gallery/plot-plus-three-columns.html
                           # by JJ Allaire <jj@rstudio.com>
                           #
                        sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(dataset),
                              value=min(500, nrow(dataset)), step=500, round=0),
            
                        selectInput('x', 'X', namesVector),
                        selectInput('y', 'Y', namesVector, namesVector[[4]]),
                        selectInput('color', 'Color', c('None', namesVector)),

                        radioButtons("radio", label = h5("Smoothing Mothod"),
                                     choices = list("Linear Regression" = 1, "Auto" = 2),
                                     selected = 1),
                        checkboxInput('jitter', 'Jitter'),
                        checkboxInput('confReg', 'Show Confidence Region'), # add shaded confidence region
            
                        selectInput('facet_row', 'Facet Row', c(None='.', namesVector)),
                        selectInput('facet_col', 'Facet Column', c(None='.', namesVector)),
                        
                        submitButton("Update Plot"),
                        
                        includeHTML("forCreator.html")  
                  )
            )
      ),
      
      mainPanel(
            conditionalPanel("input.tabs == 1",
                  tabsetPanel(type = "tabs", 
                        tabPanel("Basic Plot",
                              inputPanel("Exploratory Data Analysis"),
                              plotOutput("mpgPlot"),
                              h4(textOutput("caption", container = span)),
                              fluidRow(
                                    column(6, verbatimTextOutput("summary")),
                                    column(6, tableOutput("view"))
                                    )
                              ),
                        tabPanel("Help", helpPage)
                  )
            ),
            
            conditionalPanel("input.tabs == 2",
                  tabsetPanel(type = "tabs", 
                        tabPanel("Advanced Plot", plotOutput("plot")), 
                        tabPanel("Help", helpPage)
                  )                  
            )

      )
))