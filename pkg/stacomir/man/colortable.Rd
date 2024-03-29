% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{colortable}
\alias{colortable}
\title{Builds a table with colors to merge with a dataframe for later
use in ggplot. An initial check will be done
on the name of the color vector. A data frame is built. It contains a column color which is a factor.
The factor order match the order of the vector (not the alphabetical order of the colors).}
\usage{
colortable(
  color = NULL,
  vec,
  palette = "Set2",
  color_function = c("brewer.pal", "gray.colors", "random")
)
}
\arguments{
\item{color}{Either null (default) or a named vector of colors, the
names should correspond to the values of vec}

\item{vec}{The vector to match the color with, if a named vector
or color is supplied the names should match}

\item{palette, }{the name of the RColorBrewer palette, defaults to "Set2", ignored for other
color gradient functions and if a named vector of colors is provided}

\item{color_function, }{the name of the function used to brew the colors, one for 
"brewer.pal", "gray.colors", "random", default to "brewer.pal, this argument is ignored if a
named vector of color is passed.}
}
\value{
A dataframe with two columns, the vector (name) and the color (color) as a reordered factor
}
\description{
Builds a table with colors to merge with a dataframe for later
use in ggplot. An initial check will be done
on the name of the color vector. A data frame is built. It contains a column color which is a factor.
The factor order match the order of the vector (not the alphabetical order of the colors).
}
\author{
Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
}
