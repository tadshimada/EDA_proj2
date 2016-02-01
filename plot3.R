##################################################################################
## Filename: plot3.R
## Author: Tad Shimada
## Description:
## - This script attempts to show whether or not the total emissions decreased
## from 1999 to 2008 for each source type. It generates 4 line plots, one for
## each source type. All 4 plots are drawn and saved in 1 PNG file (960 x 480).
## For plotting, the script uses qplot (ggplot2) as required by the assignment.
##################################################################################

# the data file should exist in the same directory where this R script is
# stored and executed.
NEI <- readRDS("./summarySCC_PM25.rds")

# create a subset of PM25 data for Baltimore (fips == "24510")
# and just keep "Emissions" and "year" columns.
baltimore <- subset(NEI, fips == "24510", c(Emissions, type, year))

# sum up PM25 values for the combination of year and type.
balpm25 <- aggregate(baltimore$Emissions, by = list(year = baltimore$year, type = baltimore$type), sum)

# rename the column that contains the total emission per year
names(balpm25)[3] <- c("total.emissions")

# data frame 'balpm25' should now look like this.
# year     type total.emissions
# 1  1999 NON-ROAD       522.94000
# 2  2002 NON-ROAD       240.84692
# 3  2005 NON-ROAD       248.93369
# 4  2008 NON-ROAD        55.82356
# 5  1999 NONPOINT      2107.62500
# 6  2002 NONPOINT      1509.50000
# 7  2005 NONPOINT      1509.50000
# 8  2008 NONPOINT      1373.20731
# 9  1999  ON-ROAD       346.82000
# 10 2002  ON-ROAD       134.30882
# 11 2005  ON-ROAD       130.43038
# 12 2008  ON-ROAD        88.27546
# 13 1999    POINT       296.79500
# 14 2002    POINT       569.26000
# 15 2005    POINT      1202.49000
# 16 2008    POINT       344.97518

# use qplot (ggplot2) to generate the line graph showing the total emission changes
# from 1999 to 2008 for each source type.
p <- qplot(year, total.emissions, data = balpm25, geom = c("point", "line"), facets = . ~ type,
    main = "Total Emissions in Baltimore City, MD (1999-2008) by Source Type",
    ylab = "Total Emission (in tons)")

# save the plot into 960 x 480 PNG file (plot3.png).
ggsave(filename = "plot3.png", device = "png", width = 9.6, height = 4.8, dpi = 100, plot = p)

