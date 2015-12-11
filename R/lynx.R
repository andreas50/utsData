#' Import Lynx Data
#' 
#' This function imports the lynx data from Elton and Nicholson (1942) from a local CSV file. It subsequently returns the data as as \code{\link{uts_vector}} object.
#' 
#' @keywords datasets
#' @seealso The \code{\link[datasets:lynx]{lynx}} dataset in base \R is similar, except that it: \itemize{
#'   \item contains data for only a single geographic region (instead of all eleven regions),
#'   \item has an obvious typo (compared to its quoted source).
#' }
#' 
#' @references Elton, C. and Nicholson, M. (1942). \href{http://www.jstor.org/stable/1358}{The Ten-Year Cycle in Numbers of the Lynx in Canada}. \emph{Journal of Animal Ecology}, Vol 11, No. 2, pp. 215-244
#' 
#' @keywords datasets internal
#' @examples
#' lynx_1942 <- import_lynx()
#' plot(lynx_1942[["MacKenzie River"]])
#' #plot(lynx_1942, max_dt=dyears(2), type="o", cex=0.5)    # not implemented yet
#' 
#' # Save data
#' \dontrun{
#'   save(lynx_1942, file=file.path("data", "lynx_1942.rda"), compress="xz")
#' }
import_lynx <- function()
{
  # Read data
  file <- system.file(file.path("exdata", "lynx_1942.csv"), package="utsData")
  data <- read.csv(file, check.names=FALSE)
  
  # Convert to "uts_vector"
  times <- ISOdate(data$Year, month=1, day=1, hour=0)
  out <- uts_vector_wide(data[,-1], times)
  na.omit(out)
}

