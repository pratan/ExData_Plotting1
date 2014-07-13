## plot2.R

## retrieve data for Feb 1
feb1_data <- scan( pipe( "grep \"^1\\/2\\/2007\" exdata-data-household_power_consumption/household_power_consumption.txt" ), what=list(fline="") )

## retrieve data for Feb 2
feb2_data <- scan( pipe( "grep \"^2\\/2\\/2007\" exdata-data-household_power_consumption/household_power_consumption.txt"), what=list(fline="") )

## feb1_data & feb2_data contain a list of list of characters that look like this:
## $ fline: chr [1:1440] "1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000" "1/2/2007;00:01:00;0.326;0.130;243.320;1.400

## splitting the character strings by ";"
mm1 <- lapply( feb1_data$fline, function(x) { strsplit(x, ";") } )
mm2 <- lapply( feb2_data$fline, function(x) { strsplit(x, ";") } )

## mm1 & mm2 contain a list of characters like this :
## > str(mm1)
##List of 1440
## $ :List of 1
##  ..$ : chr [1:9] "1/2/2007" "00:00:00" "0.326" "0.128" ...
## $ :List of 1
##  ..$ : chr [1:9] "1/2/2007" "00:01:00" "0.326" "0.130" ...
## $ :List of 1
##  ..$ : chr [1:9] "1/2/2007" "00:02:00" "0.324" "0.132" ...

## combine the two lists
mm <- c(mm1, mm2)

## mm is a list with 9 rows and 2880 columns. 
## We need a data frame of 2880 rows and 9 columns. Note that the following command:
##     as.data.frame(mm)
## results in a data frame with 9 rows and 2880 columns.
## So, using a brute force method of looping through the list mm.

df <- data.frame( date="", time="", global_active_power="", global_reactive_power="", voltage="", 
	global_intensity="", sub_metering_1="", sub_metering_2="", sub_metering_3="", stringsAsFactors=FALSE )

    ## stringsAsFactors=FALSE is important as otherwise R will make assumptions about the factors associated with the columns

numrows <- length(mm)

for ( n in 1:numrows ) {
    x <- mm[[n]]
	df[n, ] <- x[[1]]  ## x[[1]] retrieves the character string list
}

plot(df$global_active_power, type="l", ylab="Global Active Power (kilowatts)", xaxt="n")
axis( side=1, at=c(1, 1440, 2880), labels=c("Thu", "Fri", "Sat") )

dev.copy("plot2.png")
dev.off()