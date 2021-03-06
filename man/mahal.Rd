% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distribution.R
\name{mahal}
\alias{mahal}
\title{Mahalanobis Distance}
\usage{
mahal(object, x)
}
\arguments{
\item{object}{an object of class \code{mvnd}.}

\item{x}{a data point, provided as vector with same length as dimensions of
the \code{mvnd} object.}
}
\description{
Returns the Mahalanobis distance of a data point to a multivariate normal
distribution object of class \code{mvnd}.
}
\details{
Calls the base mahalanobis function \code{mahalanobis(x,
  object$means, object$covar)}
}
\examples{
d <- mvnd(c(0,1),matrix(c(2,3,3,2),ncol=2), c('a', 'b'))
mahal(d, c(1,1))
mahal(d, c(0,2))

}

