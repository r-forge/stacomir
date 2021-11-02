
#' Validity method for ODBC class
#' @param object an object of class ConnectionODBC
validity_ODBC=function(object)
{
	rep1= class(object@baseODBC[1])=="Character"
	rep2=class(object@baseODBC[2])=="Character"
	rep3=class(object@baseODBC[3])=="ANY"
	rep4=length(object@baseODBC)==3
	return(ifelse(rep1 & rep2 & rep3 & rep4,TRUE,c(1:4)[!c(rep1, rep2, rep3, rep4)]))
}

#' @title ConnectionODBC class 
#' @note Mother class for connection, opens the connection but does not shut it
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @slot baseODBC "vector" (of length 3, character)
#' @slot silent "logical" 
#' @slot etat "ANY" # can be -1 or string
#' @slot connection "ANY" # could be both string or S3
#' @return connectionODBC an S4 object of class connectionODBC
#' @examples 
#' ##this wont be run as the user need to manually configure the connection before using it
#' \dontrun{
#' object=new("ConnectionODBC")
#' object@baseODBC=c("myODBCconnection","myusername","mypassword")
#' object@silent=FALSE
#' object<-connect(object)
#' odbcClose(object@connection)
#' }
#' @export
setClass(Class="ConnectionODBC",
		representation= representation(baseODBC="vector",silent="logical",etat="ANY",connection="ANY"),
		prototype = list(silent=TRUE),
		validity=validity_ODBC)

#' generic connect function for baseODBC
#' @param object an object
#' @param ... additional arguments passed on to the connect method 
#' @export   
setGeneric("connect",def=function(object,...) standardGeneric("connect"))

#' connect method for ConnectionODBC class
#' @param object an object of class ConnectionODBC
#' @return a connection with slot filled
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @examples 
#' ##this wont be run as the user need to manually configure the connection before using it
#' \dontrun{
#' object=new("ConnectionODBC")
#' object@baseODBC=c("myODBCconnection","myusername","mypassword")
#' object@silent=FALSE
#' object<-connect(object)
#' odbcClose(object@connection)
#' }
setMethod("connect",signature=signature("ConnectionODBC"),definition=function(object) {
			.Deprecated(new= "ConnectionDB", old="ConnectionODBC")			
			if (length(object@baseODBC)!=3)  {
				object@baseODBC <- c(
						options("stacomiR.ODBClink")[[1]],
						options("stacomiR.user")[[1]],
						options("stacomiR.password")[[1]]
				)				
			} 			
			
			e=expression(channel <-odbcConnect(object@baseODBC[1],
							uid = object@baseODBC[2],
							pwd = object@baseODBC[3],
							case = "tolower",
							believeNRows = FALSE))

			if (!object@silent) {
					print(paste("connection trial, warning this class should only be used for test: ",object@baseODBC[1]))
			}	
			connection_error <- paste(gettext("Connection failed :\n",object@baseODBC[1]))

			currentConnection<-tryCatch(eval(e), error=connection_error) 
			if (class(currentConnection)=="RODBC") {
				if (!object@silent){				
						print(gettext("Connection successful"))
				} 
				object@connection <- currentConnection  # an object S3 RODBC
				object@etat="Connection in progress"
			} else {
				cat(currentConnection)
				object@etat=currentConnection # reporting error
			}
			return(object)
		})