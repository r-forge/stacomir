% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_df.R
\name{plot,report_df,missing-method}
\alias{plot,report_df,missing-method}
\alias{plot.report_df}
\title{Different plots for report_df}
\usage{
\S4method{plot}{report_df,missing}(
  x,
  plot.type = 1,
  silent = FALSE,
  main = NULL,
  color_type_oper = c(`Fonc normal` = "#1B9E77", `Arr ponctuel` = "#E6AB02", `Arr maint`
    = "#9E0142", Dysfonc = "#E41A1C", `Non connu` = "#999999"),
  color_etat = c(`TRUE` = "chartreuse3", `FALSE` = "orangered3")
)
}
\arguments{
\item{x}{An object of class \link{report_df-class}.}

\item{plot.type}{1 to 4.}

\item{silent}{Stops displaying the messages.}

\item{main}{The title of the graph, if NULL a default title will be plotted with the number of the DF.}

\item{color_type_oper}{Named vector of color for the graph, must match type operation default to c(
"Fonc normal" = "#1B9E77","Arr ponctuel" = "#E6AB02", "Arr maint" = "#9E0142",
"Dysfonc" = "#E41A1C","Non connu" = "#999999").}

\item{color_etat}{Named vector state value (must match the names "TRUE", "FALSE").}
}
\value{
Nothing but prints the different plots.
}
\description{
\describe{
     \item{plot.type=1}{A barplot of the operation time per month}
		\item{plot.type=2}{Barchat giving the time per type of operation }
		\item{plot.type=2}{Rectangle plots drawn along a line}
     \item{plot.type=4}{Plots per day drawn over the period to show the operation of a df, days in x, hours in y}
	}
}
\note{
The program cuts periods which overlap between two month. The splitting of different periods into month is
assigned to the \code{envir_stacomi} environment.
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
