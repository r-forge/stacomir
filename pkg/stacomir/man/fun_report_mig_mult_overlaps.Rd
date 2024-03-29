% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_mig_mult.R
\name{fun_report_mig_mult_overlaps}
\alias{fun_report_mig_mult_overlaps}
\title{Function to calculate daily migration using overlaps functions}
\usage{
fun_report_mig_mult_overlaps(time.sequence, datasub, negative = FALSE)
}
\arguments{
\item{time.sequence}{the time sequence to be filled in with new data}

\item{datasub}{the initial dataset}

\item{negative}{'boolean', default FALSE, TRUE indicates a separate sum for negative and positive migrations
to time.sequence period and summed over the new sequence. A migration operation spanning several days will
be converted to 'daily' values assuming that the migration was regular over time. The function
returns one row per taxa, stages, counting device. It does not account for the destination of taxa. It returns
separate rows for quantities and numbers. Several columns are according to the type of measure (MESURE, CALCULE, PONCTUEL or EXPERT).}
}
\value{
A data.frame with daily migrations
}
\description{
Function to calculate daily migration from migration monitoring whose length is more than one day,
this calculation relies on the (false) assumption that migration is evenly spread over time.
}
\seealso{
calcule,report_mig_mult-method
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
