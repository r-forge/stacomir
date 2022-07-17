#' @title RequeteDBwhere class 
#' @note Inherits from RequeteDBwhere and uses its connect method with a new SetAs
#' @slot datedebut "POSIXlt"
#' @slot datefin "POSIXlt"
#' @slot colonnedebut "character" # name of the column containing datedebut
#' @slot colonnefin "character"  # name of the column containing datefin
#' @examples object=new("RequeteDBwhere")
#' @export
setClass(Class="RequeteDBwheredate",
		representation= representation(datedebut="POSIXlt",datefin="POSIXlt",colonnedebut="character",colonnefin="character"),
		prototype = list(silent=TRUE,open=FALSE),contains="RequeteDBwhere")


setAs("RequeteDBwheredate","RequeteDBwhere",function(from,to){
			requeteDBwhere=new("RequeteDBwhere")
			requeteDBwhere@where=paste("WHERE (",from@colonnedebut,
					", ",from@colonnefin,
					") overlaps ('",
					from@datedebut,"'::timestamp without time zone, '",
					from@datefin,"'::timestamp without time zone) ",sep="")
			requeteDBwhere@and=paste(from@and,sep=" ") # concatenation du vecteur
			requeteDBwhere@select=from@select
			requeteDBwhere@order_by=from@order_by
			requeteDBwhere@silent=from@silent
			# other slots will be filled in by connect	
			return(requeteDBwhere)
		})
#' query method loads a request to the database and returns either an error or a data.frame
#' 
#' @aliases query.RequeteDBwheredate
#' @param object an object of class RequeteDBwheredate
#' @param ... further arguments passed to the query method, base will be passed to ConnectionDB to set the connection parameters,
#' @return An object of class RequeteDBwheredate
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples 
#' \dontrun{
#' object<-new("RequeteDBwheredate")
#' base=c("bd_contmig_nat","localhost","5432","user", "password")
#' object@select<- "select * from t_operation_ope"
#' object@datedebut=strptime("1996-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S")
#' object@datefin=strptime("2000-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S")
#' object@colonnedebut="ope_date_debut"
#' object@colonnefin="ope_date_fin"
#' object@and<-c("AND ope_dic_identifiant=1","AND ope_dic_identifiant=2")
#' object@order_by<-"ORDER BY ope_identifiant"
#' object@silent=FALSE
#' object<-connect(object, base)
#' }
setMethod("query",signature=signature("RequeteDBwheredate"),
		definition=function(object, ...) {
			requeteDBwhere=as(object,"RequeteDBwhere")
			requeteDBwhere=query(requeteDBwhere, ...) # use the connect method of DBwhere
			# collects in the object the elements of the query
			object@where <- requeteDBwhere@where
			object@connection <- requeteDBwhere@connection
			object@query <- requeteDBwhere@query
			object@status <- requeteDBwhere@status
			object@sql <- requeteDBwhere@sql
			return(object)
		})

