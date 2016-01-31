#################################################################################
## Filename: plot1.R
## Author: Tad Shimada
## Description:
## - This script attempts to show whether or not the total emissions from PM2.5
## descreased in the United States from 1999 to 2008. It generates a line plot
## and saves it in PNG file called 'plot1.png' in the same directory where
## the script resides.
#################################################################################

# the data file should exist in the same directory where this R script is
# stored and executed.
NEI <- readRDS("./summarySCC_PM25.rds")

# group the data by year then sum the emission values for
# each year.
d <- aggregate(NEI$Emissions, by = list(Year = NEI$year), sum)

# rename the column that contains the total emission per year
names(d)[2] <- c("Total.Emissions")

# data frame from above operation should now look like this.
#
# Year Total.Emissions
# 1 1999         7332967
# 2 2002         5635780
# 3 2005         5454703
# 4 2008         3464206

# open PNG graphic device to store the line plot in 480 x 480 PNG file
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# plot line graph with dot for each year (type = "o" with dot style (19))
# xaxt = "n" is to tell not to auto-label x-axis.
plot(d$Year, d$Total.Emissions/1000,
    main = "Total Emission in the United States (1999-2008)", # plot's main title
    xlab = "Year", # x-axis label
    ylab = "Total Emission (in thousand tons)", # y-axis label
    type ="o", # both line and dot overlaid on top of each other
    pch = 19, # dot style
    xaxt = "n" # don't auto-label x-axis value
    )

# label x-axis values using the year value from the data frame.
axis(side = 1, at = d$Year, labels = d$Year)

# close previously opened PNG graphic device. This also flushes the image
# into the file.
dev.off()
