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
counts <- table(df_cust_table$status)


### Load the udv_df_pe_p1_report into df_pe_p1
df_pe_p1 <- read.csv("udv_pe_p1_report.csv", header=TRUE, sep="|")
names(df_pe_p1) <- tolower(names(df_pe_p1))
df_pe_p1$needarrivdate <- as.Date(df_pe_p1$needarrivdate)
df_pe_p1$p_cnt <- ( df_pe_p1$pa_cnt/df_pe_p1$co_cnt )*100
df_pe_p1$p_qty <- ( df_pe_p1$pa_qty/df_pe_p1$co_qty )*100
df_pe_p1$p_docnt <- ( df_pe_p1$pd_cnt/df_pe_p1$del_cnt )*100
df_pe_p1$p_doqty <- ( df_pe_p1$pd_qty/df_pe_p1$del_qty )*100
#df <- df_pe_p1[df_pe_p1$needarrivdate <= (Sys.Date() + 5),]
str(df_pe_p1)

### Load the mak_daily_report into df_daily
df_daily <- read.csv("MAK_DAILY_REPORT_DATA.csv", header=TRUE, sep="|")
names(df_daily) <- tolower(names(df_daily))
df_daily$needarrivdate <- as.Date(df_daily$needarrivdate)
df_daily$rundate <- as.Date(df_daily$rundate)

### Load the mak_sm_table into df_sm_daily

df_sm_table <- read.csv("MAK_SM_TABLE.csv", header=TRUE, sep="|")
names(df_sm_table) <- tolower(names(df_sm_table))
df_sm_table$schedarrivdate <- as.Date(df_sm_table$schedarrivdate)
str(df_sm_table)
p1_counts <- table(df_sm_table$p1)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table2 <- DT::renderDataTable(DT::datatable({
    data2 <- df_daily
    if (input$ad != "All") {
      data2 <- data2[data2$needarrivdate == input$ad,]
    }
    data2
  }))
  output$table <- DT::renderDataTable(DT::datatable({
    data <- df_cust_table
    if (input$status != "All") {
      data <- data[data$status == input$status,]
    }
    if (input$shipdate != "All") {
      data <- data[data$shipdate == input$shipdate,]
    }
    if (input$demandcode != "All") {
      data <- data[data$u_dmdgroup_code == input$demandcode,]
    }
    if (input$source != "All") {
      data <- data[data$vll_source == input$source,]
    }
    data
  }))

  output$newHist <- renderPlot({par(mfrow=c(2,2))
      barplot(counts
              , main="Pegging Results"
              , xlab="Order Status"
              , col="blue"
      )
      barplot(p1_counts
              , main="P1 Lanes (0=No, 1=Yes)"
              , xlab="P1 Lanes Used Count"
              , col="blue"
      )
      
      plot(df_pe_p1$needarrivdate, df_pe_p1$p_doqty
            , type="b"
            , col="blue"
            , pch=19
            , xlab="Arrival Date"
            , ylab="Percent Met"
            ,ylim = c(1,100)
            , main="Pecentage of Orders Met By Date"
      )


  })
  output$newHist2 <- renderPlot({par(mfrow=c(2,4))

    plot(df_daily$needarrivdate, df_daily$avg_milage
         , type="b"
         , col="blue"
         , pch=19
         , xlab="Arrival Date"
         , ylab="Average Milage"
         ,ylim = c(0,500)
         , main="Average Milage of Orders Met By Date"
    )
    plot(df_daily$needarrivdate, df_daily$avg_cost
         , type="b"
         , col="blue"
         , pch=19
         , xlab="Arrival Date"
         , ylab="Average Milage"
#         ,ylim = c(0,500)
         , main="Average Milage of Orders Met By Date"
    )
    
        plot(df_daily$needarrivdate, df_daily$percent_p1_match_qty
         , type="b"
         , col="blue"
         , pch=19
         , xlab="Arrival Date"
         , ylab="Percent Met"
         ,ylim = c(0,100)
         ,main="Percent P1 Qty Match by Date"
    )
    plot(df_daily$needarrivdate, df_daily$percent_orders_met
         , type="b"
         , col="blue"
         , pch=19
         , xlab="Arrival Date"
         , ylab="Percent P1 Match"
         ,ylim = c(0,100)
         ,main="Percent P1 Match Orders by Arrival Date"
    )
    plot(df_daily$needarrivdate, df_daily$tot_qty
         , type="b"
         , col="blue"
         , pch=19
         , xlab="Arrival Date"
         , ylab="Percent P1 Match"
#         ,ylim = c(0,100)
         ,main="Total Quantity Shipped by Arrival Date"
    )
  })
})
