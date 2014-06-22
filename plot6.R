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
NEI.LA.Motor.year <- NEI.Motor[fips=="06037", sum(Emissions), by=year]
setnames(NEI.LA.Motor.year, "V1", "Emission")
NEI.Balti.Motor.year[ , county := "Baltimore"]
NEI.LA.Motor.year[ , county := "LosAngeles"]
NEI.L.B.Motor.year <- rbind(NEI.Balti.Motor.year, NEI.LA.Motor.year)

png(filename="plot6.png", width=600, height=480)
ggplot(NEI.L.B.Motor.year, aes(year, Emission)) +
  geom_point(size=4, aes(color=county, shape=county)) +
  geom_line(aes(group=county)) +
  ylab("Emission (Tons)") +
  ggtitle("Annual Emissions from Motor Vehicles/Motorsycles in Baltimore and LA")
dev.off()