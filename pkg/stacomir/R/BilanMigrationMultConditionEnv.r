#' Class "BilanMigrationMultConditionEnv"
#' 
#' Enables to compute an annual overview of fish migration and environmental
#' conditions in the same chart. Environmental conditions may trigger migration events, variation in flow
#' or temperatures can  be plotted along migration to check graphically for a possible relation. To enable this, 
#' environmental conditions are loaded from an "environmental monitoring station", which records environmental
#' parameters and is attached to a migratory station in the database.
#' This class enables both continuous output (temperature -flow) as well as discrete parameters (qualitative = moon 
#' phase, type of operation of a gate, opening of a gate...) which will be displayed on the graph. Values are scaled so that 
#' single plot can display migration numbers and environmental parameters. Environmental parameters when stored at a 
#' time scale lower that a day are averaged per day, unless they are qualitative parameters, in which case only the first
#' event of the day is displayed on the annual plot.
#' 
#' @include BilanMigrationMult.r 
#' @include BilanConditionEnv.r
#' @include create_generic.r
#' @include utilitaires.r
#' @slot bilanMigrationMult \link{BilanMigrationMult-class}
#' @slot bilanConditionEnv \link{BilanConditionEnv-class}
#' @author cedric.briand"at"eptb-vilaine.fr marion.legrand"at"logrami.fr
#' @family Bilan Objects
#' @keywords classes
#' @aliases BilanMigrationMultConditionEnv bilanmigrationmultconditionenv
#' @keywords classes
#' @example inst/examples/bilanMigrationMultConditionEnv_example.R
#' @export
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @family Bilan Objects
#' @keywords classes
#' @export 
setClass(Class="BilanMigrationMultConditionEnv",representation=
				representation(
						bilanMigrationMult="BilanMigrationMult",
						bilanConditionEnv="BilanConditionEnv"
				),
		prototype=prototype(
				bilanMigrationMult=new("BilanMigrationMult"),
				bilanConditionEnv=new("BilanConditionEnv")
		
		)
)


setValidity("BilanMigrationMultConditionEnv",
		function(object)
		{
			rep1=validObject(object@bilanMigrationMult, test=TRUE)
			rep2=validObject(object@bilanConditionEnv, test=TRUE)			
			return(ifelse(rep1 & rep2 ,TRUE,c(1:2)[!c(rep1, rep2)]))
		}   
)
#' connect method for BilanMigrationMultConditionEnv class
#' @param object An object of class \link{BilanMigrationMultConditionEnv-class}
#' @param silent Default FALSE, if TRUE the program should no display messages
#' @return an object of BilanMigrationMultConditionEnv class
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("connect",signature=signature("BilanMigrationMultConditionEnv"),definition=function(object,silent=FALSE) {
			#object<-bmmCE
			bmmCE<-object
			bmmCE@bilanMigrationMult<-connect(bmmCE@bilanMigrationMult,silent=silent)
			bmmCE@bilanConditionEnv<-connect(bmmCE@bilanConditionEnv,silent=silent)
			return(bmmCE)
		}
)
#' command line interface for BilanConditionEnv class
#' @param object An object of class \link{BilanConditionEnv-class}
#' @param dc A numeric or integer, the code of the dc, coerced to integer,see \link{choice_c,RefDC-method}
#' @param taxons '2038=Anguilla anguilla',
#' these should match the ref.tr_taxon_tax referential table in the stacomi database, see \link{choice_c,RefTaxon-method}
#' @param stades 'AGJ=Anguille jaune', 'AGG=Anguille argentee', 'CIV=civelle'
#' @param stationMesure A character, the code of the monitoring station, which records environmental parameters \link{choice_c,RefStationMesure-method}
#' @param datedebut The starting date as a character, formats like \code{\%Y-\%m-\%d} or \code{\%d-\%m-\%Y} can be used as input
#' @param datefin The finishing date of the Bilan, for this class this will be used to calculate the number of daily steps.
#' @param silent Boolean default FALSE, if TRUE information messages not displayed.
#' @return An object of class \link{BilanConditionEnv-class}
#' The choice_c method fills in the data slot for RefStationMesure and  and then 
#' uses the choice_c methods of these object to select the data.
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("choice_c",signature=signature("BilanMigrationMultConditionEnv"),definition=function(object,dc,taxons,stades,stationMesure,datedebut,datefin,silent=FALSE){
			# code for debug
			# dc=c(5,6,12);	taxons=c("Anguilla anguilla");stades=c("AGJ","AGG","CIV");
			# stationMesure=c("temp_gabion","coef_maree");
			# datedebut="2008-01-01";datefin="2008-12-31";silent=FALSE
			bmmCE<-object
			bmmCE@bilanMigrationMult=
					choice_c(bmmCE@bilanMigrationMult,
							dc=dc,
							taxons=taxons,
							stades=stades,
							datedebut=datedebut,
							datefin=datefin,
							silent=silent)
			bmmCE@bilanConditionEnv=choice_c(bmmCE@bilanConditionEnv,
					stationMesure=stationMesure,
					datedebut=datedebut,
					datefin=datefin,
					silent=silent)
			return(bmmCE)
		})
