% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binning.R
\name{binning}
\alias{binning}
\title{Signal binning}
\usage{
binning(X, bins, bin.size)
}
\arguments{
\item{X}{a numeric \code{data.frame}, \code{matrix} or \code{vector} to process.}

\item{bins}{the number of bins.}

\item{bin.size}{the desired size of the bins.}
}
\value{
a \code{matrix} or \code{vector} with average values per bin.
}
\description{
Compute average values of a signal in pre-determined bins (col-wise subsets).
The bin size can be determined either directly or by specifying the number of bins.
Sometimes called boxcar transformation in signal processing
}
\examples{
data(NIRsoil)
# conversion to reflectance
spc <- 1 / 10^NIRsoil$spc
wav <- as.numeric(colnames(spc))

# 5 first spectra
matplot(wav, t(spc[1:5, ]),
  type = "l",
  xlab = "Wavelength /nm",
  ylab = "Reflectance"
)
binned <- binning(spc, bin.size = 20)

# bin means
matpoints(as.numeric(colnames(binned)), t(binned[1:5, ]), pch = 1:5)

binned <- binning(spc, bins = 20)
dim(binned) # 20 bins

# 5 first spectra
matplot(wav, t(spc[1:5, ]),
  type = "l",
  xlab = "Wavelength /nm",
  ylab = "Reflectance"
)
# bin means
matpoints(as.numeric(colnames(binned)),
  t(binned[1:5, ]),
  pch = 1:5
)
}
\seealso{
\code{\link{savitzkyGolay}}, \code{\link{movav}}, \code{\link{gapDer}}, \code{\link{continuumRemoval}}
}
\author{
Antoine Stevens & Leonardo Ramirez-Lopez
}
