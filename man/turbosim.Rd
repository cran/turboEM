\name{turboSim}
\alias{turboSim}
\title{Conduct benchmark studies of EM accelerator}
\description{The \code{turboSim} function conducts benchmark studies to compare performance of multiple acceleration schemes over a large number of repetitions. The \code{\link{turboSim}} function outputs objects of class \code{turbosim}.}

\usage{
	turboSim(parmat, fixptfn, objfn, method = c("em", "squarem", "pem", "decme", "qn"), 
		 boundary, pconstr = NULL, project = NULL, parallel = FALSE, 
		 method.names, keep.pars = FALSE, ..., control.method = replicate(length(method),list()), control.run = list())
}

\arguments{
    \item{parmat}{A matrix of starting parameter values, where each row corresponds to a single benchmark study repetition.}

    \item{fixptfn}{A vector function, \eqn{F}{F} that denotes the fixed-point mapping. This function is the most essential input in the package. It should accept a parameter vector as input and should return a parameter vector of same length. This function defines the fixed-point iteration: \eqn{x_{k+1} = F(x_k)}{x[k+1] = F(x[k])}. In the case of EM algorithm, \eqn{F}{F} defines a single E and M step.} 

    \item{objfn}{This is a scalar function, \eqn{L}{L}, that denotes a ``merit'' function which attains its local minimum at the fixed-point of \eqn{F}{F}.  This function should accept a parameter vector as input and should return a scalar value.  In the EM algorithm, the merit function \eqn{L}{L} is the negative log-likelihood. In some problems, a natural merit function may not exist. However, this argument is required for all of the algorithms *except* Squarem (which defaults to Squarem-2 if \code{objfn} not provided) and EM.} 

    \item{method}{Specifies which algorithm(s) will be applied. Must be a vector containing one or more of \code{c("em", "squarem", "pem", "decme", "qn")}.}

    \item{boundary}{Argument required for Dynamic ECME (\code{decme}) only. Function to define the subspaces over which the line search is conducted.}

    \item{pconstr}{Optional function for defining boundary constraints on parameter values. Function maps a vector of parameter values to TRUE if constraints are satisfied. Note that this argument is only used for the Squarem (\code{squarem}), Parabolic EM (\code{pem}), and quasi-Newton (\code{qn}) algorithms, and it has no effect on the other algorithms.}

    \item{project}{Optional function for defining a projection that maps an out-of-bound parameter value into the constrained parameter space. Requires the \code{pconstr} argument to be specified in order for the \code{project} to be applied.}

    \item{parallel}{Logical indicating whether the \emph{repetitions} of the benchmark study will be run in parallel. Note that the parallel implementation is based on the \code{foreach} package, which depends on a \emph{parallel backend} being registered prior to running \code{turboSim()}. See *Details* of \code{\link{foreach}}.}

    \item{method.names}{Vector of unique names that identify the algorithms being compared.}

    \item{keep.pars}{Logical indicating whether the parameter values at termination should be kept. Defaults to FALSE.}

    \item{control.method}{If \code{method = c(method1, method2, ...)}, then \code{control.method = list(list1, list2, ...)} where \code{list1} is the list of control parameters for \code{method1}, \code{list2} is the list of control parameters for \code{method2}, and so on. If \code{length(method) == 1}, then \code{control.method} is the list of control parameters for the acceleration scheme.  
   	See *Details* of \code{\link{turboem}}.}

    \item{control.run}{List of control parameters for convergence and stopping the algorithms.
	See *Details* of \code{\link{turboem}}.}

    \item{...}{Arguments passed to \code{fixptfn} and  \code{objfn}.}
}

\value{
	\code{turboSim} returns an object of class \code{\link{turbosim}}.	
}

\seealso{
	\code{\link{turbosim}, \link{turboem}} 
}

\examples{

###########################################################################
# Examples provided in the vignette, which can be seen by typing
#  vignette("turboEM")

}