#' charge method for BilanMigrationMultConditionEnv class
#' @param object An object of class \link{BilanMigrationMultConditionEnv-class}
#' @param silent Should the function remain silent (boolean)
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("charge",signature=signature("BilanMigrationMultConditionEnv"),definition=function(object,silent=FALSE) {
			# silent=FALSE
			bmmCE<-object
			bmmCE@bilanMigrationMult<-charge(bmmCE@bilanMigrationMult,silent=silent)
			# the values for date are not initiated by the interface
			assign("bilanConditionEnv_date_debut",get("pasDeTemps",envir_stacomi)@"dateDebut",envir_stacomi)
			assign("bilanConditionEnv_date_fin",as.POSIXlt(DateFin(get("pasDeTemps",envir_stacomi))),envir_stacomi)
			bmmCE@bilanConditionEnv<-charge(bmmCE@bilanConditionEnv,silent=silent)    		
			return(bmmCE)
		})

#' Internal handler function
#' @param h a handler
#' @param ... Additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
hbmmCEcalc=function(h=null,...){
	bmmCE<-get("bmmCE",envir_stacomi)	
	bmmCE<-charge(bmmCE)
	bmmCE<-connect(bmmCE)
	bmmCE<-calcule(bmmCE)
	assign("bmmCE",bmmCE,envir_stacomi)
	toolbarlist<-get("toolbarlist",envir_stacomi)
	enabled(toolbarlist[["Graph"]])<-TRUE
	return(invisible(NULL))	
}

#' Calculation for the BilanMigrationMultConditionEnv
#' 
#' @param object An object of class \code{\link{BilanMigrationMultConditionEnv-class}}
#' @param silent Boolean default FALSE, if TRUE information messages not displayed
#' @return \code{\link{BilanMigrationMultConditionEnv-class}}
#' @export
setMethod("calcule",signature=signature("BilanMigrationMultConditionEnv"),definition=function(object,silent=FALSE){ 
			# silent=FALSE
			bmmCE<-object
			bmmCE@bilanMigrationMult<-calcule(bmmCE@bilanMigrationMult,silent=silent)			
			if (!silent) funout(gettext("bmmCE object is stocked into envir_stacomi environment\n",domain="R-stacomiR"))
			return(bmmCE)
		})



#' internal method for graphical interface
#' @param h A handler
hbmmCEgraph = function(h=null){   
	bmmCE<-get("bmmCE",envir_stacomi)
	bmmCE<-plot(bmmCE)
	return(invisible(NULL))	
}

