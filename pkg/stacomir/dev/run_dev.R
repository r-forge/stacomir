# Set options here


#remotes::install_git(url = "https://forgemia.inra.fr/stacomi/stacomirtools" , ref = "connection")
rm(list=ls(all.names = TRUE))
library(roxygen2)
library(devtools)
package_dir <- "C:/workspace/stacomir"
setwd(package_dir)
#package_dir = getwd()
# Document and reload your package

roxygenise(package.dir = package_dir, roclets = NULL, load_code = NULL, 
		clean = FALSE)
load_all(path=package_dir, reset=TRUE, export_all = FALSE, helpers = TRUE)
#export_all 
# If TRUE (the default), export all objects. If FALSE, export only the objects that are listed as exports in the NAMESPACE file.
# helpers TRUE will load testhat test helpers
