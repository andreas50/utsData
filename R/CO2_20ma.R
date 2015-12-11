#' 20 Million Year Atmospheric CO2 Reconstruction
#' 
#' This function downloads a 20 million year (ma) reconstruction of the atmposheric CO2 concentration (in parts per million) from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/10423}{NOAA Earth System Research Laboratory}. The downloaded data is subsequently imported into \R and returned as a \code{\link[uts:uts]{uts}} object. 
#' 
#' @seealso Users without internet connection can access the already imported data via \code{\link{co2_20ma}}.
#' @seealso \code{\link{co2_ml}} for monthly data since 1958.
#' @seealso \code{\link[datasets:co2]{co2}} in base \R.
#'
#' @keywords datasets internal
#' @examples 
#' co2_20ma <- download_co2_20ma()
#' plot(co2_20ma, max_dt=dyears(1e6), type="o")      # connect observations less than 1 ma apart
#' plot(tail_t(co2_20ma, dyears(1.5e6)),  type="o")  # plot the 1.5 million most recent years
#' 
#' # Save data
#' \dontrun{
#'   save(co2_20ma, file=file.path("data", "co2_20ma.rda"), compress="xz")
#' }
download_co2_20ma <- function()
{
  # Download data into temporary file
  file <- "http://www1.ncdc.noaa.gov/pub/data/paleo/contributions_by_author/tripati2009/tripati2009.txt"
  cat(paste0("Downloading the Atmospheric CO2 20 Million Year Reconstruction data from ", file, "\n"))
  cat("Please see www.ncdc.noaa.gov/paleo/study/10423 for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, quiet=TRUE)
  
  # Import data
  data <- scan(tmp_file, what="character", quiet=TRUE, sep="\n")
  start_pos <- grep("pCO2avg", data, fixed=TRUE) + 1
  data <- data[start_pos:length(data)]
  
  # Clean data
  age_ma <- as.numeric(substr(data, 1, 5))
  CO2 <- as.numeric(substr(data, 14, 16))
  
  # Sort data chronologically
  pos <- order(age_ma, decreasing=TRUE)
  age_ma <- age_ma[pos]
  CO2 <- CO2[pos]
  
  # Determine observation times
  # -) need to generate indirectly, because strptime(), which is used by ISOdate(), only accepts years 0:9999 as input
  times <- as.POSIXlt(ISOdate(2000, month=1, day=1, hour=0) + dyears(rep(0, length(age_ma))))
  times$year <- times$year - age_ma * 1e6
  times <- as.POSIXct(times)
  
  # Return "uts" object
  uts(CO2, times)
}


#' 20 Million Year Atmospheric CO2 Reconstruction
#'
#' A 20 million year (ma) reconstruction of the atmposheric CO2 concentration (in parts per million).
#'
#' @format A \code{\link[uts:uts]{uts}} object.
#'
#' @source This dataset was imported by \code{\link{download_co2_20ma}} from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/10423}{NOAA Earth System Research Laboratory}.
#'
#' @seealso \code{\link{download_co2_20ma}}
#' @seealso \code{\link{co2_ml}} for monthly data since 1958.
#' @seealso \code{\link[datasets:co2]{co2}} in base \R.
#' 
#' @name co2_20ma
#' @keywords datasets
#' @examples
#' data(co2_20ma)
#' plot(co2_20ma, max_dt=dyears(1e6), type="o")      # connect observations less than 1 ma apart
#' plot(tail_t(co2_20ma, dyears(1.5e6)),  type="o")  # plot the 1.5 million most recent years
NULL
