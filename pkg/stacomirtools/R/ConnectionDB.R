
#' validity function for ConnectionDB class 
#' @param object An object of class ConnectionDB
validity_DB=function(object)
{
	rep1 <- length(object@dbname)==1
	rep2 <- length(object@host)==1
	rep3 <- length(object@port)==1
	rep4 <- length(object@user)==1	
	rep5 <- length(object@password)==1
	rep6 <- !is.null(object@dbname)
	rep7 <- !is.null(object@host)
	rep8 <- !is.null(object@port)
	rep9 <- !is.null(object@user)
	rep10 <- !is.null(object@password)
	
	return(ifelse(rep1 & rep2 & rep3 & rep4 & rep5 & rep6 & rep7 & rep8 & rep9 & rep10  ,TRUE,
					c(gettext("dbname should be of length 1"),
							gettext("host should be of length 1"),
							gettext("port should be of length 1"),
							gettext("user should be of length 1"),
							gettext("password should be of length 1"),
							gettext("dbname should not be NULL, did you forget to set dbname ? hint use : options('stacomiR.dbname'='bd_contmig_nat')"),
							gettext("host should not be NULL, did you forget to set host ? hint use: options('stacomiR.host'='localhost')"),
							gettext("port should not be NULL, did you forget to set port ?  hint use: ('stacomiR.port'='5432')"),
							gettext("user should not be NULL, did you forget to set user ? hint use : options('stacomiR.user'='myuser')"),
							gettext("password should not be NULL, did you forget to set dbname ? hint use : options('stacomiR.password'='mypassword')"))[
							!c(rep1, rep2, rep3, rep4, rep5,rep6, rep7, rep8, rep9, rep10)]))
}

#' @title ConnectionDB class 
#' @note Mother class for connection, opens the connection but does not shut it
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @slot dbname name of the database, length 1
#' @slot host host default "localhost", length 1
#' @slot port port of the database default "5432", length 1
#' @slot user user of the database, length 1
#' @slot password password for the datatbase, length 1
#' @slot silent A "logical" stating if the program returns output to the user
#' @slot status  Can be -1 or string
#' @slot connection  Could be both string or S3
#' @return connection an S4 object of class connectionDB
#' @examples 
#' ##this wont be run as the user need to manually configure the connection before using it
#' \dontrun{
#' object <- new("ConnectionDB")
#' object@dbname <- c("bd_contmig_nat","test")
#' object@host <- 		"localhost"
#' object@port <-		"5432"
#' object@user <-		"myuser"
#' object@password <-		"mypassword"
#' object@silent=FALSE
#' object <- connect(object)
#' pool::dbGetInfo(object@connection)
#' pool::poolClose(object@connection)
#' }
#' @export
setClass(Class="ConnectionDB",
		representation= representation(
				dbname="character", 
				host ="character",
				port="character",
				user="character",
				password="character",				
				silent="logical", 
				status="ANY", 
				connection="ANY"),
		prototype = list(silent=TRUE,dbname="bd_contmig_nat", user="postgres", 
				port="5432"),
		validity=validity_DB)

#constructor

#' connect method for ConnectionDB class
#' @param object An object of class ConnectionDB
#' @param base a string with values for dbname, host, port, user, password, in this order.
#' @return a connection with slot filled
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @examples 
#' \dontrun{
#' object <- new("ConnectionDB")
#' object@dbname <- c("bd_contmig_nat","test")
#' object@host <- 		"localhost"
#' object@port <-		"5432"
#' object@user <-		"myuser"
#' object@password <-		"mypassword"
#' object@silent=FALSE
#' object <- connect(object)
#' pool::dbGetInfo(object@connection)
#' pool::poolClose(object@connection)
#' }
setMethod("connect", signature=signature("ConnectionDB"), 
		definition=function(object, base=NULL) {  
			#browser()
			if (!is.null(base)) {
				object@dbname <- base[1]
				object@host <- base[2]
				object@port <- base[3]
				object@user <- base[4]
				object@password <- base[5]
			} else if (options("stacomiR.user")[[1]]!=""){
				object@dbname <- options("stacomiR.dbname")[[1]]
				object@host <- options("stacomiR.host")[[1]]
				object@port <- options("stacomiR.port")[[1]]
				object@user <- options("stacomiR.user")[[1]]
				object@password <- options("stacomiR.password")[[1]]
			}
			validObject(object, test=TRUE)
			
			
			currentConnection <- pool::dbPool(drv = RPostgres::Postgres(), 
					dbname = object@dbname,
					host = object@host,
					port = object@port,
					user = object@user,
					password = object@password,
					minSize = 0,
					maxSize = 2)
			
#			if (!exists("odbcConnect")) {
#				if (exists("envir_stacomi")){
#					stop("The RODBC library is necessary, please load the package")
#				} else	  {
#					stop("the RODBC library is necessary, please load the package")
#				}
#			}
			if (!object@silent) {
				if (exists("envir_stacomi")){
					print(paste("Connection trial, warning this class should only be used for test: ", object@dbname))
				} else {
					print(paste("Connection trial, warning this class should only be used for test: ", object@dbname))
				}
			}	
			# sends the result of a trycatch connection in the
			#object (current connection), e.g. a character vector
			connection_error<-function(c)
			{
				if (exists("envir_stacomi")){
					error=paste(gettext("Connection failed :\n", object@dbname))
				} else {
					error= c
				}
				return(error)
			}
			
			tryCatch(pool::dbGetInfo(currentConnection), error = connection_error)
			
			object@connection=currentConnection # an DBI object
			
			if(pool::dbGetInfo(currentConnection)$valid)
				object@status = "Connection OK"
			else
				object@status = "Something went wrong"
			
			if (!object@silent){
				if(exists("envir_stacomi")){
					print(object@status)
				} else {
					print(object@status)
				}
			} 
			
			return(object)
		}
)