% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blm.R
\name{update.blm}
\alias{update.blm}
\title{Update a blm distribution}
\usage{
\method{update}{blm}(object, formula = object$formula, beta = object$beta,
  prior = object, data = object$frame, ...)
}
\arguments{
\item{object}{a \code{blm} object.}

\item{formula}{a formula for the updated object.}

\item{beta}{precision estimate for the updated object.}

\item{prior}{prior distribution of the updated object.}

\item{data}{data of the updated object.}

\item{...}{other arguments. These are passed to blm.}
}
\value{
A object of class \code{blm}.
}
\description{
Updates a \code{blm} object, using new data, parameters 
 or a new model formula.
}
\details{
Updates a \code{\link{blm}} object, using features of the input 
  object, except, if provided otherwise. The prior for the updated object is 
  typically the posterior distribution of the input object, but can be 
  specified specifically (as for all other parameters). Importantly, new data
  will only be used when specified as named argument. \cr The function can
  also be used to update the model formula, as described for
  \code{\link{update}}.
}
\examples{
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 1.3 
  x <- rnorm(50) 
  y <- rnorm(50, w1 * x + w0, 1/b) 
  mod <- blm(y~x, beta=b, data=data.frame(x=x, y=y)) 
  mod
  
  #use of a prior, typically from an existing model 
  x2 <- rnorm(50) 
  y2 <- rnorm(50, w1 * x2 + w0, 1/b)
  
  #using posterior of mod as prior 
  new_mod <- update(mod, data=data.frame(x=x2, y=y2)) 
  new_mod
  
  #using same prior for mod and new model 
  new_mod2 <- update(mod, prior=mod$prior, data=data.frame(x=x2, y=y2)) 
  new_mod2
  
  #update model formula 
  new_mod2 <- update(mod, y~x+0, prior=mod$prior, 
                     data=data.frame(x=x2, y=y2)) 
  new_mod2
  
  #also works with standard R formula update semantics 
  new_mod2 <- update(mod, ~.+0, prior=mod$prior, data=data.frame(x=x2, y=y2)) 
  new_mod2
   
}

