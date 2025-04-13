\name{turboem}
\alias{turboem}
\title{A suite of acceleration schemes for fixed-point iterations}
\description{Globally-convergent, partially monotone, acceleration schemes for accelerating the convergence of \emph{any} smooth, monotone, slowly-converging contraction mapping. It can be used to accelerate the convergence of a wide variety of iterations including the expectation-maximization (EM) algorithms and its variants, majorization-minimization (MM) algorithm, power method for dominant eigenvalue-eigenvector, Google's page-rank algorithm, and multi-dimensional scaling.
}
\usage{
turboem(par, fixptfn, objfn, method = c("em","squarem","pem","decme","qn"), 
        boundary, pconstr = NULL, project = NULL, parallel = FALSE, ..., 
        control.method = replicate(length(method),list()), control.run = list())
}
\arguments{
    \item{par}{A vector of parameters denoting the initial guess for the fixed point.}

    \item{fixptfn}{A vector function, \eqn{F}{F} that denotes the fixed-point mapping. This function is the most essential input in the package. It should accept a parameter vector as input and should return a parameter vector of same length. This function defines the fixed-point iteration: \eqn{x_{k+1} = F(x_k)}{x[k+1] = F(x[k])}. In the case of EM algorithm, \eqn{F}{F} defines a single E and M step.} 

    \item{objfn}{This is a scalar function, \eqn{L}{L}, that denotes a ``merit'' function which attains its local minimum at the fixed-point of \eqn{F}{F}.  This function should accept a parameter vector as input and should return a scalar value.  In the EM algorithm, the merit function \eqn{L}{L} is the negative log-likelihood. In some problems, a natural merit function may not exist. However, this argument is required for all of the algorithms *except* Squarem (which defaults to Squarem-2 if \code{objfn} not provided) and EM.} 

    \item{method}{Specifies which algorithm(s) will be applied. Must be a vector containing one or more of \code{c("em", "squarem", "pem", "decme", "qn")}.}

    \item{boundary}{Argument required for Dynamic ECME (\code{decme}) only. Function to define the subspaces over which the line search is conducted.}

    \item{pconstr}{Optional function for defining boundary constraints on parameter values. Function maps a vector of parameter values to TRUE if constraints are satisfied. Note that this argument is only used for the Squarem (\code{squarem}), Parabolic EM (\code{pem}), and quasi-Newton (\code{qn}) algorithms, and it has no effect on the other algorithms.}

    \item{project}{Optional function for defining a projection that maps an out-of-bound parameter value into the constrained parameter space. Requires the \code{pconstr} argument to be specified in order for the \code{project} to be applied.}

    \item{parallel}{Logical indicating whether the acceleration schemes will be run in parallel. Note that the parallel implementation is based on the \code{foreach} package, which depends on a \emph{parallel backend} being registered prior to running \code{turboem()}. See *Details* of \link[foreach:foreach]{foreach}}.

    \item{control.method}{If \code{method = c(method1, method2, ...)}, then \code{control.method = list(list1, list2, ...)} where \code{list1} is the list of control parameters for \code{method1}, \code{list2} is the list of control parameters for \code{method2}, and so on. If \code{length(method) == 1}, then \code{control.method} is the list of control parameters for the acceleration scheme.  
   	See *Details*.}

    \item{control.run}{List of control parameters for convergence and stopping the algorithms.
	See *Details*.}

    \item{...}{Arguments passed to \code{fixptfn} and  \code{objfn}.}
}

\value{\code{turboem} returns an object of class \code{turbo}. An object of class \code{turbo} is a list containing at least the following components:

	\item{fail}{Vector of logical values whose \eqn{j}{j}th element indicates whether algorithm \eqn{j}{j} failed (produced an error)}

	\item{value.objfn}{Vector of the value of the objective function \eqn{L}{L} at termination for each algorithm.}

	\item{itr}{Vector of the number of iterations completed for each algorithm.}

	\item{fpeval}{Vector of the number of fixed-point evaluations completed for each algorithm.}

	\item{objfeval}{Vector of the number of objective function evaluations completed for each algorithm.}

	\item{convergence}{Vector of logical values whose \eqn{j}{j}th element indicates whether algorithm \eqn{j}{j} satisfied the convergence criterion before termination}

	\item{runtime}{Matrix whose \eqn{j}{j}th row contains the ``user'', ``system'', and ``elapsed'' time for running the \eqn{j}{j}th algorithm.}

	\item{errors}{Vector whose \eqn{j}{j}th element is either NA or contains the error message from running the \eqn{j}{j}th algorithm}

	\item{pars}{Matrix whose \eqn{j}{j}th row contains the fixed-point parameter values at termination for the \eqn{j}{j}th algorithm.}

	\item{trace.objfval}{If \code{control.run[["keep.objfval"]]=TRUE}, contains a list whose \eqn{j}{j}th component is a vector of objective function values across iterations for the \eqn{j}{j}th algorithm.}
	
	\item{trace.paramval}{If \code{control.run[["keep.paramval"]]=TRUE}, contains a list whose \eqn{j}{j}th component is a matrix of parameter estimates across iterations for the \eqn{j}{j}th algorithm.}
	
}

