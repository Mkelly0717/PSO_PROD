setwd("C:/SQLDEVELOPER_CODE_PROD/MAK_CUST_TABLE")


df_sm_table <- read.csv("MAK_SM_TABLE.csv", header=TRUE, sep="|")
names(df_sm_table) <- tolower(names(df_sm_table))
df_sm_table$schedarrivdate <- as.Date(df_sm_table$schedarrivdate)
str(df_sm_table)

df <- df_sm_table[df_sm_table$schedarrivdate >= as.Date('2016-03-08'),]
#                  & substr(df_sm_table$item,1,4) =="4055"
df$pf <- as.factor(df$p1)
df$durf <- as.factor(df$dur)
df$p1 <- df$pf
df$dur <- df$durf
df <- df[,c("item","schedarrivdate","sm_totqty","vl_qty_used","co_qty_used","durf","sourcing","distance","pf","source")]
str(df)

#d2 <- df[,c("item","schedarrivdate","distance","pf")]
#str(d2)

plot(df$item, df$distance)
plot(df$sourcing, df$distance)
plot(df$pf, df$distance)
plot(df$distance, df$vl_qty_used)
plot(df$distance, df$co_qty_used)
plot(df$schedarrivdate, df$distance)
plot(df$durf, df$distance)
df_src_gt_200 <- df[df$distance>600,]
plot(df_src_gt_200$source, df_src_gt_200$distance)


p1_counts <- table(as.numeric(df$p1))
p1_counts
head(df)
dfp0 <- aggregate(sm_totqty ~ sourcing, df[df$p1=="0",], sum)
dfp1 <- aggregate(sm_totqty ~ sourcing, df[df$p1=="1",], sum)
dfp2 <- aggregate(sm_totqty ~ sourcing, df[df$p1=="2",], sum)

sub1 <- aggregate(distance ~ schedarrivdate, df[ (df$p1==0)
                                                    & df$schedarrivdate>=as.Date('2016-03-08'),], mean)
sub2 <- aggregate(distance ~ schedarrivdate, df[ (df$p1==1)
                                                    & df$schedarrivdate>=as.Date("2016-03-08"),], mean)
sub3 <- aggregate(distance ~ schedarrivdate, df[ (df$p1==2)
                                                    & df$schedarrivdate>=as.Date("2016-03-08"),], mean)
###############################################################################
# Plot the Distance by each Date
################################################################################
plot(sub1$schedarrivdate, sub1$distance
              , type="b"
              , main="Hist of Average Distance by Schedarrivdate"
              , col="blue"
              , pch=19
              , ylim=c(0,400)
              , lwd=4)
lines(sub2$schedarrivdate, sub2$distance
         , col="red"
         , pch=19
         , lwd=4)
lines(sub3$schedarrivdate, sub3$distance
         , col="black"
         , lwd=4)
legend("topleft", lty = c(1,1,1)
                , lwd=c(2.5,2.5,2.5)
                , col = c("blue", "red", "black")
                , legend = c("P1=doesn't match", "P1=matches", "P1=doesn't exist"))
abline(h=c(100),lwd=4)