#' @title RequeteODBCwhere class 
#' @note Inherits from RequeteODBCwhere and uses its connect method with a new SetAs
#' @slot datedebut "POSIXlt"
#' @slot datefin "POSIXlt"
#' @slot colonnedebut "character" # name of the column containing datedebut
#' @slot colonnefin "character"  # name of the column containing datefin
#' @examples
#'  object=new("RequeteODBCwhere")
#' @export
setClass(Class="RequeteODBCwheredate",
    representation= representation(datedebut="POSIXlt",datefin="POSIXlt",colonnedebut="character",colonnefin="character"),
    prototype = list(silent=TRUE,open=FALSE),contains="RequeteODBCwhere")


setAs("RequeteODBCwheredate","RequeteODBCwhere",function(from,to){
      requeteODBCwhere=new("RequeteODBCwhere")
      requeteODBCwhere@where=paste("WHERE (",from@colonnedebut,
          ", ",from@colonnefin,
          ") overlaps ('",
          from@datedebut,"'::timestamp without time zone, '",
          from@datefin,"'::timestamp without time zone) ",sep="")
      requeteODBCwhere@and=paste(from@and,sep=" ") # concatenation du vecteur
      requeteODBCwhere@select=from@select
      requeteODBCwhere@order_by=from@order_by
      requeteODBCwhere@baseODBC=from@baseODBC
      requeteODBCwhere@silent=from@silent
      # other slots will be filled in by connect  
      return(requeteODBCwhere)
    })
#' connect method loads a request to the database and returns either an error or a data.frame
#' 
#' @aliases connect.RequeteODBCwheredate
#' @param object an object of class RequeteODBCwheredate
#' @note method modified from v0.2.1240 to use the connect method of the mother class which in turn will use the method of the mother class
#' @return An object of class RequeteODBCwheredate
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples 
#' \dontrun{
#' object<-new("RequeteODBCwheredate")
#' object@baseODBC<-get("baseODBC",envir=envir_stacomi)
#' object@select<- "select * from t_operation_ope"
#' object@datedebut=strptime("1996-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S")
#' object@datefin=strptime("2000-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S")
#' object@colonnedebut="ope_date_debut"
#' object@colonnefin="ope_date_fin"
#' object@and<-c("AND ope_dic_identifiant=1","AND ope_dic_identifiant=2")
#' object@order_by<-"ORDER BY ope_identifiant"
#' object@silent=FALSE
#' object<-connect(object) 
#' }
setMethod("connect",signature=signature("RequeteODBCwheredate"),definition=function(object) {
      #.Deprecated(new= "RequeteDBwheredate",old="RequeteODBCwheredate")
      requeteODBCwhere=as(object,"RequeteODBCwhere")
      requeteODBCwhere=connect(requeteODBCwhere) # use the connect method of ODBCwhere
      # collects in the object the elements of the query
      object@where=requeteODBCwhere@where
      object@connection=requeteODBCwhere@connection
      object@query=requeteODBCwhere@query
      object@etat=requeteODBCwhere@etat
      object@sql=requeteODBCwhere@sql
      return(object)
    })
