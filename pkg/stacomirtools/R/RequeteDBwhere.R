#' @title RequeteDBwhere class 
#' @note Inherits from RequeteDB
#' the syntax is where="WHERE ..."
#' and =vector("AND...","AND...")
#' order_by="ORDER BY.."
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @slot select "character"
#' @slot where "character"
#' @slot and "vector"
#' @slot order_by "character"
#' @examples
#'  object=new("RequeteDBwhere")
#' @export
setClass(Class="RequeteDBwhere",
		representation= representation(select="character",where="character",and="vector",order_by="character"),
		prototype = list(silent=TRUE,open=FALSE),contains="RequeteDB")



setAs("RequeteDBwhere","RequeteDB",function(from,to){
			requeteDB=new("RequeteDB")
			requeteDB@sql=paste(from@select,from@where,paste(from@and,collapse=" "),from@order_by,";",sep=" ")
			requeteDB@silent=from@silent
			# other slots will be filled in by connect	
			return(requeteDB)
		})
#' query method loads a request to the database and returns either an error or a data.frame
#' @aliases query.RequeteODBCwhere
#' @param object an object of class RequeteDBwhere
#' @param ... further arguments passed to the query method, base will be passed to ConnectionDB to set the connection parameters,
#' @return An object of class RequeteODBCwhere
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples 
#' \dontrun{
#' object<-new("RequeteODBCwhere")
#' base=c("bd_contmig_nat","localhost","5432","user", "password")
#' object@sql<- "select * from t_lot_lot"
#' object@where<-"WHERE lot_tax_code='2038'"
#' object@and<-c("AND lot_std_code='CIV'","AND lot_ope_identifiant<1000")
#' object@order_by<-"ORDER BY lot_identifiant"
#' object <- connect(object, base)
#'}
setMethod("query",signature=signature("RequeteDBwhere"),definition=function(object, ...) {
			requeteDB <- as(object,"RequeteDB")
			requeteDB <- query(requeteDB, ...) # uses mother class method
			object@sql <- requeteDB@sql
			object@connection <- requeteDB@connection
			object@query <- requeteDB@query
			object@status <- requeteDB@status
			return(object)
		})
