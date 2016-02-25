library(ggplot2)
library(UsingR)
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


par(mfrow=c(1,2))
counts <- table(df$status)
b1 <- barplot(counts, main="Pegging Status", xlab="Order Status", col="blue")

pe_p1 <- read.csv("udv_pe_p1_report.csv", header=TRUE, sep="|")
names(pe_p1) <- tolower(names(pe_p1))
pe_p1$needarrivdate <- as.Date(pe_p1$needarrivdate)
str(pe_p1)
pe_p1$p_cnt <- ( pe_p1$pa_cnt/pe_p1$co_cnt )*100
pe_p1$p_qty <- ( pe_p1$pa_qty/pe_p1$co_qty )*100
pe_p1$p_docnt <- ( pe_p1$pd_cnt/pe_p1$del_cnt )*100
pe_p1$p_doqty <- ( pe_p1$pd_qty/pe_p1$del_qty )*100
df <- pe_p1[pe_p1$needarrivdate <= (Sys.Date() + 5),]


p1 <- plot(pe_p1$needarrivdate, pe_p1$p_doqty
     , type="b"
     , col="blue"
     , pch=19
     , xlab="Arrival Date"
     , ylab="Percent Met"
     ,ylim = c(1,100)
)
p1



