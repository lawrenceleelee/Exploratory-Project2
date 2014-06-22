SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
library(data.table)
NEI <- data.table(NEI)
SCC <- data.table(SCC)
Emission.total <- NEI[,sum(Emissions),by=year]
setnames(Emission.total, "V1", "Emission")
Emission.Balti.year <- NEI[fips == "24510", sum(Emissions), by=year]
setnames(x=Emission.Balti.year, old="V1", new="Emission")

png(filename="plot2.png", width=480, height=480)
plot(Emission.Balti.year$year, Emission.Balti.year$Emission, type="b",
     xlab="Year", xaxt="n",
     ylab=expression(PM[2.5] * " Emission in Baltimore (Tons)"),
     main=expression(PM[2.5] * " Emission across Years in Baltimore"))
axis(side=1, at=c(1999, 2002, 2005, 2008))
dev.off()