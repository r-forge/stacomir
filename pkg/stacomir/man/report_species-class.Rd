% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_species.R
\docType{class}
\name{report_species-class}
\alias{report_species-class}
\alias{report_species}
\title{Counts of number per taxa/stages}
\description{
This class is used to make the assessment of all species, and their number. It is intended
as a simple way to check what fishes are present (taxa + development stage). It was altered to include ref_taxa,
to allow excluding some of the most numerous taxa from reports. The taxa is reported unless 
a taxa has several stages, in which case the different stages for the taxa will be reported
Using the split arguments
the calc method of the class will count numbers, subsamples are not accounted for in the Overview.
The split argument currently takes values year or month. The class is intended to be used over long periods
e.g years. The plot method writes either an histogram or a pie chart of number per
year/week/month.
}
\section{Slots}{

\describe{
\item{\code{dc}}{an object of class \link{ref_dc-class}}

\item{\code{taxa}}{Object of class \link{ref_taxa-class}: the species}

\item{\code{start_year}}{Object of class \code{\link{ref_year-class}}}

\item{\code{end_year}}{Object of class \code{\link{ref_year-class}}}

\item{\code{data}}{\code{data.frame}}

\item{\code{calcdata}}{\code{data.frame} with data processed by the calc method}

\item{\code{split}}{Object of class \code{\link{ref_list-class}} ref_list referential class choose within a list}
}}

\examples{
# launching stacomi without selecting the scheme or interface
stacomi(	database_expected=FALSE)
# the following script will load data 
# from the two Anguillere monitored in the Somme
# If you have a working database
# the following line of code will create the bilesp dataset from the "iav." 
# schema in the database

\dontrun{
  bilesp<-new("report_species")
  # split is one of "none", "year", "week", "month
  bilesp<-choice_c(bilesp,
	  dc=c(5,6,12),
	  split="year", 
	  start_year="2008",
	  end_year="2012",
	  silent=FALSE)	
  bilesp <- connect(bilesp)
  bilesp <- calcule(bilesp)
  plot(bilesp, plot.type="pie", silent=FALSE)
  plot(bilesp, plot.type="barplot", silent=FALSE)
  bilesp <- choice_c(bilesp,
	  dc=c(5,6,12),
	  split="month",
	  start_year="2015",
	  end_year="2016",
	  silent=FALSE)
  bilesp <- charge(bilesp)
  bilesp <- connect(bilesp)
  plot(bilesp, plot.type="pie", silent=FALSE)
  plot(bilesp, plot.type="barplot", silent=FALSE)
  #length(unique(bilesp@calcdata$taxa_stage)) # 15
  # here creating a vector of length 15 with nice blending colours
	if (requireNamespace("grDevices", quietly = TRUE)) {
	mycolorrampblue <-
			grDevices::colorRampPalette(c("#395B74", "#010F19"))
	mycolorrampyellow <-
			grDevices::colorRampPalette(c("#B59C53", "#271D00"))
	mycolorrampred <-
			grDevices::colorRampPalette(c("#B56F53", "#270B00"))
  color<-c(mycolorrampblue(5),
	  mycolorrampyellow(5),
	  mycolorrampred(5))
  plot(bilesp,plot.type="barplot",color=color,silent=TRUE)
	}
  summary(bilesp)
}	

}
\seealso{
Other report Objects: 
\code{\link{report_annual-class}},
\code{\link{report_dc-class}},
\code{\link{report_df-class}},
\code{\link{report_env-class}},
\code{\link{report_ge_weight-class}},
\code{\link{report_mig-class}},
\code{\link{report_mig_char-class}},
\code{\link{report_mig_env-class}},
\code{\link{report_mig_interannual-class}},
\code{\link{report_mig_mult-class}},
\code{\link{report_sample_char-class}},
\code{\link{report_sea_age-class}},
\code{\link{report_silver_eel-class}}
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
\concept{report Objects}
\keyword{classes}
