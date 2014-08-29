\name{internal}
\alias{accelerate}
\alias{line.search}
\alias{search}
\alias{optimize.2d.app}
\alias{inv2}
\alias{bodyEM}
\alias{bodyParaEM}
\alias{bodyDECME}
\alias{bodyQuasiNewton}
\alias{bodySquarem1}
\alias{bodySquarem2}
\alias{bodyCyclem1}
\alias{bodyCyclem2}
\alias{combine}

\title{Internal functions for turboEM}
\description{turboEM functions not to be called by users.} 
\usage{
accelerate(par, fixptfn, objfn, method = c("em","squarem","pem","decme","qn"), 
  boundary = NULL, pconstr = NULL, project = NULL, ..., control = list())
}
\arguments{
	\item{par}{See \code{\link{turboem}}.}
	\item{fixptfn}{See \code{\link{turboem}}.} 
	\item{objfn}{See \code{\link{turboem}}.} 
	\item{method}{See \code{\link{turboem}}.} 
	\item{boundary}{See \code{\link{turboem}}.} 
	\item{pconstr}{See \code{\link{turboem}}.} 
	\item{control}{See \code{\link{turboem}}.}
	\item{...}{See \code{\link{turboem}}.}
}
\keyword{internal}
