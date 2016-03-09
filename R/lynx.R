#' Annual Canadian Lynx Trappings 1821-1939
#' 
#' This function crates the \code{\link{lynx_1942}} data by importing the observations from a local CSV file and returning them as as \code{\link{uts_vector}} object. It is not meant to be called directly, but provided for reproducability.
#' 
#' @keywords datasets internal
#' @examples
#' # Show the raw data
#' file.show(system.file(file.path("exdata", "lynx_1942.csv"), package="utsData"))
#' 
#' # Import and save the data
#' lynx_1942 <- import_lynx_1942()
#' \dontrun{
#'   save(lynx_1942, file=file.path("data", "lynx_1942.rda"), compress="xz")
#' }
import_lynx_1942 <- function()
{
  # Read data
  file <- system.file(file.path("exdata", "lynx_1942.csv"), package="utsData")
  data <- read.csv(file, check.names=FALSE)
  
  # Convert to "uts_vector"
  times <- ISOdate(data$Year + 1, month=5, day=31, hour=0)
  out <- uts_vector_wide(data[,-1], times)
  na.omit(out)
}


#' Annual Canadian Lynx Trappings 1821-1939
#'
#' The annual number of Canadian lynx (\emph{Lynx canadensis}) catches by the Hudson's Bay Company. Each recorded year (called \emph{Outfit}) counts collected furs from 1 June of that year until 31 May of the following year.
#'
#' @format A \code{\link[utsMultivariate]{uts_vector}} object. An observation for date, let's say, 1840-05-31 represents the total number of lynx catches for outfit 1839, which ran from 1 June 1839 to 31 May 1840.
#'
#' @source Elton, C. and Nicholson, M. (1942). \href{http://www.jstor.org/stable/1358}{The Ten-Year Cycle in Numbers of the Lynx in Canada}. \emph{Journal of Animal Ecology}, Vol 11, No. 2, pp. 215-244.
#'
#' @seealso The \code{\link{lynx}} dataset in base \R is similar, except that it (i) contains data for only a single geographic region (instead of all eleven regions), (ii) has an obvious typo (compared to its quoted source).
#' 
#' @name lynx_1942
#' @keywords datasets
#' @examples
#' data(lynx_1942)
#' plot(lynx_1942[["MacKenzie River"]], log="y", type="o")
#' abline(v=date_decimal(seq(1820, 1930, by=10)), col="grey")
NULL
