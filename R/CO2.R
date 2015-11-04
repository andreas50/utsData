#' Mauna Loa Atmospheric CO2 Concentration
#' 
#' This function downloads the monthly average atmospheric CO2 concentration (in parts per million), as measured at the Mauna Loa observatory, from a website by the \href{http://www.esrl.noaa.gov/gmd/ccgg/trends/}{NOAA Earth System Research Laboratory}. The downloaded data is subsequently imported into \R and returned as a \code{\link{uts}} object. 
#' 
#' @param file the download location of the CO2 dataset.
#' 
#' @keywords datasets
#' @seealso The \code{\link[datasets:co2]{co2}} dataset in base \R is very similar, but ends in 1997 and has several missing values filled in using linear interpolation.
#' @examples
#' CO2 <- download_CO2()
#' plot(CO2)
#' table(diff(time(CO2)))    # most consecutive observations are one month apart
download_CO2 <- function(file="ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt")
{
  # Download data into temporary file
  cat(paste0("Downloading the Mauna Loa CO2 data from ", file, "\n"))
  cat("Please see www.esrl.noaa.gov/gmd/ccgg/trends/ for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, quiet=TRUE)
  
  # Import data & remove test section
  data <- scan(tmp_file, what="character", quiet=TRUE, sep="\n")
  start_pos <- grep("^1958", data)[1]
  data <- data[start_pos:length(data)]
  data_split <- sapply(data, strsplit, " +", USE.NAMES=FALSE)
  
  # Extract dates and move to middle of month
  year <- sapply(data_split, function(x) x[1])
  month <- sapply(data_split, function(x) x[2])
  start_of_month <- ISOdate(year, month, 1, hour=0, tz="HST")
  end_of_month <- lubridate::ceiling_date(start_of_month + lubridate::dseconds(1), unit="month")
  mid_month <- start_of_month + difftime(end_of_month, start_of_month) / 2
  
  # Extract observation values and return "uts" object
  values <- as.numeric(sapply(data_split, function(x) x[4]))
  values[values < 0] <- NA
  CO2 <- uts(values, mid_month)
  na.omit(CO2)
}
