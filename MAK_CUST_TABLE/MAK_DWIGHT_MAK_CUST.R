setwd("C:/SQLDEVELOPER_CODE_PROD/MAK_CUST_TABLE")

df_cust_table <- read.csv("MAK_DWIGHTS_MAK_CUST_DATA.csv", header=TRUE, sep="|")
names(df_cust_table) <- tolower(names(df_cust_table))

df_cust_table$needshipdate <- as.Date(df_cust_table$needshipdate)
df_cust_table$needarrivdate <- as.Date(df_cust_table$needarrivdate)
df_cust_table$schedarrivdate <- as.Date(df_cust_table$schedarrivdate)
df_cust_table$schedshipdate <- as.Date(df_cust_table$schedshipdate)
df_cust_table$run_date <- as.Date(df_cust_table$run_date)

counts <- table(df_cust_table$status)
p1_counts <- table(df_cust_table$p1)

barplot(counts, main="Order Pegging Status"
              , xlab="Order Status"
              , col="blue"
)
legend("topright", lty = c(1), lwd=c(2.5), 
       col = c(  "blue")
       ,cex=0.9
       ,legend = c( "0-Unmet"
                  , "1-Pegged Orders"
                  , "2-Pegged Deliveries"
                  , "3-Pegged Unused Del"
                  , "4-Pegged Unused Orders"
                  , "5-Pegged Del Collections"
                  , "6-Pegged Ord Collecions"
                  , "9-INTRANSIT Records"
                  ,"10-Old Orders"
                    
                  )
)

barplot(p1_counts, main="P1 Status", xlab="Order Status", col="blue")


df_le_500_f1 <- df_cust_table[df_cust_table$firmsw==1 & df_cust_table$distance <= 500 ,]
summary(df_le_500_f1$distance)

df_le_500_f1 <- df_cust_table[df_cust_table$firmsw==1 & df_cust_table$distance <= 500 ,]
summary(df_le_500_f1$distance)
hist(df_le_500_f1$distance, label=TRUE
       , c(0,50,100,150,200,250,300,350,400,450,500)
       , main="Histogram of Number of Loads By Distance Firmsw=1"
       , xlab="Length of Haul"
       , ylab="Number of Loads"
       , col="lightblue"
)


df_le_500_s1 <- df_cust_table[df_cust_table$status==1 & df_cust_table$distance <= 500 ,]
summary(df_le_500_s1$distance)
hist(df_le_500_s1$distance, label=TRUE
     , c(0,50,100,150,200,250,300,350,400,450,500)
     , main="Histogram of Number of Loads By Distance Status=1"
     , xlab="Length of Haul"
     , ylab="Number of Loads"
     , col="lightblue"
)

df_le_500_s2 <- df_cust_table[df_cust_table$status==2 & df_cust_table$distance <= 500 ,]
summary(df_le_500_s2$distance)
hist(df_le_500_s2$distance, label=TRUE
     , c(0,50,100,150,200,250,300,350,400,450,500)
     , main="Histogram of Number of Loads By Distance Status=2"
     , xlab="Length of Haul"
     , ylab="Number of Loads"
     , col="lightblue"
)


df_le_500_P1 <- df_cust_table[df_cust_table$p1==1 & df_cust_table$distance <= 500 ,]
summary(df_le_500_P1$distance)
hist(df_le_500_P1$distance, label=TRUE
     , c(0,50,100,150,200,250,300,350,400,450,500)
     , main="Histogram of Number of Loads By Distance P1=1"
     , xlab="Length of Haul"
     , ylab="Number of Loads"
     , col="lightblue"
)

df_le_500_P0 <- df_cust_table[df_cust_table$p1==0 & df_cust_table$distance <= 500 ,]
summary(df_le_500_P0$distance)
hist(df_le_500_P0$distance, label=TRUE
     , c(0,50,100,150,200,250,300,350,400,450,500)
     , main="Histogram of Number of Loads By Distance P1=0"
     , xlab="Length of Haul"
     , ylab="Number of Loads"
     , col="lightblue"
)



with ( data=df_avg_dist_f1, plot(needarrivdate
                                  , distance
                                  , type='b'
                                  , main="FirmSw=1"
                                  , ylim=c(0,250)
                                  , pch=19
                                  , col='green'
                                )
     )

df_avg_dist_s1 <- aggregate(distance ~ needarrivdate, df_le_500_s1, mean)
with ( data=df_avg_dist_s1, plot(needarrivdate
                                  , distance
                                  , type='b'
                                  , main="Status=1"
                                  , ylim=c(0,250)
                                  , pch=20
                                  , col='red'
                                )
)

df_avg_dist_s2 <- aggregate(distance ~ needarrivdate, df_le_500_s2, mean)
with ( data=df_avg_dist_s2, plot(needarrivdate
                                  , distance
                                  , type='b'
                                  , main="Status=2"
                                  , ylim=c(0,250)
                                  , pch=21
                                  , col='blue'
                                 )
)

df_avg_dist_s2 <- aggregate(distance ~ needarrivdate, df_le_500_s2, mean)
with ( data=df_avg_dist_s2, plot(needarrivdate
                                 , distance
                                 , type='b'
                                 , main="Status=2"
                                 , ylim=c(0,250)
                                 , pch=21
                                 , col='blue'
)
)

df_cust_data <- df_cust_table[  df_cust_table$needarrivdate>=as.Date('2016-03-08')
                             ,c("p1", "needarrivdate", "distance")]
avg_dist_p0 <- df_cust_data[df_cust_data$p1==0,c("needarrivdate", "distance")]
df_avg_dist_p0 <- aggregate(distance ~ needarrivdate, avg_dist_p0, mean)

avg_dist_p1 <- df_cust_data[df_cust_data$p1==1,c("needarrivdate", "distance")]
df_avg_dist_p1 <- aggregate(distance ~ needarrivdate, avg_dist_p1, mean)

avg_dist_p2 <- df_cust_data[df_cust_data$p1==2,c("needarrivdate", "distance")]
df_avg_dist_p2 <- aggregate(distance ~ needarrivdate, avg_dist_p2, mean)

avg_dist_pall <- df_cust_data[df_cust_data$p1 %in% c(0,1),c("needarrivdate", "distance")]
df_avg_dist_pall <- aggregate(distance ~ needarrivdate, avg_dist_pall, mean)



df_avg_dist_p2


plot(df_avg_dist_p0$needarrivdate, df_avg_dist_p0$distance
                     , col="blue"
                     ,type='b'
                     , pch=19
                     , ylim=c(0,300))
lines(df_avg_dist_p1$needarrivdate, df_avg_dist_p1$distance, col="red", pch=19, lwd=4)
lines(df_avg_dist_p2$needarrivdate, df_avg_dist_p2$distance, col="pink", pch=19, lwd=4)
lines(df_avg_dist_pall$needarrivdate, df_avg_dist_pall$distance, col="darkgreen", pch=19, lwd=4)
legend("topright", lty = c(1)
                 , lwd=c(2.5)
                 ,col = c("blue", "red", "pink","darkgreen"), 
                 ,cex=0.9
                 ,legend = c( "p1=does't match"
                            , "p1=matches"
                            , "p1=not exists"
                            , "p1=all"
                 )
)
abline(h=c("100"), lwd=4, lty=1)
