#' Import Lynx Data
#' 
#' This function imports the lynx data from Elton and Nicholson (1942) from a local CSV file provided by the \code{utsData} package. It subsequently returns the data as as \code{uts_vector} object.
#' 
#' @keywords datasets
#' @seealso The \code{\link[datasets:lynx]{lynx}} dataset in base \R is similar, except that it: \itemize{
#'   \item contains data for only a single geographic region (instead of all eleven regions),
#'   \item has an obvious typo (compared to its quoted source).
#' }
#' 
#' @references Elton, C. and Nicholson, M. (1942). \href{http://www.jstor.org/stable/1358}{The Ten-Year Cycle in Numbers of the Lynx in Canada}. \emph{Journal of Animal Ecology}, Vol 11, No. 2, pp. 215-244
#' 
#' @examples
#' #lynx42 <- import_lynx()
#' #save(lynx_1942, file="lynx42.rda")
#' #plot(lynx42, max_dt=dyears(2), type="o", cex=0.5)    # not implemented yet
import_lynx <- function()
{
  # Read data
  stop("Not implemented yet, because depends on 'uts_vector' package")
  file <- system.file(file.path("exdata", "lynx_1942.csv"), package="utsData")
  data <- read.csv(file, check.names=FALSE)
  
  # Convert to "uts_vector"
}