#' Plot method for BilanMigrationMultConditionEnv
#' @param x An object of class \link{BilanMigrationMultConditionEnv}
#' @param silent Stops displaying the messages.
#' @param color_station A named vector of station color (e.g. c("temp_gabion"="red","coef_maree"="blue","phases_lune"="green")) default null
#' @param color_dc A named vector giving the color for each dc default null (e.g. c("5"="#4D4D4D","6"="#E6E6E6","12"="#AEAEAE"))
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @aliases plot.BilanMigrationMultConditionEnv plot.bmmCE
#' @export
setMethod("plot", signature(x = "BilanMigrationMultConditionEnv", y = "missing"), 
		definition=function(x,  color_station=NULL,color_dc=NULL, silent=FALSE){ 
			#color_station=NULL;color_dc=NULL
			# color_station<-c("temp_gabion"="red","coef_maree"="blue","phases_lune"="green")
			# color_dc=c("5"="#4D4D4D","6"="#E6E6E6","12"="#AEAEAE")
			bmmCE<-x
			
			
			grdata<-fun_aggreg_for_plot(bmmCE@bilanMigrationMult)
			# we collect the dataset used to build the graph
			
			taxons= as.character(bmmCE@bilanMigrationMult@taxons@data$tax_nom_latin)
			stades= as.character(bmmCE@bilanMigrationMult@stades@data$std_libelle)
			dc<-unique(grdata$DC)
			stations<-bmmCE@bilanConditionEnv@stationMesure@data
			dc_code<-bmmCE@bilanMigrationMult@dc@data$dc_code[
					match(dc,bmmCE@bilanMigrationMult@dc@data$dc)]
			# tableau conditions environnementales
			tableauCE<-bmmCE@bilanConditionEnv@data  
			if (nrow(tableauCE)==0) {
				funout(gettext("You don't have any environmental conditions within the time period\n",domain="R-stacomiR"),arret=TRUE)
			}
					
			# we collect libelle from station
			for (i in 1:length(unique(tableauCE$env_stm_identifiant))){
				tableauCE[unique(tableauCE$env_stm_identifiant)[i]==tableauCE$env_stm_identifiant,"stm_libelle"]<-
						stations[stations$stm_identifiant==unique(tableauCE$env_stm_identifiant)[i],"stm_libelle"]
			}
			# the data can be in the POSIXct format, we need to round them
			tableauCE$date<-as.POSIXct(round.POSIXt(tableauCE$env_date_debut,units="days"))
			qualitative<-!is.na(tableauCE$env_val_identifiant)
			tableauCEquan<-tableauCE[!qualitative,]
			tableauCEqual<-tableauCE[qualitative,]
			if (nrow(unique(cbind(tableauCE$date,tableauCE$stm_libelle)))!=	nrow(tableauCE)) {
				# do not cut character chain below...
				funout(gettextf("Attention, on one station :%s there are several entries for the same day :%s we will calculate average for numeric	and use the first value for qualitative parameter",
								sta,
								paste(unique(tableauCEst$env_date_debut[duplicated(tableauCEst$env_date_debut)]),sep="")),
						arret=FALSE)	
				# for quantitative parameters we group by date and station and use the average to
				# extract one value per day
				tableauCEquan<-dplyr::select(tableauCEquan,date,stm_libelle,env_valeur_quantitatif)%>%
						dplyr::group_by(date,stm_libelle)%>%						
						dplyr::summarize(valeur=mean(env_valeur_quantitatif))%>%
						dplyr::ungroup()
				# for qualitative value, when there are several values for the same date
				# we arbitrarily select the first
				tableauCEqual<-dplyr::select(tableauCEqual,date,stm_libelle,env_val_identifiant)%>%
						dplyr::group_by(date,stm_libelle)%>%						
						dplyr::summarize(valeur=first(env_val_identifiant))%>%
						dplyr::ungroup()
			} else {
				# we want the same format as above
				tableauCEquan<-dplyr::select(tableauCEquan,date,stm_libelle,env_valeur_quantitatif)%>%
						dplyr::rename(valeur=env_valeur_quantitatif)
				tableauCEqual<-dplyr::select(tableauCEqual,date,stm_libelle,env_val_identifiant)%>%
						dplyr::rename(valeur=env_val_identifiant)
			}	
			variables_quant<-unique(tableauCEquan$stm_libelle)
			variables_qual<-unique(tableauCEqual$stm_libelle)
			grdata<-funtraitementdate(grdata,
					nom_coldt="debut_pas",
					annee=FALSE,
					mois=TRUE,
					quinzaine=TRUE,
					semaine=TRUE,
					jour_an=TRUE,
					jour_mois=FALSE,
					heure=FALSE)	
			
			# to rescale everything on the same graph
			maxeff=floor(log10(max(grdata$effectif_total,na.rm=TRUE)))
			
			for (i in 1:length(variables_quant)){
				diff=maxeff-round(log10(max(tableauCEquan[tableauCEquan$stm_libelle==variables_quant[i],"valeur"],na.rm=TRUE)))
				if (diff!=0 & !is.na(diff)){
					tableauCEquan[tableauCEquan$stm_libelle==variables_quant[i],"valeur"] = as.numeric(tableauCEquan[tableauCEquan$stm_libelle==variables_quant[i],"valeur"])*10^diff    
					variables_quant[i]=paste(variables_quant[i],".10^",diff,sep="")
				} # end if
			} #end for			
			yqualitatif=(10^(maxeff))/2
			
			ylegend=gettextf("Number, %s, %s",paste(variables_quant,collapse=", "),
					paste(variables_qual,collapse=", "))
			
			
			######################
			# treatment of data to group by dc
			# if several taxa or stages are passed, they are aggregated with a warning
			#################################
			if (length(unique(taxons))>1) warning(gettextf("you have %s taxa in the bilan, those will be aggregated",length(unique(taxons))))
			if (length(unique(stades))>1) warning(gettextf("you have %s stages in the bilan, those will be aggregated",length(unique(stades))))		
			plotdata<-dplyr::select(grdata,debut_pas,DC,effectif_total)%>%dplyr::rename(date=debut_pas)%>%
					dplyr::group_by(date,DC)%>%dplyr::summarize(effectif=sum(effectif_total))%>%
					dplyr::ungroup()
			
			#######################
			# color scheme for station
			#######################
			
			cs<-colortable(color=color_station,vec=stations$stm_libelle,palette="Accent")			
			cs<-stacomirtools::chnames(cs,"name","stm_libelle")
			#######################
			# color scheme for dc
			#######################		
			cdc<-colortable(color=color_dc,vec=dc,color_function="gray.colors")			
			cdc<-stacomirtools::chnames(cdc,"name","DC")
			#######################
			# merging with colors for manual scales
			######################
			plotdata<-killfactor(merge(plotdata,cdc,by="DC"))
			tableauCEquan<-killfactor(merge(tableauCEquan,cs,by="stm_libelle"))
			tableauCEqual<-killfactor(merge(tableauCEqual,cs,by="stm_libelle"))
			
			g<-ggplot(plotdata)+
					geom_bar(aes(x=date,y=effectif,fill =color),position="stack", stat="identity")+
					ylab(ylegend)+
					geom_line(aes(x=date,y=valeur,colour=color),data=tableauCEquan,size=1)+						
					geom_point(aes(x=date,shape=valeur,
									colour=color),
							y=yqualitatif,data=tableauCEqual,size=3)+
					scale_fill_identity(name=gettext("DC"),labels=dc_code,guide = "legend")+
					scale_colour_identity(name=gettext("stations"),
							labels=cs[,"stm_libelle"],
							breaks=cs[,"color"],
							guide = "legend")+
					scale_shape(guide="legend",name=gettext("Qualitative parm"))+
					theme_bw()	
			print(g)
			assign("g",g,envir_stacomi)
			if (!silent) funout(gettext("the ggplot object has been assigned to envir_stacomi, type g<-get('g',envir_stacomi)"))
			
		})# end function




