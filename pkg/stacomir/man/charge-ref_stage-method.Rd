% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ref_stage.R
\name{charge,ref_stage-method}
\alias{charge,ref_stage-method}
\title{Loading method for ref_stage referential objects}
\usage{
\S4method{charge}{ref_stage}(object)
}
\arguments{
\item{object}{An object of class \link{ref_stage-class}}
}
\value{
An S4 object of class \link{ref_stage-class} with all stages available in the database
}
\description{
Loading method for ref_stage referential objects
}
\examples{
\dontrun{
 object=new('ref_stage')
 charge(object)
}
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
