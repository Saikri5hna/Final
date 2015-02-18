$project
========

$Project is to find the different regimes in a Stock Data

Market shifts are detected using Hidden Markov Model.

In this project I’ve choose Apple stock data using quantmod package and depmixS4 package to implement Hidden markov models.

Steps- 
1) Install and load necessary packages
2)Download apple stock data, ticker - AAPL, from yahoo using quantmod.
3)Cleaning by removing NA values and subsetting
4)Taking difference in a day in a separate data frame
5)Plotting the difference by time
6)training the model with depmix function
7) Fitting the model
8)Posterior to get the optimal probabilities 
9)get the bull and bear probability
10)Plot the Price difference, bear and bull in a single graph.


