#' Mauna Loa Atmospheric CO2 Concentration (Latest Data)
#' 
#' This function downloads the monthly average atmospheric CO2 concentration (in parts per million), as measured at the \href{http://www.esrl.noaa.gov/gmd/obop/mlo/}{Mauna Loa observatory}, from a website by the \href{http://www.esrl.noaa.gov/gmd/ccgg/trends/}{NOAA Earth System Research Laboratory}. The downloaded data is subsequently imported into \R and returned as a \code{\link[uts:uts]{uts}} object. 
#' 
#' @seealso Users without internet connection can access the already imported data via \code{\link{co2_ml}}. However, to get the most recent data it is recommended to use this function.
#' @seealso \code{\link{co2_20ma}} for a 20 million year reconstruction.
#' @seealso The \code{\link[datasets:co2]{co2}} dataset in base \R is very similar, but ends in 1997 and has several missing values filled in using linear interpolation.
#' 
#' @keywords datasets
#' @examples
#' co2_ml <- download_co2_ml()
#' plot(co2_ml)
#' table(round(diff(co2_ml$times) * 12 / 365))  # most observations are one month apart
#' 
#' # Save data
#' \dontrun{
#'   save(co2_ml, file=file.path("data", "co2_ml.rda"), compress="xz")
#' }
download_co2_ml <- function()
{
  # Download data into temporary file
  file <- "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt"
  cat(paste0("Downloading the Mauna Loa CO2 data from ", file, "\n"))
  cat("Please see www.esrl.noaa.gov/gmd/ccgg/trends/ for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, quiet=TRUE)
  
  # Import data & remove text section
  data <- scan(tmp_file, what="character", quiet=TRUE, sep="\n")
  start_pos <- grep("^1958", data)[1]
  data <- data[start_pos:length(data)]
  data_split <- sapply(data, strsplit, " +", USE.NAMES=FALSE)
  
  # Extract dates and move to middle of month
  year <- sapply(data_split, function(x) x[1])
  month <- sapply(data_split, function(x) x[2])
  start_of_month <- ISOdate(year, month, 1, hour=0, tz="HST")
  end_of_month <- ceiling_date(start_of_month + dseconds(1), unit="month")
  mid_month <- start_of_month + difftime(end_of_month, start_of_month) / 2
  
  # Extract observation values and return "uts" object
  values <- as.numeric(sapply(data_split, function(x) x[4]))
  values[values < 0] <- NA
  CO2 <- uts(values, mid_month)
  na.omit(CO2)
}


#' Mauna Loa Atmospheric CO2 Concentration
#'
#' The monthly average atmospheric CO2 concentration (in parts per million), as measured at the \href{http://www.esrl.noaa.gov/gmd/obop/mlo/}{Mauna Loa observatory}.
#'
#' @format A \code{\link[uts:uts]{uts}} object.
#'
#' @source This dataset was imported by \code{\link{download_co2_ml}} in December 2015 from a website by the \href{http://www.esrl.noaa.gov/gmd/ccgg/trends/}{NOAA Earth System Research Laboratory}.
#' @source Dr. Pieter Tans, NOAA/ESRL (www.esrl.noaa.gov/gmd/ccgg/trends/) and Dr. Ralph Keeling, Scripps Institution of Oceanography (scrippsco2.ucsd.edu/).
#'
#' @seealso \code{\link{download_co2_ml}} gets the most recent data.
#' @seealso \code{\link{co2_20ma}} for a 20 million year reconstruction.
#' @seealso The \code{\link[datasets:co2]{co2}} dataset in base \R is very similar, but ends in 1997 and has several missing values filled in using linear interpolation.
#' 
#' @name co2_ml
#' @keywords datasets
#' @examples
#' data(co2_ml)
#' plot(co2_ml)
#' 
#' # Most consecutive observations are one month apart
#' table(round(diff(co2_ml$times) * 12 / 365))
NULL

