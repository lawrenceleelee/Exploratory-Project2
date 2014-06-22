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

png(filename="plot3.png", width=480, height=480)
ggplot(Emission.Balti.year.type, aes(year, Emission)) +
  geom_line(size=1) + geom_point(size=5, aes(color=type)) +
  facet_wrap(~ type)
dev.off()