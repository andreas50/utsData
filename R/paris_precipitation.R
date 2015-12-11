#' Paris Monthly Precipitation 1688-2009
#' 
#' This function downloads the monthly precipitation (in mm) in Paris from 1688 to 2009 from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/8761}{NOAA National Climatic Data Center}. The downloaded data is subsequently imported into \R and returned as a \code{\link{uts}} object.
#' 
#' Users without internet connection can access the already imported data using \code{data(paris_precipitation)}.
#' 
#' @keywords datasets internal
#' @examples
#' paris_precipitation <- dowload_paris_precipitation()
#' plot(paris_precipitation, max_dt=dyears(1), type="o", cex=0.5)
#' 
#' # Most consecutive observations are one month apart
#' table(round(diff(time(paris_precipitation)) / 365 * 12))
#' 
#' # Save data
#' \dontrun{
#'   save(paris_precipitation, file=file.path("data", "paris_precipitation.rda"), compress="xz")
#' }
dowload_paris_precipitation <- function()
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
