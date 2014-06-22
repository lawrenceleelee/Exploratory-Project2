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
SCC.Motor <- SCC[ eval(grep("motor", SCC[,FULL.NAME], ignore.case=T)), ]
NEI.Motor <- NEI[ SCC.Motor, mult="all"]
NEI.Balti.Motor.year <- NEI.Motor[fips=="24510", sum(Emissions), by=year]
setnames(NEI.Balti.Motor.year, "V1", "Emission")

png(filename="plot5.png", width=480, height=480)
ggplot(NEI.Balti.Motor.year, aes(year, Emission)) +
  geom_point(size=4) + geom_line() +
  ylab("Emission (Tons)") +
  ggtitle("Annual Emission from Motor Vehicles/Motocycles in Baltimore")
dev.off()
