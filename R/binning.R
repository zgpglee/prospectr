#' @title Signal binning
#' @description
#' Compute average values of a signal in pre-determined bins (col-wise subsets).
#' The bin size can be determined either directly or by specifying the number of bins.
#' Sometimes called boxcar transformation in signal processing
#' @usage
#' binning(X, bins, bin.size)
#' @param X a numeric `data.frame`, `matrix` or `vector` to process.
#' @param bins the number of bins.
#' @param bin.size the desired size of the bins.
#' @author Antoine Stevens & Leonardo Ramirez-Lopez
#' @examples
#' data(NIRsoil)
#' # conversion to reflectance
#' spc <- 1 / 10^NIRsoil$spc
#' wav <- as.numeric(colnames(spc))
#'
#' # 5 first spectra
#' matplot(wav, t(spc[1:5, ]),
#'   type = "l",
#'   xlab = "Wavelength /nm",
#'   ylab = "Reflectance"
#' )
#' binned <- binning(spc, bin.size = 20)
#'
#' # bin means
#' matpoints(as.numeric(colnames(binned)), t(binned[1:5, ]), pch = 1:5)
#'
#' binned <- binning(spc, bins = 20)
#' dim(binned) # 20 bins
#'
#' # 5 first spectra
#' matplot(wav, t(spc[1:5, ]),
#'   type = "l",
#'   xlab = "Wavelength /nm",
#'   ylab = "Reflectance"
#' )
#' # bin means
#' matpoints(as.numeric(colnames(binned)),
#'   t(binned[1:5, ]),
#'   pch = 1:5
#' )
#' @return a `matrix` or `vector` with average values per bin.
#' @seealso \code{\link{savitzkyGolay}}, \code{\link{movav}}, \code{\link{gapDer}}, \code{\link{continuumRemoval}}
#' @export
#'
binning <- function(X, bins, bin.size) {
  if (is.data.frame(X)) {
    X <- as.matrix(X)
  }
  if (!missing(bins) & !missing(bin.size)) {
    stop("EITHER 'bins' OR 'bin.size' must be specified")
  }
  if (missing(bins) & missing(bin.size)) {
    return(X)
  }

  if (is.matrix(X)) {
    p1 <- ncol(X)
  } else {
    p1 <- length(X)
  }

  if (missing(bins) & !missing(bin.size)) {
    b <- findInterval(1:p1, seq(1, p1, bin.size))
  } else {
    b <- findInterval(1:p1, seq(1, p1, length.out = bins + 1), rightmost.closed = TRUE)
  }

  p2 <- max(b)

  if (is.matrix(X)) {
    output <- matrix(0, nrow(X), p2)
    for (i in seq_len(p2)) {
      output[, i] <- rowMeans(X[, b == i, drop = F])
    }
    colnames(output) <- colnames(X)[ceiling(tapply(b, b, function(x) mean(which(b == x[1]), na.rm = TRUE)))] # find colnames
    rownames(output) <- rownames(X)
  } else {
    output <- tapply(X, b, mean)
    names(output) <- names(X)[ceiling(tapply(b, b, function(x) mean(which(b == x[1]), na.rm = TRUE)))]
  }

  return(output)
}
