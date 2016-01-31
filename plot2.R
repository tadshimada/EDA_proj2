#################################################################################
## Filename: plot2.R
## Author: Tad Shimada
## Description:
## - This script attempts to show whether or not the total yearly emissions
## from PM2.5 decreased from in Baltimore City, Maryland from 1999 to 2008.
## It generates the line plot to show the year-by-year changes in the emissions
## and saves PNG file in 'plot2.png'.
#################################################################################

# the data file should exist in the same directory where this R script is
# stored and executed.
NEI <- readRDS("./summarySCC_PM25.rds")

# create a subset of PM25 data for Baltimore (fips == "24510")
# and just keep "Emissions" and "year" columns.
baltimore <- subset(NEI, fips == "24510", c(Emissions, year))

# sum up the PM25 values in Emissions column for each year
balpm25 <- aggregate(baltimore$Emissions, by = list(Year = baltimore$year), sum)

# rename the column that contains the total emission per year
names(balpm25)[2] <- c("Total.Emissions")

# the data in balpm25 data frame should now look like this.
#
# Year Total.Emissions
# 1 1999        3274.180
# 2 2002        2453.916
# 3 2005        3091.354
# 4 2008        1862.282

# open PNG graphic device to store the line plot in 480 x 480 PNG file
png(filename = "plot2.png", width = 480, height = 480, units = "px")

# plot line graph with dot for each year (type = "o" with dot style (19))
# xaxt = "n" is to tell not to auto-label x-axis.
plot(balpm25$Year,
    balpm25$Total.Emissions,
    main = "Total Emission in Baltimore City, MD (1999-2008)", # plot's main title
    xlab = "Year", # x-axis label
    ylab = "Total Emission (in tons)", # y-axis label
    type ="o", # both line and dot overlaid on top of each other
    pch = 19, # dot style
    xaxt = "n" # don't auto-label x-axis value
)

# label x-axis values using the year value from the data frame.
axis(side = 1, at = d$Year, labels = d$Year)

# close previously opened PNG graphic device. This also flushes the image
# into the file.
dev.off()