\details{The function \code{turboem} is a general-purpose algorithm for accelerating the convergence of any slowly-convergent (smooth) fixed-point iteration.  

The component lists of the \code{control.method} are used to specify any changes to default values of algorithm control parameters. Full names of control list elements must be specified, otherwise, user specifications are ignored. Default control parameters for \code{method="squarem"} are \code{K=1}, \code{square=TRUE}, \code{version=3}, \code{step.min0=1}, \code{step.max0=1}, \code{mstep=4}, \code{kr=1}, \code{objfn.inc=1}. Default control parameters for \code{method="pem"} are \code{l=10}, \code{h=0.1}, \code{a=1.5}, and \code{version="geometric"}. Default control parameters for \code{method="decme"} are \code{version="v2"} and \code{tol_op=0.01}. Default control parameters for \code{method="qn"} are \code{qn=5}.

Default values of \code{control.run} are: \code{convtype = "parameter"}, \code{tol = 1.0e-07}, \code{stoptype = "maxiter"}, \code{maxiter = 1500}, \code{maxtime = 60}, \code{convfn.user = NULL}, \code{stopfn.user = NULL}, \code{trace = FALSE}, \code{keep.objfval = FALSE}, \code{keep.paramval = FALSE}.
    
There are two ways the algorithm will terminate. Either the algorithm will terminate if convergence has been achieved, or the algorithm will terminate if convergence has not been achieved within a pre-specified maximum number of iterations or maximum running time. The arguments \code{convtype}, \code{tol}, and \code{convfn.user} control the convergence criterion. The arguments \code{stoptype}, \code{maxiter}, \code{maxtime}, and \code{stopfn.user} control the alternative stopping criterion.

Two types of convergence criteria have been implemented, with an option for the user to define his/her own convergence criterion. If \code{convtype = "parameter"}, then the default convergence criterion is to terminate if \code{sqrt(crossprod(new - old)) < tol}, where \code{new} denotes the current value of the fixed point and \code{old} denotes the previous fixed-point value. If \code{convtype = "objfn"}, then the default convergence criterion is to terminate if \code{abs(new - old) < tol}, where \code{new} denotes the current value of the objective function and \code{old} denotes the previous value of the objective function.
If the user desires alternate convergence criteria,  \code{convfn.user} may be specified as a function with inputs \code{new} and \code{old} that maps to a logical taking the value TRUE if convergence is achieved and the value FALSE if convergence is not achieved. 

Two types of alternative stopping criteria have been implemented, with the option for the user to define his/her own stopping criterion. If \code{stoptype = "maxiter"}, then the algorithm will terminate if convergence has not been achieved within \code{maxiter} iterations of the acceleration scheme. If \code{stoptype = "maxtime"}, then the algorithm will terminate if convergence has not been achieved within \code{maxtime} seconds of running the acceleration scheme. Note: the running time of the acceleration scheme is calculated once every iteration. If the user desires different alternate stopping criteria than those implemented, \code{stopfn.user} may be specified as a function with no inputs that maps to a logical taking the value TRUE which leads to the algorithm being terminated or the value FALSE which leads to the algorithm proceeding as usual.

\describe{
	\item{\code{convtype}}{A character string equal to \code{"parameter"} or \code{"objfn"}. \code{"parameter"} indicates that the convergence criterion is a function of the current and previous value of the fixed point. \code{objfn} indicates that the convergence criterion is a function of the current and previous value of the objective function.}
	
	\item{\code{tol}}{A small, positive scalar that determines when convergence is achieved. See details above for convergence criteria currently implemented. Default is \code{1.e-07}.}
	
	\item{\code{stoptype}}{A character string equal to \code{"maxiter"} or \code{"maxtime"} that determines an alternative stopping rule for the algorithm. See details above for stopping rules currently implemented. Default is \code{"maxiter"}.}
	
	\item{\code{maxiter}}{If \code{stoptype = "maxiter"}, specifies the number of iterations after which the algorithm will be terminated if convergence has not been achieved. Default is 1500.}
	
	\item{\code{maxtime}}{If \code{stoptype = "maxtime"}, specifies the running time (in seconds) after which the algorithm will be terminated if convergence has not been achieved. Default is 60.}
	
	\item{\code{convfn.user}}{Optional, user-specified function for determining whether convergence has been achieved. Function should take as inputs \code{new} and \code{old}, where \code{new} is the current value (of the fixed point if \code{convtype = "parameter"} and of the objective function value if \code{convtype = "objfn"}) and \code{old} is the previous value. Function should map to a logical taking the value \code{TRUE} if convergence is achieved (and hence the algorithm is terminated) and the value \code{FALSE} if convergence is not achieved. Default is \code{NULL}.}
	
	\item{\code{stopfn.user}}{Optional, user-specified function for determining whether to terminate the algorithm if convergence has not been achieved. See details above for how to specify. Default is \code{NULL}.}
	
	\item{\code{trace}}{A logical variable denoting whether some of the intermediate results of iterations should be displayed to the user. Default is \code{FALSE}.}
	
	\item{\code{keep.objfval}}{A logical variable denoting whether the objective function value at each iteration should be stored. Default is \code{FALSE}.}
	
	\item{\code{keep.paramval}}{A logical variable denoting whether the parameter estimates at each iteration should be stored. Default is \code{FALSE}.}
}
}
\seealso{
  \code{\link[foreach:foreach]{foreach}}
}
   
