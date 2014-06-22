SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
library(data.table)
NEI <- data.table(NEI)
SCC <- data.table(SCC)
Emission.total <- NEI[,sum(Emissions),by=year]
setnames(Emission.total, "V1", "Emission")

png(filename="plot1.png", width=480, height=480)
plot(Emission.total$year, Emission.total$Emission, type="b",
     xlab="Year", xaxt="n",
     ylab=expression(PM[2.5] * " Emission (Tons)"),
     main=expression(PM[2.5] * " Emission across Years"))
axis(side=1, at=c(1999, 2002, 2005, 2008))
dev.off()