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



counts <- table(df$status)

pe_p1 <- read.csv("udv_pe_p1_report.csv", header=TRUE, sep="|")
names(pe_p1) <- tolower(names(pe_p1))
pe_p1$needarrivdate <- as.Date(pe_p1$needarrivdate)
str(pe_p1)
pe_p1$p_cnt <- ( pe_p1$pa_cnt/pe_p1$co_cnt )*100
pe_p1$p_qty <- ( pe_p1$pa_qty/pe_p1$co_qty )*100
pe_p1$p_docnt <- ( pe_p1$pd_cnt/pe_p1$del_cnt )*100
pe_p1$p_doqty <- ( pe_p1$pd_qty/pe_p1$del_qty )*100
df <- pe_p1[pe_p1$needarrivdate <= (Sys.Date() + 5),]




# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- df
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
  output$newHist <- renderPlot({par(mfrow=c(1,2))
                       barplot(counts, main="Pegging Results", xlab="Order Status", col="blue")
                       plot(pe_p1$needarrivdate, pe_p1$p_doqty
                            , type="b"
                            , col="blue"
                            , pch=19
                            , xlab="Arrival Date"
                            , ylab="Percent Met"
                            ,ylim = c(1,100)
                            , main="Pecentage of Orders Met By Day of Week"
                       )
  })
#  output$newHist <- renderPlot({plot(pe_p1$needarrivdate, pe_p1$p_doqty
#                                     , type="b"
#                                     , col="blue"
#                                     , pch=19
#                                     , xlab="Arrival Date"
#                                     , ylab="Percent Met"
#                                     ,ylim = c(1,100)
#                                )
#  })
})
