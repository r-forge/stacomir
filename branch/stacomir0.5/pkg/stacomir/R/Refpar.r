# Nom fichier :        RefPar  (classe)
# Contact :            cedric.briand@lavilaine.com
# Date de creation :   22/03/2009 21:14:14

#TODO  selection de plusieurs caracteristiques

#' @title Refpar referential class choose a parameter
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @slot data="data.frame" the list of parameters
#' @example objet=new("Refpar")
setClass(Class="Refpar",representation= representation(data="data.frame"))

#' Loading method for Repar referential objects
#' @returnType S4 object
#' @return An S4 object of class Refpar
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @example 
#'  objet=new("Refpar")
#' charge(objet)
setMethod("charge",signature=signature("Refpar"),definition=function(objet) {
			requete=new("RequeteODBC")
			requete@baseODBC=baseODBC
			requete@sql= paste("SELECT par_code, par_nom  from ref.tg_parametre_par")
			requete<-connect(requete)
			funout(get("msg",envir=envir_stacomi)$Refpar.1)
			objet@data<-requete@query
			return(objet)
		})
#' Loading method for Repar referential objects searching only those parameters existing for a DC, a Taxon, and a stade
#' @returnType S4 object
#' @return An S4 object of class Refpar
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @example 
#'  objet=new("Refpar")
#' #'  dc_selectionne=c(5,6,8)
#'	taxon_selectionne=c(2038,2014)
#' stade_selectionne=c("IND","CIV","AGJ","AGG","8")
#' charge_avec_filtre(objet,dc_selectionne=6,taxon_selectionne=2038,stade_selectionne="CIV")
setMethod("charge_avec_filtre",signature=signature("Refpar"),definition=function(objet,dc_selectionne,taxon_selectionne,stade_selectionne) {
			requete=new("RequeteODBCwhere")
			requete@baseODBC=baseODBC
			requete@select=paste("SELECT DISTINCT ON (par_code) par_code, par_nom", 
					" FROM ",sch,"tg_dispositif_dis",
					" JOIN ",sch,"t_dispositifcomptage_dic on dis_identifiant=dic_dis_identifiant",
					" JOIN ",sch,"t_operation_ope on ope_dic_identifiant=dic_dis_identifiant",
					" JOIN ",sch,"t_lot_lot on lot_ope_identifiant=ope_identifiant",
					" JOIN ",sch,"tj_caracteristiquelot_car on car_lot_identifiant=lot_identifiant",
					" JOIN ref.tg_parametre_par on par_code=car_par_code",sep="")
			requete@where=paste(" where dis_identifiant in (",paste(dc_selectionne,collapse=","),")",sep="")
			requete@and=paste(paste(" and lot_tax_code in ('",paste(taxon_selectionne,collapse="','"),"')",sep=""),
					paste(" and lot_std_code in ('",paste(stade_selectionne,collapse="','"),"')",sep=""),sep="")
			requete@order_by="ORDER BY par_code"  
			requete=connect(requete)  # appel de la methode connect de l'objet requeteODBC
			objet@data<-requete@query
			if (nrow(objet@data)==0) funout(get("msg",envir=envir_stacomi)$Refpar.2,arret=TRUE)
			return(objet)
		})
#' Choice method for Refpar referential objects
#' @note the choice method assigns an object of class Refpar named refpar in the environment envir_stacomi
#' @note this method choix is also on sons objects Refparquan, hence the parameters,however it was redefined in refparqual
#' @note to load the possible values of qualitative parameters
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @example  
#'  objet=new("Refpar")
#' win=gwindow()
#' group=ggroup(container=win,horizontal=FALSE)
#' objet<-charge(objet)
#' choix(objet)
setMethod("choix",signature=signature("Refpar"),definition=function(objet,label="Choix d'une caracteristique de lot",nomassign="refpar",frameassign="frame_par",is.enabled=TRUE) {
			if (nrow(objet@data) > 0){
				hcar=function(h,...){
					carchoisi=svalue(choix)
					objet@data<-objet@data[car_libelle%in%carchoisi ,]
					assign(nomassign,objet,envir_stacomi)
					funout(get("msg",envir=envir_stacomi)$Refpar.3)
				}
				#frame_par<<-gframe(label)
				assign(frameassign,gframe(label,horizontal=FALSE),envir= .GlobalEnv)
				# pour pouvoir la supprimer ensuite
				add(group,get(eval(frameassign),envir= .GlobalEnv))
				car_libelle=fun_char_spe(objet@data$par_nom)
				car_libelle[nchar(car_libelle)>30]<-paste(substr(car_libelle[nchar(car_libelle)>30],1,30),".",sep="")
				choix=gdroplist(items=car_libelle,container=get(eval(frameassign),envir= .GlobalEnv),handler=hcar)
				gbutton("OK", container=get(eval(frameassign),envir= .GlobalEnv),handler=hcar)
			} else funout(get("msg",envir=envir_stacomi)$Refpar.4,arret=TRUE)
		})