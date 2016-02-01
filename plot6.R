################################################################################
## Filename: plot6.R
## Author: Tad Shimada
## Description:
## - This script attempts to show how the emissions from motor vehicle
## sources changed over time in Baltimore City, MD and Los Angeles County.
## It generates the bar plot that shows year-over-year percent change for
## both cities side by side for each year (1999, 2002, 2005, and 2008).
## If the bar extends downward from the baseline (0%), that means there was
## decrease in the emission from the previous year.
################################################################################

# the data file should exist in the same directory where this R script is
# stored and executed.

# load emission data
NEI <- readRDS("./summarySCC_PM25.rds")

# load source classification code table
SCC <- readRDS("./Source_Classification_Code.rds")

# filter the source table for motor vehicle source
vehicles <- subset(SCC, grepl("Vehicles", EI.Sector), c(SCC))

# create vectors of scc
vehiclescc <- vehicles$SCC
neiscc <- NEI$SCC

# find the emission observations that are from vehicle source.
i <- intersect(neiscc, vehiclescc)
balvehicleNEI <- subset(NEI, fips == "24510" & SCC %in% i)
lavehicleNEI <- subset(NEI, fips == "06037" & SCC %in% i)

# group vehicle NEI data by year and sum the emission values per year.
d0 <- aggregate(balvehicleNEI$Emissions, by = list(year = balvehicleNEI$year), sum)
d1 <- aggregate(lavehicleNEI$Emissions, by = list(year = lavehicleNEI$year), sum)

# rename the column that contains the total emission per year
names(d0)[2] <- c("vehicle.emissions")
names(d1)[2] <- c("vehicle.emissions")

# compute the year-over-year percentage change in the emission

# baltimore city
curr0 <- d0$vehicle.emissions[-1]
prev0 <- d0$vehicle.emissions[1:length(d0$vehicle.emissions) - 1]
balchange <- 100 * round((curr0 - prev0) / prev0, 2)

# los angeles county
curr1 <- d1$vehicle.emissions[-1]
prev1 <- d1$vehicle.emissions[1:length(d1$vehicle.emissions) - 1]
lachange <- 100 * round((curr1 - prev1) / prev1, 2)

# create a table that contains YoY change for both regions
# since we calculate the change over the previous year,
# we use 1999 figures as the start, hence in the resulting barplot
# there is no bar for 1999 emission stats.
t <- rbind(balchange, lachange)
colnames(t) <- c("2002", "2005", "2008")
rownames(t) <- c("Baltimore", "Los_Angeles")

# open PNG graphic device to store the line plot in 480 x 480 PNG file
png(filename = "plot6.png", width = 480, height = 480, units = "px")

barplot(t, col = c("skyblue", "maroon"),
    beside = TRUE,
    ylim = c(-65, 25),
    main = "Vehicle Emission Year-Over-Year Change Comparison",
    xlab = "Year",
    ylab = "Vehicle Emission Year-Over-Year Change (%)"
    )

# draw horizontal dotted line at 0 %
abline(h = 0, lty = 2)

# add the legend at the bottom right corner.
legend("bottomright", legend = c("Baltimore", "Los Angeles"),
    text.col = c("skyblue", "maroon"))

# close previously opened PNG graphic device. This also flushes the image
# into the file.
dev.off()
