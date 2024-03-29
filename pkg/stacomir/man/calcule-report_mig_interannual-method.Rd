% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_mig_interannual.R
\name{calcule,report_mig_interannual-method}
\alias{calcule,report_mig_interannual-method}
\alias{calcule.report_mig_interannual}
\title{calcule method for report_mig_interannual}
\usage{
\S4method{calcule}{report_mig_interannual}(object, silent = FALSE, timesplit = "mois")
}
\arguments{
\item{object}{An object of class \link{report_mig_interannual-class}}

\item{silent}{Boolean, if TRUE, information messages are not displayed, only warnings and errors}

\item{timesplit}{One of "day","week","month","2 weeks", "jour","semaine","quinzaine","mois"}
}
\value{
An object of class \link{report_mig_interannual-class} with calcdata slot filled.
}
\description{
Performs the calculation of seasonal coefficients for the plot(plot.type="seasonal") method. The numbers
are split according to the period chosen, one of "day","week","month","2 weeks", French labels are also
accepted as arguments. Once this is done, the seasonality of the migration is displayed using the day when the
first fish was seen, then the days (or period) corresponding to 5, 50 , 95, and 100 percent of the migration.
The duration of 90% of the migraton between Q5 and Q95 is also of interest.
}
\note{
The class report_mig_interannual does not handle escapement rates nor
'devenir' i.e. the destination of the fishes.
}
\author{
Marion Legrand
}
