% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blm.R
\name{covar.blm}
\alias{covar.blm}
\title{Covariance of coefficients}
\usage{
covar.blm(object, ...)
}
\arguments{
\item{object}{a \code{blm} object.}

\item{...}{other arguments (currently ignored).}
}
\value{
Covariance matrix for the distribution of the coefficients of a 
 \code{\link{blm}} model.
}
\description{
Covariance of coefficients from the posterior distribution of a bayesian 
 model.
}
\examples{
x <- rnorm(10)
b <- 1.3
w0 <- 0.2 ; w1 <- 3
y <- rnorm(10, mean = w0 + w1 * x, sd = sqrt(1/b))
model <- blm(y ~ x, prior = NULL, beta = b, data = data.frame(x=x, y=y))

covar.blm(model)

}

