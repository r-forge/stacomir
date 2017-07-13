# Nom fichier :        RequeteODBC.R 
#' @title RequeteODBC class 
#' @note Inherits from ConnectionODBC
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @slot baseODBC="vector" (inherited from ConnectionODBC)
#' @slot silent="logical" (inherited from ConnectionODBC)
#' @slot etat="character" (inherited from ConnectionODBC)
#' @slot connection="ANY" (inherited from ConnectionODBC)
#' @slot sql="character"
#' @slot query="data.frame"
#' @slot open=logical is the connection left open after the request ?
#' @examples object=new("RequeteODBC")
setClass(Class="RequeteODBC",
		representation= representation(sql="character",query="data.frame",open="logical"),
		prototype = list(silent=TRUE,open=FALSE),
		contains="ConnectionODBC")

#' connect method loads a request to the database and returns either an error or a data.frame
#' @note assign("showmerequest",1,envir=envir_stacomi) allows to print all queries passing on the class connect
#' @return An object of class RequeteODBC
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @expamples 
#' showClass("RequeteODBC")
#' \dontrun{
#' object=new("RequeteODBC")
#' object@open=TRUE
#' object@baseODBC=baseODBC
#' object@sql= "select * from t_lot_lot limit 100"
#' object<-connect(object)
#' odbcClose(object@connection)
#' odbcCloseAll()
#'   object=new("RequeteODBC")
#'   object@open=TRUE 
#'   ## this will leave the connection open, 
#'   ## by default it closes after the query is sent
#'   ## the following will work only if you have configured and ODBC link
#'   object@baseODBC=c("myODBCconnection","myusername","mypassword")
#'   object@sql= "select * from mytable limit 100"
#'   object<-connect(object)
#'   odbcClose(object@connection)
#'   envir_stacomi=new.env()
#'   ## While testing if you want to see the output of sometimes complex queries generated by the program
#'   assign("showmerequest",1,envir_stacomi) 
#'   ## You can assign any values (here 1)
#'   ## just tests the existence of "showmerequest" in envir_stacomi
#'   object=new("RequeteODBC")
#'   object@baseODBC=c("myODBCconnection","myusername","mypassword")
#'   object@sql= "select * from mytable limit 100"
#'   object<-connect(object)
#'  ## the connection is already closed, the query is printed
#'}

setMethod("connect",signature=signature("RequeteODBC"),definition=function(object) {     
			msg1<-gettext("'ODBC' error =>you have to define a vector baseODBC with the 'ODBC' link name, user and password")
			msg2<-gettext("connection trial :")
			msg3<-gettext("connection impossible")
			msg4<-gettext("connection successfull")
			msg5<-gettext("request trial")
			msg6<-gettext("success")
			verbose<-exists("showmerequest",envir=envir_stacomi)
			


#' Function loaded in this package to avoid errors, if the package is called
#' without stacomiR
#' 
#' This function will be replaced by a longer function using gWidgets if the
#' package stacomiR is loaded. It is provided there to avoid to pointing to an
#' undefined global function. Normally the program tests for the existence of
#' and environment envir_stacomi which indicates that the messages are to be
#' displayed in the gWidget interface, so this code is to avoid notes in
#' R.check.
#' 
#' 
#' @param text The text to display
#' @param arret If true calls the program to stop and the message to be
#' displayed
#' @param wash Only used when called from within stacomiR, and there is a
#' widget interface, kept there for consistency
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
			funout<-function(text,arret=FALSE){
				if(arret) stop(text) else print(text)
				return(NULL)
			}


#' very usefull function remove factor that appear, noticeably after loading
#' with 'ODBC'
#' 
#' function used to remove factors that appear, noticeably after loading with
#' 'ODBC'
#' 
#' 
#' @param df a data.frame
#' @return df
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export killfactor
			killfactor=function(df){
				for (i in 1:ncol(df))
				{
					if(is.factor(df[,i])) df[,i]=as.character(df[,i])
				}
				return(df)
			}
				
			# The connection might already be opened, we will avoid to go through there !
			if (is.null(object@connection)){ 				
				if (length(object@baseODBC)!=3)  {
					if (exists("baseODBC",envir=envir_stacomi)) {
						object@baseODBC<-get("baseODBC",envir=envir_stacomi)  
					} else {
						funout(msg1,arret=TRUE)
					}
				}
				# opening of 'ODBC' connection
				e=expression(channel <-odbcConnect(object@baseODBC[1],
								uid = object@baseODBC[2],
								pwd = object@baseODBC[3],
								case = "tolower",
								believeNRows = FALSE))
				if (!object@silent) funout(paste(msg2,object@baseODBC[1],"\n"))
				# send the result of a try catch expression in
				#the Currentconnection object ie a character vector
				object@connection<-tryCatch(eval(e), error=paste(msg3 ,object@baseODBC)) 
				# un object S3 RODBC
				if (class(object@connection)=="RODBC") {
					if (!object@silent)funout(msg4)
					object@etat=msg4# success
				} else {
					object@etat<-object@connection # report of the error
					object@connection<-NULL
					funout(msg3,arret=TRUE)
				}
				# sending the query
			} 
			if (!object@silent) funout(msg5) # query trial
			if (verbose) print(object@sql)
			query<-data.frame() # otherwise, query called in the later expression is evaluated as a global variable by RCheck
			e=expression(query<-sqlQuery(object@connection,object@sql,errors=TRUE))
			if (object@open) {
				# If we want to leave the connection open no finally clause
				resultatRequete<-tryCatch(eval(e),error = function(e) e)
			} else {
				# otherwise the connection is closed while ending the request
				resultatRequete<-tryCatch(eval(e),error = function(e) e,finally=RODBC::odbcClose(object@connection))
			}
			if ((class(resultatRequete)=="data.frame")[1]) {
				if (!object@silent) funout(msg6)
				object@query=killfactor(query)    
				object@etat=msg6
			} else {
				if (!object@silent) print(resultatRequete)
				object@etat=as.character(resultatRequete)
				print(object@etat)
			}
			return(object)
			
		})
