SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
library(data.table)
library(ggplot2)
NEI <- data.table(NEI)
SCC <- data.table(SCC)
Emission.total <- NEI[,sum(Emissions),by=year]
setnames(Emission.total, "V1", "Emission")
Emission.Balti.year <- NEI[fips == "24510", sum(Emissions), by=year]
setnames(x=Emission.Balti.year, old="V1", new="Emission")
Emission.Balti.year.type <- NEI[fips=="24510", sum(Emissions),
                                by=c("year","type")]
setnames(x=Emission.Balti.year.type, old="V1", new="Emission")
SCC[,FULL.NAME := paste(Short.Name, EI.Sector, Option.Group, Option.Set,
                        SCC.Level.One, SCC.Level.Two, SCC.Level.Three,
                        SCC.Level.Four)]
setkey(NEI, SCC)
setkey(SCC, SCC)
SCC.coal <- SCC[ eval(grep("coal", SCC[,FULL.NAME], ignore.case=T)), ]
NEI.coal <- NEI[ SCC.coal, mult="all"]
NEI.coal.year <- NEI.coal[, sum(Emissions, na.rm=T), by=year]
setnames(NEI.coal.year, "V1", "Coal.Emission")

png(filename="plot4.png", width=480, height=480)
ggplot(NEI.coal.year, aes(year, Coal.Emission)) + geom_point(size=4) +
  geom_line() + ggtitle("Coal Related emission from 1998 to 2008") +
  ylab("Annual Coal Related Emissions (Tons)")
dev.off()