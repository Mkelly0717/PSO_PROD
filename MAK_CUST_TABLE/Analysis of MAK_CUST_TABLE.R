setwd("C:/SQLDEVELOPER_CODE_PROD/MAK_CUST_TABLE")

df_cust_table <- read.csv("MAK_DWIGHTS_MAK_CUST_DATA.csv", header=TRUE, sep="|")
names(df_cust_table) <- tolower(names(df_cust_table))

df_cust_table$needshipdate <- as.Date(df_cust_table$needshipdate)
df_cust_table$needarrivdate <- as.Date(df_cust_table$needarrivdate)
df_cust_table$schedarrivdate <- as.Date(df_cust_table$schedarrivdate)
df_cust_table$schedshipdate <- as.Date(df_cust_table$schedshipdate)
df_cust_table$run_date <- as.Date(df_cust_table$run_date)


df_500 <- df_cust_table[df_cust_table$distance <= 500 ,]
summary(df_500)
sub1 <- aggregate(distance ~ needarrivdate, df_500[df_500$status==1 
                                                   | df_500$status==4,], mean)
sub2 <- aggregate(distance ~ needarrivdate, df_500[df_500$status==2 
                                                   | df_500$status==3,], mean)




barplot(table(df_500$co_item)
          , col="wheat"
          , main="Barplot of Number of Records by Item")

barplot(table(df_500$schedarrivdate)
          , col="yellow"
          , main="Barplot of Loads by Scheduled Arrival Date")

boxplot(distance ~ status, data=df_500, col="red")
title(  main="Boxplot of Length of Haul vs Status"
      #,sub="sub-title"
      ,xlab="Pegging Status"
      ,ylab="Length of Haul")

par(las=2, par(mar=c(5, 4, 4, 5))
         ,omd = c(.02, .85, .2, .9) # Set the margins
    )
boxplot(distance ~ sourcing, data=df_500, col="green")
title(  main="Boxplot of Length of Haul by Sourcing Method"
      #,sub="Boxplot of Lenth of Haul Vs Souring method"
#       ,xlab="Sourcing Method"
       ,ylab="Length of Haul"
       ,cex.lab=0.95
       ,col.main="red"
       ,col.sub="blue"
       ,col.lab="black"
       ,las=2)
abline(h=100, col="purple", lwd=2, lty=2)


df_qty <- df_cust_table
head(df_qty)
df_qty <- df_qty[ df_qty$u_sales_document=='Z1AA'
              & df_qty$co_qty <= 700,]
head(df_qty)
names(df_qty$co_qty)="qty"
h <- hist(df_qty$qty, labels=TRUE, breaks=50)
h$counts     <- cumsum(h$counts)
h$density    <- cumsum(h$density)
plot(h, freq=TRUE
      , main="(Cumulative) histogram of x"
      , col="white"
      , border="black")
box()

plot(ecdf(df_qty$qty)
      , main="Accumulative Frequency Distrubution A"
      , xlab="Qty of Order"
      , ylab="Accumulative Frequency"
      , col="blue"
      , ylim=c(0,1)
)

abline(h=0.01, col="purple", lwd=2, lty=2)
abline(v=200, col="purple", lwd=2, lty=2)


load_qty = df_qty$qty
breaks = seq(0, 600, by=50) 
load_qty.cut = cut(load_qty, breaks, right=FALSE) 
load_qty.freq = table(load_qty.cut)
cumfreq0 = c(0, cumsum(load_qty.freq))

plot(breaks, cumfreq0,
     , main="Accumulative Frequency Distrubution B"
     , xlab="Qty of Order"
     , ylab="Accumulative Distinct Qty"
     , col="darkblue"
     , pch=19
)
lines(breaks, cumfreq0)
abline(h=0.05, col="purple", lwd=2, lty=2)
abline(v=528, col="purple", lwd=2, lty=2)


df_cum <- read.csv("accum_qty.csv", header=TRUE, sep="|")
names(df_cum) <- tolower(names(df_cum))
names(df_cum)
plot(df_cum$order_qty, df_cum$cumulative_percent
     , main="Accumulative Frequency Distrubution Order Qty"
     , xlab="Qty of Order"
     , ylab="Accumulative Pecent of Total Pallets"
     , col="blue"
     , ylim=c(0,1), type='b'
     , pch=19
)
abline(h=0.05, col="green", lwd=2, lty=2)
abline(v=528, col="red", lwd=2, lty=2)
abline(h=0.005, col="brown", lwd=2, lty=2)
abline(v=300, col="black", lwd=2, lty=2)
legend("topleft", lty = c(2,2), lwd=c(2.5,2.5), 
       col = c(  "red"
                ,"green"
                ,"black"
                ,"maroon"
              )
       ,cex=0.5
       ,legend = c( "Qty=528 pallets"
                   ,"Cuml% =5.036"
                   ,"Qty=300 Pallets"
                   , "Cuml%=0.512"))

