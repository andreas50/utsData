#' Daily Sunspot Numbers (Latest Data)
#' 
#' Download the daily number of sunspots since 1818 from \url{http://www.sidc.be/silso/datafiles}. The data is subsequently imported into \R and returned as a \code{\link[utsMultivariate:uts_vector]{uts_vector}} object. 
#' 
#' @seealso Users without internet connection can access the already imported data via \code{\link{sunspots_daily}}. However, to get the most recent data it is recommended to use this function.
#' 
#' @examples
#' \dontrun{
#'   # Download and save the data
#'   sunspots_daily <- download_sunspots_daily()
#'   save(sunspots_daily, file=file.path("data", "sunspots_daily.rda"), compress="xz")
#' }
download_sunspots_daily <- function()
{
  # Download data
  file <- "http://www.sidc.be/silso/DATA/SN_d_tot_V2.0.txt"
  cat(paste0("Downloading the daily sunspots data from ", file, "\n"))
  cat("Please see www.sidc.be/silso/datafiles for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, quiet=TRUE)
  
  # Import data & split fields
  data <- scan(tmp_file, what="character", quiet=TRUE, sep="\n")
  year <- as.integer(substr(data, 1, 4))
  month <- as.integer(substr(data, 6, 7))
  day <- as.integer(substr(data, 9, 10))
  number <- as.integer(substr(data, 22, 24))
  sd <- as.numeric(substr(data, 26, 30))
  num_obs <- as.integer(substr(data, 33, 35))
  
  # Return as "uts_vector"
  times <- ISOdate(year, month, day, hour=12, tz="cet")
  out <- uts_vector(number=uts(number, times), sd=uts(sd, times), num_obs=uts(num_obs, times))
  
  # Drop missing observations (encoded as "-1")
  warning("Reactivate once have Ops.uts_vector")
  #out[out$number >= 0, ]
  out
}


#' Daily Sunspot Numbers
#' 
#' The daily number of sunspots since 1818.
#'
#' @format A \code{\link[utsMultivariate:uts_vector]{uts_vector}} object. The first time series contains the estimated daily total number of sunspots. The second time series is the estimated standard deviation of the raw numbers provided by all measurement stations. The third time series contains the number of observations used to compute the daily estimate. 
#'
#' @source This dataset was imported by \code{\link{download_sunspots_daily}} in December 2015 from \url{http://www.sidc.be/silso/datafiles}. For a detailed description see \url{http://www.sidc.be/silso/infosndtot}.
#' @source WDC-SILSO, Royal Observatory of Belgium, Brussels
#' 
#' @seealso \code{\link{download_sunspots_daily}} gets the most recent data.
#' @seealso For \emph{monthly} sunspot numbers, see \code{\link[datasets:sunspot.month]{sunspot.month}} and \code{\link[datasets:sunspots]{sunspots}} in base \R.
#' @seealso For \emph{yearly} sunspot numbers, see \code{\link[datasets:sunspot.year]{sunspot.year}} in base \R.
#' 
#' @name sunspots_daily
#' @keywords datasets
#' @examples
#' data(sunspots_daily)
#' plot(sunspots_daily$number)
#' plot(sunspots_daily$num_obs)
#' 
#' # Examine observation time differences
#' times <- sunspots_daily$number$times
#' table(round(difftime(times[-1], times[-length(times)], unit="day")))
NULL