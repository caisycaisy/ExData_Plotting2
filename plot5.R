
##########################################################################################
#Exploratory Data Analysis Course Project 2

#Fine particulate matter (PM2.5) is an ambient air pollutant for which 
#there is strong evidence that it is harmful to human health. 
#In the United States, the Environmental Protection Agency (EPA) is tasked with 
#setting national ambient air quality standards for fine PM and 
#for tracking the emissions of this pollutant into the atmosphere. 
#Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. 
#This database is known as the National Emissions Inventory (NEI).

#For each year and for each type of PM source, the NEI records 
#how many tons of PM2.5 were emitted from that source over the course of the entire year.
##########################################################################################

#####################
#Download the file
#####################

setwd("C:\\Users\\ASUS\\Desktop\\Data Science\\Exploratory Data Analysis\\Course Project 2")
fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile="C:\\Users\\ASUS\\Desktop\\Data Science\\Exploratory Data Analysis\\Course Project 2\\summarySCC_PM25.zip")
unzip(zipfile="C:\\Users\\ASUS\\Desktop\\Data Science\\Exploratory Data Analysis\\Course Project 2\\summarySCC_PM25.zip")

##########################################################
#read the two files and further pre-processing of the data 
##########################################################

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

colToFactor <- c("year", "type", "Pollutant","SCC","fips")
NEI[,colToFactor] <- lapply(NEI[,colToFactor], factor)

################################################
#How have emissions from motor vehicle sources
#changed from 1999¡V2008 in Baltimore City?
################################################

Vehicle<-grepl(pattern = "vehicle", SCC$EISector, ignore.case = TRUE)
VehicleSCC <- SCC[Vehicle,]$SCC

VehicleNEI <- NEI[NEI$SCC %in% VehicleSCC, ]
BaltimoreVehicleNEI <- subset(VehicleNEI, fips == "24510")
BaltimoreVehicle.totalEmissions<-aggregate(Emissions~year, BaltimoreVehicleNEI, sum)

png(filename='plot5.png',width=480,height=480,units='px')
    g<-ggplot(aes(year, Emissions), data=BaltimoreVehicle.totalEmissions)
    g+geom_bar(stat="identity") +
      guides(fill=FALSE) +
      labs(x="Year", y=expression("PM2.5 Emissions (Tons)")) + 
      labs(title=expression("Total PM2.5 emission from motor vehicle sources in the Baltimore city"))
x<-dev.off()

