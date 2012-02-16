\name{turbosim}
\alias{turbosim}
\alias{print.turbosim}
\alias{summary.turbosim}
\alias{boxplot.turbosim}
\alias{dataprof}
\alias{dataprof.turbosim}
\alias{pairs.turbosim}

\title{Methods for objects of class "turbosim"}
\description{The \code{turbosim} class represents results from benchmark studies of algorithms to acceleration parameter estimation in fixed-point mapping problems.}
\usage{
\method{print}{turbosim}(x, ...)
\method{summary}{turbosim}(object, which.methods = seq_along(object$method), method.names = object$method.names[which.methods], eps = 0.1, sol = NULL, ...)
\method{boxplot}{turbosim}(x, which.methods = seq_along(x$method), method.names = x$method.names[which.methods], whichfail = (x$fail | !x$conv)[,which.methods], xunit="sec", log=FALSE, ...)
\method{dataprof}{turbosim}(x, which.methods = seq_along(x$method), method.names = x$method.names[which.methods], whichfail = (x$fail | !x$conv)[,which.methods], col, lty, nout = 50, xlim, ...)
\method{pairs}{turbosim}(x, which.methods=seq_along(x$method), method.names = x$method.names[which.methods], whichfail = (x$fail | !x$conv)[,which.methods], ...)
}

\arguments{
    \item{object}{An object of class \code{turbosim}, the structure of which is described in *Details*.}

    \item{x}{An object of class \code{turbosim}, the structure of which is described in *Details*.}

    \item{which.methods}{A vector identifying for which subset of algorithms results are desired.} 

    \item{method.names}{A vector of unique identifiers for the algorithms for which results are being provided.}

    \item{eps}{Used to define a tolerance between the objective function value attained by a particular acceleration scheme and the best achievable objective function value (either across schemes or as defined by the user). 
	See *Details*.}

    \item{sol}{Optional argument defining the best achievable objective function value for a given fixed-point mapping problem. Defaults to NULL. 
	See *Details*.}

    \item{xunit}{Units for running time to be used in the boxplots. Argument takes the value "sec" or "min."}

    \item{log}{Logical indicating whether the log of the running time will be plotted. Defaults to FALSE.}
    
    \item{whichfail}{A matrix of logical values where the (\eqn{i}{i},\eqn{j}{j})-entry indicates whether algorithm j of simulation iteration i failed (however the user wishes to define a failure for visualization purposes). If argument is not provided by user, then by default a failure is defined to be the event where the algorithm produces an error *or* does not converge.}

    \item{col}{Optional argument: A vector where each component defines the color for the line corresponding to each algorithm being compared.}

    \item{lty}{Optional argument: A vector where each component defines the line-type for the line corresponding to each algorithm being compared.}

    \item{nout}{Number of values at which the empirical distribution function is estimated. Should be less than the number of simulation iterations.}

    \item{xlim}{Optional argument: Defines the x-axis limits for the data profile. Defaults to the full range of the running times over all algorithms being plotted.}
        
    \item{...}{Additional arguments.}
}

\value{
	\item{\code{summary}}{Summarizes the number of failures by type across simulation iterations for each acceleration scheme.}
	
	\item{\code{boxplot}}{Shows box plots of algorithm running times for each acceleration scheme.}

	\item{\code{dataprof}}{Plots the data profile, or the estimated distribution function of the time until convergence for each acceleration scheme.}

	\item{\code{pairs}}{Scatterplot matrix showing pairwise comparison of the running times for each pair of acceleration schemes.}
	
}

\details{An object of class \code{turbosim} is typically the product of the function \code{\link{turboSim}}. It is a list containing at least the following components:

\describe{

	\item{\code{method.names}}{Vector of unique identifiers for the algorithms being compared}

	\item{\code{fail}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is a logical (TRUE/FALSE) for whether the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition failed (produced an error).}

	\item{\code{convergence}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is a logical (TRUE/FALSE) for whether the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition satisfied the convergence criterion before termination.}

	\item{\code{value.objfn}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is the value of the objective function of the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition.}

	\item{\code{runtime}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is the running time of the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition.}

	\item{\code{itr}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is the number of completed iterations of the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition.}

	\item{\code{fpeval}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is the number of fixed-point function evaluations of the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition.}

	\item{\code{objfeval}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element is the number of objective function evaluations of the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition.}

	\item{\code{errors}}{Matrix whose (\eqn{i}{i},\eqn{j}{j})-element contains the error message produced by the \eqn{j}{j}th algorithm at the \eqn{i}{i}th benchmark study repetition (if there was an error).}

}
This list usually will also contain the components \code{fixptfn}, \code{objfn}, \code{method}, \code{pconstr}, \code{project}, \code{control.method}, and \code{control.run}, which were provided as arguments for \code{\link{turboSim}}.

The \code{summary} function shows a table of the number of failures across acceleration schemes. There are three types of failures. The first occurs when the algorithm produces an error message. The second is if the algorithm does not converge before the alternative stopping rule is achieved (e.g. the maximum number of iterations or maximum pre-specified runtime is reached). The third is if the algorithm claims convergence but the value of the objective function is "far" from the best achievable value. To assess this third type of failure, we determine whether the objective function value achieved by the algorithm is close (within \code{eps}) to the smallest value achieved across all algorithms at that simulation iteration. Alternatively, if the user knows a priori the true objective function value, he/she may specify the argument \code{sol}, in which case, the third type of failure occurs when the objective function value achieved by the algorithm is within \code{eps} of \code{sol}.

Further details for each of the methods are provided in the vignette, which can be seen by typing \code{vignette("turboEM")}.
}

\seealso{
	\code{\link{turboem}, \link{turbo}} 
}

\examples{

###########################################################################
# Examples provided in the vignette, which can be seen by typing
#  vignette("turboEM")

}