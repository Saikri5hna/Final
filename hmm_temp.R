#These are the required packages
#to install use the command -- install.packages("Package name") -- package name is case sensitive 
library(quantmod)
library(depmixS4)
library(TTR)
library(ggplot2)
library(reshape2)

#Downloading Apple stock data from 2007-01-03 to till date
getSymbols(Symbols = "AAPL", 
           env = parent.frame(),
           reload.Symbols = FALSE,
           verbose = FALSE,
           warnings = TRUE,
           src = "yahoo",
           symbol.lookup = TRUE,
           auto.assign = getOption('getSymbols.auto.assign',TRUE))

chartSeries(AAPL)

#removing NA values
AAPL[is.na(AAPL)] <- 0
apple1 <- AAPL

#Taking the difference in a day rather than previously taken difference in consecutive days
apple_train <- cbind(apple1$AAPL.Close - apple1$AAPL.Open, apple1$AAPL.Volume)
head(apple_train)
plot(apple_train)

apple_train_df <- data.frame(apple_train)
apple_train_df$Date <-as.Date(row.names(apple_train_df),"%Y-%m-%d")

ggplot( apple_train_df, aes(Date) ) + 
        geom_line( aes( y = AAPL.Close ) ) +
        labs( title = "APPLE difference by day")


#the return value of depmix is a model specification without optimized parameter values
model <- depmix(AAPL.Close ~ 1, family = gaussian(), nstates = 2, data = apple_train)
set.seed(1)
#fit optimizes parameters of depmix or mix models, optionally subject to general linear (in)equality constraints
fit_model <- fit(model, verbose = FALSE)

summary(fit_model)
print(fit_model)
#gives the optimal probablities
probability <- posterior(fit_model)
head(probability)
#to make sure the probability is one
rowSums(head(probability)[c(2,3)])

#dividing into bull and bear
bull_prob <- probability[,1]
apple_train_df$Bull <- bull_prob 

bear_prob <- probability[,2]
apple_train_df$Bear <- bear_prob 

names(apple_train_df)
apple_train_df1 <- apple_train_df[,c(1,3,4,5)]


df2 <- melt(apple_train_df1,id="Date",measure=c("AAPL.Close","Bear", "Bull"))


qplot(Date,value,data=df2,geom="line",
      main = "Apple stock, Bear and bull state probabilities",
      ylab = "") + 
        facet_grid(variable ~ ., scales="free_y")


# ggplot(apple_train_df1, aes(Date)) + 
#           geom_line(aes(y = AAPL.Close, colour = "AAPL.Close")) + 
#           geom_line(aes(y = Bear*10, colour = "Bear")) + 
#           geom_line(aes(y = Bull*10, colour = "Bull"))


