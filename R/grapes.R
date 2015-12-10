#' Grape Harvest Dates
#' 
#' This function downloads a 650-year history of grape harvest dates in Western europe from a website by the \href{https://www.ncdc.noaa.gov/cdo/f?p=519:1:0::::P1_STUDY_ID:13194}{NOAA National Climatic Data Center}. The downloaded data is subsequently imported into \R and returned as a \code{\link{uts_vector}} object.
#' 
#' The data is available in Excel and raw text format on the NOAA website, but the latter has several formatting errors. Therefore, the data is imported from the Excel file using the \href{https://cran.r-project.org/web/packages/XLConnect/index.html}{XLConnect} package. Users who do not have this package installed or who want to save time, can access the already imported data using \code{data(grapes)}.
#' 
#' @keywords datasets
#' @examples
#' if (requireNamespace("XLConnect", quite=TRUE)) {
#'   grapes <- download_grapes()
#'   plot(grapes)
#' }
#' 
#' #' # Save data
#' \dontrun{
#'   save(grapes, file=file.path("data", "lynx_1942.rda"), compress="xz")
#' }
download_grapes <- function()
{
  if (!requireNamespace("XLConnect", quietly=TRUE))
    stop("Package 'XLConnect' needed for this function to work")
  
  # Download data into temporary file
  file <- "http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/europe2012ghd.xls"
  cat(paste0("Downloading the Western Europe 650 Year Grape Harvest Date Database from ", file, "\n"))
  cat("Please see https://www.ncdc.noaa.gov/paleo/study/13194 for a detailed description.\n")
  tmp_file <- tempfile()
  on.exit(unlink(tmp_file))
  download.file(file, destfile=tmp_file, mode="wb", quiet=TRUE)
  
  # Read data
  data <- XLConnect::readWorksheetFromFile(tmp_file, sheet=3, startRow=3, header=FALSE)
  
  # Clean data
  cnames <- c("year", data[1, -1])
  data <- data[-(1:2), ]
  colnames(data) <- cnames
  data <- sapply(data, as.numeric)
  
  # Convert to "uts_vector"
  times <- ISOdate(data[, "year"], month=8, day=31, hour=0, tz="cet")
  out <- uts_vector_wide(data[, -1], times)
  na.omit(out)
}
