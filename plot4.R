#####################################################################################
## Filename: plot4.R
## Author: Tad Shimada
## Description:
## - This script attempts to show how the emissions from coal combustion-related
## sources changed from 1999 to 2008 across the United States.
## It generates the line plot and saves it in a 480x480 PNG file called 'plot4.png'
#####################################################################################

# the data file should exist in the same directory where this R script is
# stored and executed.

# load emission data
NEI <- readRDS("./summarySCC_PM25.rds")

# load source classification code table
SCC <- readRDS("./Source_Classification_Code.rds")

# filter the source table for coal related source
coals <- subset(SCC, grepl("Coal", EI.Sector), c(SCC))

# create vectors of scc
coalscc <- coals$SCC
neiscc <- NEI$SCC

# find the emission observations that are from coal-combustion
# related source.
i <- intersect(neiscc, coalscc)
coalNEI <- subset(NEI, SCC %in% i)

# group coal NEI data by year and sum the emission values per year.
d <- aggregate(coalNEI$Emissions, by = list(year = coalNEI$year), sum)

# rename the column that contains the total emission per year
names(d)[2] <- c("coal.emissions")

# open PNG graphic device to store the line plot in 480 x 480 PNG file
png(filename = "plot4.png", width = 480, height = 480, units = "px")

# plot line graph with dot for each year (type = "o" with dot style (19))
# xaxt = "n" is to tell not to auto-label x-axis.
plot(d$year,
    d$coal.emissions / 1000, # just to make the values more understandable
    main = "Emission from Coal Combustion-related Source \nin the United States (1999-2008)", # plot's main title
    xlab = "Year", # x-axis label
    ylab = "Emission (in thousand tons)", # y-axis label
    type ="o", # both line and dot overlaid on top of each other
    pch = 19, # dot style
    xaxt = "n" # don't auto-label x-axis value
)

# label x-axis values using the year value from the data frame.
axis(side = 1, at = d$year, labels = d$year)

# close previously opened PNG graphic device. This also flushes the image
# into the file.
dev.off()
