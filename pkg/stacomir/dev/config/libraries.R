#' function to call and load the libraries used in stacomi
#' 
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
libraries=function() {
necessary = c('ggplot2',
		'lattice','RColorBrewer','xtable','scales','reshape2','grid','stringr','intervals','RPostgres')  # 'tcltk2','XML', 'Hmisc''svMisc''proto''R2HTML'
if(!all(necessary %in% installed.packages()[, 'Package']))
	install.packages(necessary[!necessary %in% installed.packages()[, 'Package']], dependencies = TRUE)
#if (!'XML'%in%installed.packages()[, 'Package']) install.packages("XML", repos = "http://www.omegahat.org/R")
#require('tcltk2')
require('ggplot2')
##require('Hmisc')
#require('lattice')
#require('RColorBrewer')
require('stacomirtools')
##require('R2HTML')
##require('proto') 
#require('xtable')
##require('Hmisc')
##if(require('XML')) library('XML') 
##require('svMisc')   
#require('stringr')
#require('grid')
#require('reshape2')
#require('scales')
#require('intervals')
##require('Rcmdr') not done there as is causes the interface to load
#require('RPostgres')

}
#require('sma')# function is.odd