\examples{
###########################################################################
# Also see the vignette by typing:
#  vignette("turboEM")
#
# EM algorithm for Poisson mixture estimation 

fixptfn <- function(p,y) {
# The fixed point mapping giving a single E and M step of the EM algorithm
# 
pnew <- rep(NA,3)
i <- 0:(length(y)-1)
zi <- p[1]*exp(-p[2])*p[2]^i / (p[1]*exp(-p[2])*p[2]^i + (1 - p[1])*exp(-p[3])*p[3]^i)
pnew[1] <- sum(y*zi)/sum(y)
pnew[2] <- sum(y*i*zi)/sum(y*zi)
pnew[3] <- sum(y*i*(1-zi))/sum(y*(1-zi))
p <- pnew
return(pnew)
}

objfn <- function(p,y) {
# Objective function whose local minimum is a fixed point 
# negative log-likelihood of binary poisson mixture
i <- 0:(length(y)-1)
loglik <- y*log(p[1]*exp(-p[2])*p[2]^i/exp(lgamma(i+1)) + 
		(1 - p[1])*exp(-p[3])*p[3]^i/exp(lgamma(i+1)))
return ( -sum(loglik) )
}

# Real data from Hasselblad (JASA 1969)
poissmix.dat <- data.frame(death = 0:9, 
	freq = c(162,267,271,185,111,61,27,8,3,1))
y <- poissmix.dat$freq

# Use a preset seed so the example is reproducable. 
require("setRNG")
old.seed <- setRNG(list(kind = "Mersenne-Twister", normal.kind = "Inversion",
    seed = 54321))

p0 <- c(runif(1),runif(2,0,4))  # random starting value

# Basic EM algorithm, SQUAREM, and parabolic EM, with default settings
res1 <- turboem(par = p0, y = y, fixptfn = fixptfn, objfn = objfn, 
	method = c("EM", "squarem", "pem"))

# To apply the dynamic ECME (decme) acceleration scheme, 
# we need to include a boundary function
boundary <- function(par, dr) {
	lower <- c(0, 0, 0)
	upper <- c(1, 10000, 10000)
	low1 <- max(pmin((lower-par)/dr, (upper-par)/dr))
	upp1 <- min(pmax((lower-par)/dr, (upper-par)/dr))
	return(c(low1, upp1))
}
res2 <- turboem(par = p0, y = y, fixptfn = fixptfn, objfn = objfn, 
	boundary = boundary, method = c("EM", "squarem", "pem", "decme"))

# change some of the algorithm-specific default specifications (control.method), 
# as well as the global control parameters (control.run)
res3 <- turboem(par = p0, y = y, fixptfn = fixptfn, objfn = objfn, 
  boundary = boundary, method = c("em", "squarem", "squarem", "decme", "qn", "qn"), 
	control.method = list(list(), list(K = 2), list(K = 3), 
		list(version = "v3"), list(qn = 1), list(qn = 2)),
	control.run = list(tol = 1e-12, stoptype = "maxtime", maxtime = 1))

# Only the standard EM algorithm and SQUAREM *do not* require 
# providing the objective function. 
res4 <- turboem(par = p0, y = y, fixptfn = fixptfn, 
	method = c("em", "squarem", "squarem"), 
	control.method = list(list(), list(K = 1), list(K = 2)))
# If no objective function is provided, the "squarem" method defaults to Squarem-2 
# Or, if control parameter K > 1, it defaults to Cyclem-2. 
# Compare Squarem with and without objective function provided:
res5 <- turboem(par = p0, y = y, fixptfn = fixptfn, method = "squarem")
res5
res6 <- turboem(par = p0, y = y, fixptfn = fixptfn, objfn = objfn, method = "squarem")
res6

}

\references{ 
R Varadhan and C Roland (2008). Simple and globally convergent numerical schemes for accelerating the convergence of any EM algorithm. \emph{Scandinavian Journal of Statistics}, 35:335-353.

A Berlinet and C Roland (2009). Parabolic acceleration of the EM algorithm. \emph{Stat Comput}. 19 (1) 35-47.

Y He and C Liu (2010) The Dynamic ECME Algorithm. Technical Report. arXiv:1004.0524v1.

H Zhou, DH Alexander, and KL Lange (2011). A quasi-Newton acceleration for high-dimensional optimization algorithms. \emph{Stat Comput}. 21 (2) 261-273.
}

\concept{EM algorithm}
\concept{optimization}
\concept{MM algorithm}
\concept{fixed-point iteration}
