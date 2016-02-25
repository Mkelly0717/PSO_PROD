library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)
setwd("C:/SQLDEVELOPER_CODE_PROD/MAK_CUST_TABLE")
t_mak_cust <- read.csv("mak_cust_table.csv", header=TRUE, sep="|")
names(t_mak_cust) <- tolower(names(t_mak_cust))
t_mak_cust$co_orderid <- as.character(t_mak_cust$co_orderid)
t_mak_cust$loadid <- as.character(t_mak_cust$loadid)
t_mak_cust$vll_dest <- as.character(t_mak_cust$vll_dest)
t_mak_cust$schedarrivdate <- as.Date(t_mak_cust$schedarrivdate,'D-M-Y')
str(t_mak_cust)

df <- t_mak_cust
df$shipdate <- as.Date(df$shipdate)
df$schedshipdate <- as.Date(df$schedshipdate)
df$schedarrivdate <- as.Date(df$schedarrivdate)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("PSO Daily Statistics"),
    plotOutput('newHist'),
#    plotOutput('barPlot'),
    # Create a new Row in the UI for selectInputs
    fluidRow(
     column(4,
             selectInput("shipdate",
                         "shipdate:",
                         c("All",
                           unique(as.character(df$shipdate))))
      ),
     column(4,
            selectInput("status",
                        "Order Status:",
                        c("All",
                          unique(as.character(df$status))))
     ),
     column(4,
            selectInput("demandcode",
                        "Demand Code:",
                        c("All",
                          unique(as.character(df$u_dmdgroup_code))))
     ),
     column(4,
            selectInput("source",
                        "Source:",
                        c("All",
                          unique(as.character(df$vll_source))))
     )
     
    ),
    # Create a new row for the table.
    fluidRow(
      DT::dataTableOutput("table")
    )
  )
)