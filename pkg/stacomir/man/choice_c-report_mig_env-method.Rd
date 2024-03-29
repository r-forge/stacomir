% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_mig_env.R
\name{choice_c,report_mig_env-method}
\alias{choice_c,report_mig_env-method}
\alias{choice_c.report_mig_env}
\title{command line interface for report_env class}
\usage{
\S4method{choice_c}{report_mig_env}(
  object,
  dc,
  taxa,
  stage,
  stationMesure,
  datedebut,
  datefin,
  silent = FALSE
)
}
\arguments{
\item{object}{An object of class \link{report_env-class}}

\item{dc}{A numeric or integer, the code of the dc, coerced to integer,see \link{choice_c,ref_dc-method}}

\item{taxa}{'2038=Anguilla anguilla',
these should match the ref.tr_taxon_tax referential table in the stacomi database, see \link{choice_c,ref_taxa-method}}

\item{stage}{'AGJ=Yellow eel', 'AGG=Silver eel', 'CIV=glass eel'}

\item{stationMesure}{A character, the code of the monitoring station, which records environmental parameters \link{choice_c,ref_env-method}}

\item{datedebut}{The starting date as a character, formats like \code{\%Y-\%m-\%d} or \code{\%d-\%m-\%Y} can be used as input}

\item{datefin}{The finishing date of the report, for this class this will be used to calculate the number of daily steps.}

\item{silent}{Boolean default FALSE, if TRUE information messages not displayed.}
}
\value{
An object of class \link{report_env-class} with data selected
}
\description{
command line interface for report_env class
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
