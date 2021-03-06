% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convertbeta.R
\name{convertbeta}
\alias{convertbeta}
\title{The convertbeta() function}
\usage{
convertbeta(X, Y, q, beta0)
}
\arguments{
\item{X}{It is a dataset of explanatory variables.}

\item{Y}{It is the multivariate response variables.}

\item{q}{It is an integer representing the number of explanatory variables 
and intercept.}

\item{beta0}{The vector contains the regression coefficients result from
sparsenetgls.}
}
\value{
Return the list of converted regression coefficients of the
explanatory variables 'betaconv' and intercept value 'betaconv_int'.
}
\description{
The covertbeta function is designed to convert the regression
coefficients derived from the standardized data.
}
\examples{
X <- mvrnorm(n=20,mu=rep(0,5),Sigma=Diagonal(5,rep(1,5)))
Y <- mvrnorm(n=20,mu=rep(0.5,10),Sigma=Diagonal(10,rep(1,10)))
fitmodel <-  sparsenetgls(responsedata=Y,predictdata=X,nlambda=5,ndist=2,
method='elastic')
#Example of converting the regression coef of the first lamda
convertbeta(X=X,Y=Y,q=5+1,beta0=fitmodel$beta[,1])

}
