% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_mig_mult.R
\name{summary,report_mig_mult-method}
\alias{summary,report_mig_mult-method}
\alias{summary.report_mig_mult}
\title{summary for report_mig_mult 
calls functions funstat and funtable to create migration overviews
and generate csv and html output in the user data directory}
\usage{
\S4method{summary}{report_mig_mult}(object, silent = FALSE, ...)
}
\arguments{
\item{object}{An object of class \code{\link{report_mig_mult-class}}}

\item{silent}{Should the program stay silent or display messages, default FALSE}

\item{...}{Additional parameters (not used there)}
}
\value{
Nothing, runs funstat and funtable method for each DC
}
\description{
summary for report_mig_mult 
calls functions funstat and funtable to create migration overviews
and generate csv and html output in the user data directory
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
