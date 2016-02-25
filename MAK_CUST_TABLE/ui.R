library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

### Load the mak_cust_table into df_cust_table
setwd("C:/SQLDEVELOPER_CODE_PROD/MAK_CUST_TABLE")
df_cust_table <- read.csv("mak_cust_table.csv", header=TRUE, sep="|")
names(df_cust_table) <- tolower(names(df_cust_table))
df_cust_table$co_orderid <- as.character(df_cust_table$co_orderid)
df_cust_table$loadid <- as.character(df_cust_table$loadid)
df_cust_table$vll_dest <- as.character(df_cust_table$vll_dest)
df_cust_table$shipdate <- as.Date(df_cust_table$shipdate)
df_cust_table$schedshipdate <- as.Date(df_cust_table$schedshipdate)
df_cust_table$schedarrivdate <- as.Date(df_cust_table$schedarrivdate)

### Load the mak_daily_report into df_daily
df_daily <- read.csv("MAK_DAILY_REPORT_DATA.csv", header=TRUE, sep="|")
names(df_daily) <- tolower(names(df_daily))
df_daily$needarrivdate <- as.Date(df_daily$needarrivdate)
df_daily$rundate <- as.Date(df_daily$rundate)
str(df_daily)

### Load the mak_sm_table into df_sm_daily

df_sm_table <- read.csv("MAK_SM_TABLE.csv", header=TRUE, sep="|")
names(df_sm_table) <- tolower(names(df_sm_table))
df_sm_table$schedarrivdate <- as.Date(df_sm_table$schedarrivdate)
str(df_sm_table)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("PSO Daily Statistics"),
    h3('MAK_CUST_TABLE Plots'),
    plotOutput('newHist'),
    h3('MAK Daily Report Plots'),
    plotOutput('newHist2'),
    h3('MAK Daily Report'),
    # Create a new Row in the UI for selectInputs


    # Create a new row for the table.
    fluidRow(
      column(4,
             selectInput("ad",
                         "needarivdate:",
                         c("All",
                           unique(as.character(df_daily$needarrivdate))))
      )
    ),
    fluidRow(
      DT::dataTableOutput("table2")
    ),
    # Create a new row for the table.
    h3('MAK_CUST_TABLE'),

    fluidRow(
      column(4,
             selectInput("shipdate",
                         "shipdate:",
                         c("All",
                           unique(as.character(df_cust_table$shipdate))))
      ),
      column(4,
             selectInput("status",
                         "Order Status:",
                         c("All",
                           unique(as.character(df_cust_table$status))))
      ),
      column(4,
             selectInput("demandcode",
                         "Demand Code:",
                         c("All",
                           unique(as.character(df_cust_table$u_dmdgroup_code))))
      ),
      column(4,
             selectInput("source",
                         "Source:",
                         c("All",
                           unique(as.character(df_cust_table$vll_source))))
      )
      
    ),
    fluidRow(
      DT::dataTableOutput("table")
    )

  )
)