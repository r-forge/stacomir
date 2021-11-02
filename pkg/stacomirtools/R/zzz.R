




#' Stacomirtools options.
#'
#' @section Package options:
#'
#' stacomirtools uses the following [options()] to configure behaviour:
#'
#' \itemize{
#'   \item `stacomiR.dbname`: databasename
#'
#'   \item `stacomiR.host`: the name of the host, often ["localhost"]
#' 
#'   \item `stacomiR.port`: the name of the port, most often ["5432"]
#'    
#'   \item `stacomiR.user`: a string with the user name e.g. ["postgres"]#'     
#'
#'   \item `stacomiR.password`: a string with the user password
#'
#'   \item `stacomiR.ODBClink`: a string with name of the ODBC link, default NULL
#'
#'   \item `stacomiR.path`: a string with the path to where some output are written  
#'
#'    \item `stacomiR.printqueries`: a boolean, default FALSE, with the side effect of printing queries to the console
#' }
#' @docType package
#' @keywords internal
#' @name stacomirtools
"_PACKAGE"

#' Deprecated Functions
#'
#' These functions are Deprecated in this release of devtools, they will be
#' marked as Defunct and removed in a future version.
#' @name stacomirtools-deprecated
#' @keywords internal
NULL


stacomi_default_options <- list(
		stacomiR.path = "~",
		stacomiR.dbname = "bd_contmig_nat",
		stacomiR.host ="localhost",
		stacomiR.port = "5432",
		stacomiR.user = "",
		stacomiR.password = "",
		stacomiR.ODBClink = NULL,
		stacomiR.printqueries = FALSE
)


.onLoad <- function(...) {
	op <- options()
	toset <- !(names(stacomi_default_options) %in% names(op))
	if (any(toset)) options(stacomi_default_options[toset])
	
	invisible()
}





