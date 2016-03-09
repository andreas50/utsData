#' Grape Harvest Dates
#' 
#' This function creates the \code{\link{grapes}} dataset by downloading the data from a website by the \href{https://www.ncdc.noaa.gov/cdo/f?p=519:1:0::::P1_STUDY_ID:13194}{NOAA National Climatic Data Center} and returning it as a \code{\link[utsMultivariate:uts_vector]{uts_vector}} object. It is not meant to be called directly, but provided for reproducability.
#' 
#' The raw data is available in Excel and raw text, but the latter has several formatting errors. Therefore, the data is imported from the Excel file using the \href{https://cran.r-project.org/web/packages/XLConnect/index.html}{XLConnect} package.
#' 
#' @keywords datasets internal
#' @examples
#' if (requireNamespace("XLConnect", quietly=TRUE)) {
#'   grapes <- download_grapes()
#'   
#'   \dontrun{
#'     save(grapes, file=file.path("data", "grapes.rda"), compress="xz")
#'   }
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
  out <- na.omit(out)
  
  # Remove non-ASCII characters
  names(out)[grepl("Poitou Charente", names(out))] <- "Vendee - Poitou Charente"
  out
}


#' Grape Harvest Dates
#' 
#' A 650-year history of grape harvest dates for 27 regions in Western Europe.
#'
#' @format A \code{\link[utsMultivariate]{uts_vector}} object. Harvest dates are presented as the number of days after 31 August.
#'
#' @source This dataset was imported by \code{\link{download_grapes}} in January 2016 from a website by the \href{https://www.ncdc.noaa.gov/cdo/f?p=519:1:0::::P1_STUDY_ID:13194}{NOAA National Climatic Data Center}.
#' @source Daux, V., I. Garcia de Cortazar-Atauri, P. Yiou, I. Chuine, E. Garnier, E. Le Roy Ladurie, O. Mestre, and J. Tardaguila. 2011. An open-database of Grape Harvest dates for climate research: data description and quality assessment. Climate of the Past, Vol. 8, pp. 1403-1418, 2012 www.clim-past.net/8/1403/2012/ doi:10.5194/cp-8-1403-2012
#' 
#' @name grapes
#' @keywords datasets
#' @examples
#' data(grapes)
#' plot(grapes$Burgundy)
#' 
#' # Connect observations less than two years apart by a line
#' plot(grapes$Bordeaux, max_dt=dyears(2), type="o", cex=0.5)
#' 
#' # Plot 20-year two-sided rolling average of Burgundy harvest dates
#' if (requireNamespace("utsOperators", quietly=TRUE)) {
#'   plot(utsOperators::rolling_apply(grapes$Burgundy, width=dyears(20), FUN=mean, align="center"))
#' }
NULL
