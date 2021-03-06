% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/co2_20ma.R
\name{download_co2_20ma}
\alias{download_co2_20ma}
\title{20 Million Year Atmospheric CO2 Reconstruction}
\usage{
download_co2_20ma()
}
\description{
This function creates the \code{\link{co2_20ma}} dataset by downloading the data from a website by the \href{https://www.ncdc.noaa.gov/paleo/study/10423}{NOAA Earth System Research Laboratory} and returning it as a \code{\link[uts]{uts}} object. It is not meant to be called directly, but provided for reproducability.
}
\examples{
co2_20ma <- download_co2_20ma()

# Save the data
\dontrun{
  save(co2_20ma, file=file.path("data", "co2_20ma.rda"), compress="xz")
}
}
\keyword{datasets}
\keyword{internal}
