#' Paris Monthly Precipitation 1688-2009
#' 
#' This function creates the \code{\link{paris_precipitation}} dataset by downloading the data from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/8761}{NOAA National Climatic Data Center} and returning it as a \code{\link[uts]{uts}} object. It is not meant to be called directly, but provided for reproducability.
#' 
#' @keywords datasets internal
#' @examples
#' paris_precipitation <- download_paris_precipitation()
#' 
#' # Save data
#' \dontrun{
#'   save(paris_precipitation, file=file.path("data", "paris_precipitation.rda"), compress="xz")
#' }
download_paris_precipitation <- function()
{
  # Download data into temporary file
  file <- "http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/france/paris-precip-slonosky2002.txt"
  cat(paste0("Downloading the Paris precipitation data from ", file, "\n"))
  cat("Please see www.ncdc.noaa.gov/paleo/study/8761 for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, quiet=TRUE)
  
  # Read data
  data <- scan(tmp_file, what="character", skip=63, quiet=TRUE)
  
  # Determine observation times
  date_pos <- seq(1, length(data), by=13)
  years <- data[date_pos]
  times <- ISOdate(rep(years, each=12), month=1:12, day=1, hour=0, tz="cet")
  
  # Extract and clean observation values
  values <- as.numeric(data[-date_pos])
  values[values < 0] <- NA
  
  # Return "uts"
  na.omit(uts(values, times[1:length(values)]))
}


#' Paris Monthly Precipitation 1688-2009
#' 
#' The monthly precipitation (in mm) in Paris from 1688 to 2009.
#'
#' @format A \code{\link[uts]{uts}} object.
#'
#' @source This dataset was imported by \code{\link{download_paris_precipitation}} in January 2016 from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/8761}{NOAA National Climatic Data Center}.
#' @source Slonosky, V.C. 2002. Wet winters, dry summers? Three centuries of precipitation data from Paris Geophys. Res. Lett., Vol. 29(19), 1895
#' 
#' @name paris_precipitation
#' @keywords datasets
#' @examples
#' data(paris_precipitation)
#' plot(paris_precipitation, max_dt=ddays(31), type="o", cex=0.25)
#' 
#' # Most consecutive observations are one month apart
#' table(round(diff(time(paris_precipitation)) / 365 * 12))
#' 
#' # Plot 20-year two-sided rolling average
#' if (requireNamespace("utsOperators", quietly=TRUE)) {
#'   roll_avg <- utsOperators::rolling_apply(paris_precipitation, width=dyears(20), FUN=mean,
#'     align="center", interior=TRUE)
#'   plot(roll_avg, max_dt=dyears(1))
#' }
NULL
