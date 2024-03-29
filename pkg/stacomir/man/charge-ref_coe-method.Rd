% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ref_coe.R
\name{charge,ref_coe-method}
\alias{charge,ref_coe-method}
\title{loads the coefficients for the period defined in class}
\usage{
\S4method{charge}{ref_coe}(object)
}
\arguments{
\item{object}{An object of class \link{ref_coe-class}}
}
\value{
An object of class \link{ref_coe-class}
}
\description{
The slots datedebut and datefin have to be filled before using charge
}
\examples{
\dontrun{
object<- new('ref_coe')
object@datedebut<-strptime('01/01/1996',format='\%d/\%m/\%Y')
object@datefin<-strptime('01/01/1997',format='\%d/\%m/\%Y')
charge(object) 
}
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
