#' Migration report for one DC, one species and one stage
#' 
#' @include RefTaxon.r
#' @include RefStades.r
#' @include PasDeTempsJournalier.r
#' @slot dc Object of class \link{RefDC-class}: the control device 
#' @slot taxons Object of class \link{RefTaxon-class}: the species
#' @slot stades Object of class \link{RefStades-class} : the stage of the fish
#' @slot pasDeTemps Object of class \link{PasDeTempsJournalier-class} : the time step 
#' constrained to daily value and 365 days
#' @slot data Object of class \code{data.frame} with data filled in from the connect method
#' @slot calcdata A "list" of calculated daily data, one per dc, filled in by the calcule method
#' @slot coef_conversion A data.frame of daily weight to number conversion coefficients, filled in by the connect 
#' method if any weight are found in the data slot.
#' @slot time.sequence Object of class \code{POSIXct} : a time sequence of days generated by the calcule method
#' @note TODO discuss  and how it is used to "write" in the database
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @seealso Other Bilan Class \code{\linkS4class{Bilan_carlot}}, 
#' \code{\linkS4class{Bilan_poids_moyen}}, 
#' \code{\linkS4class{Bilan_stades_pigm}}, \code{\linkS4class{Bilan_taille}}, 
#' \code{\linkS4class{BilanConditionEnv}}, \code{\linkS4class{BilanEspeces}}, 
#' \code{\linkS4class{BilanFonctionnementDC}}, 
#' \code{\linkS4class{BilanFonctionnementDF}}, 
#' \code{\linkS4class{BilanMigration}}, 
#' \code{\linkS4class{BilanMigrationConditionEnv}}, 
#' \code{\linkS4class{BilanMigrationInterAnnuelle}}, 
#' \code{\linkS4class{BilanMigrationPar}}
#' @concept Bilan Object 
#' @example examples/02_BilanMigration/bilanMigration_Arzal.R
#' @export 
setClass(Class="BilanMigration",
		representation=
				representation(dc="RefDC",
						taxons="RefTaxon",
						stades="RefStades",
						pasDeTemps="PasDeTempsJournalier",
						data="data.frame",
						calcdata="list",
						coef_conversion="data.frame",
						time.sequence="POSIXct"),
		prototype=prototype(dc=new("RefDC"),
				taxons=new("RefTaxon"),
				stades=new("RefStades"),
				pasDeTemps=new("PasDeTempsJournalier"),
				data=data.frame(),
				calcdata=list(),
				coef_conversion=data.frame(),
				time.sequence=as.POSIXct(Sys.time()) 
		))
# bilanMigration= new("BilanMigration")

setValidity("BilanMigration",function(object)
		{
			rep1=length(object@dc)==1
			rep2=length(object@taxons)==1
			rep3=length(object@stades)==1
			rep3=length(object@pasDeTemps)==1
			rep4=(object@pasDeTemps@nbStep==365|object@pasDeTemps@nbStep==366) # constraint 365 to 366 days
			rep5=as.numeric(strftime(object@pasDeTemps@dateDebut,'%d'))==1 # contrainte : depart = 1er janvier
			rep6=as.numeric(strftime(object@pasDeTemps@dateDebut,'%m'))==1
			return(ifelse(rep1 & rep2 & rep3 & rep4 & rep5 & rep6 , TRUE ,c(1:6)[!c(rep1, rep2, rep3, rep4, rep5, rep6)]))
		}   
)

#' handler for calculations BilanMigration
#' 
#'  internal use
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
hbilanMigrationcalc=function(h,...){
	bilanMigration<-get("bilanMigration",envir=envir_stacomi)
	bilanMigration<-charge(bilanMigration)
	# charge loads the method connect
	bilanMigration<-calcule(bilanMigration)
}

#' connect method for BilanMigration
#' 
#' 
#' uses the BilanMigrationMult method
#' @param object An object of class \link{BilanMigration-class}
#' @return BilanMigration with slot @data filled from the database
#' @export
setMethod("connect",signature=signature("BilanMigration"),definition=function(object){ 
			bilanMigration<-object
			bilanMigrationMult<-as(bilanMigration,"BilanMigrationMult")
			bilanMigrationMult<-connect(bilanMigrationMult)
			bilanMigration@data<-bilanMigrationMult@data		
			return(bilanMigration)
		})
#' command line interface for BilanMigration class
#' @param object An object of class \link{BilanMigration-class}
#' @param dc A numeric or integer, the code of the dc, coerced to integer,see \link{choice_c,RefDC-method}
#' @param taxons Either a species name in latin or the SANDRE code for species (ie 2038=Anguilla anguilla),
#' these should match the ref.tr_taxon_tax referential table in the stacomi database, see \link{choice_c,RefTaxon-method}
#' @param stades A stage code matching the ref.tr_stadedeveloppement_std table in the stacomi database see \link{choice_c,RefStades-method}
#' @param datedebut The starting date as a character, formats like \code{\%Y-\%m-\%d} or \code{\%d-\%m-\%Y} can be used as input
#' @param datefin The finishing date of the Bilan, for this class this will be used to calculate the number of daily steps.
#' The choice_c method fills in the data slot for RefDC, RefTaxon, RefStades, and RefPasDeTempsJournalier and then 
#' uses the choice_c methods of these object to select the data.
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("choice_c",signature=signature("BilanMigration"),definition=function(object,dc,taxons,stades,datedebut,datefin){
			# code for debug using bM_Arzal example
			#bilanMigration<-bM_Arzal;dc=5;taxons="Liza ramada";stades="IND";datedebut="2015-01-01";datefin="2015-12-31"
			bilanMigration<-object
			fonctionnementDC=new("BilanFonctionnementDC")
			# appel ici pour pouvoir utiliser les fonctions graphiques associees sur fonctionnement du DC
			assign("fonctionnementDC",fonctionnementDC,envir = envir_stacomi)
			bilanMigration@dc=charge(bilanMigration@dc)
			# loads and verifies the dc
			# this will set dc_selectionne slot
			bilanMigration@dc<-choice_c(object=bilanMigration@dc,dc)
			# only taxa present in the bilanMigration are used
			bilanMigration@taxons<-charge_avec_filtre(object=bilanMigration@taxons,bilanMigration@dc@dc_selectionne)			
			bilanMigration@taxons<-choice_c(bilanMigration@taxons,taxons)
			bilanMigration@stades<-charge_avec_filtre(object=bilanMigration@stades,bilanMigration@dc@dc_selectionne,bilanMigration@taxons@data$tax_code)	
			bilanMigration@stades<-choice_c(bilanMigration@stades,stades)
			bilanMigration@pasDeTemps<-choice_c(bilanMigration@pasDeTemps,datedebut,datefin)
			bilanMigration<-connect(bilanMigration)
			stopifnot(validObject(bilanMigration, test=TRUE))
			assign("bilanMigration",bilanMigration,envir = envir_stacomi)
			return(bilanMigration)
		})

#' charge method for BilanMigration
#' 
#' fills also the data slot by the connect method
#' @param object An object of class \code{\link{BilanMigration-class}}
#' @return An object of class \link{BilanMigration-class} with slots filled by user choice
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("charge",signature=signature("BilanMigration"),definition=function(object){ 
			bilanMigration<-object
			#pour l'instant ne lancer que si les fenetre sont fermees
			# funout("lancement updateplot \n")
			if (exists("refDC",envir_stacomi)) {
				bilanMigration@dc<-get("refDC",envir_stacomi)
			} else {
				funout(get("msg",envir_stacomi)$ref.1,arret=TRUE)	
			}
			if (exists("refTaxons",envir_stacomi)) {
				bilanMigration@taxons<-get("refTaxons",envir_stacomi)
			} else {      
				funout(get("msg",envir_stacomi)$ref.2,arret=TRUE)
			}
			if (exists("refStades",envir_stacomi)){
				bilanMigration@stades<-get("refStades",envir_stacomi)
			} else 
			{
				funout(get("msg",envir_stacomi)$ref.3,arret=TRUE)
			}
			if (exists("pasDeTemps",envir_stacomi)){
				bilanMigration@pasDeTemps<-get("pasDeTemps",envir_stacomi)
				# pour permettre le fonctionnement de Fonctionnement DC
				assign("fonctionnementDC_date_debut",get("pasDeTemps",envir_stacomi)@"dateDebut",envir_stacomi)
				assign("fonctionnementDC_date_fin",as.POSIXlt(DateFin(get("pasDeTemps",envir_stacomi))),envir_stacomi)
			} else {
				funout(get("msg",envir=envir_stacomi)$BilanMigration.1,arret=FALSE)
				warning(get("msg",envir=envir_stacomi)$BilanMigration.1)
			}
			bilanMigration=connect(bilanMigration)
			if (!silent) cat(stringr::str_c("data collected from the database nrow=",nrow(bilanMigration@data),"\n"))
			stopifnot(validObject(bilanMigration, test=TRUE))
			if (!silent) funout(get("msg",envir=envir_stacomi)$BilanMigration.2)
			return(bilanMigration)
		})


#' calcule method for BilanMigration
#' 
#'  does the calculation once data are filled,. It also performs conversion from weight to numbers
#' in with the connect method
#' @param object An object of class \code{\link{BilanMigration-class}}
#' @param negative a boolean indicating if a separate sum must be done for positive and negative values, if true, positive and negative counts return 
#' different rows
#' @param silent Boolean, if true, information messages are not displays, only warnings and errors
#' @note The class BilanMigration does not handle escapement rates nor 
#' 'devenir' i.e. the destination of the fishes.
#' @return BilanMigration with calcdata slot filled.
#' @export
setMethod("calcule",signature=signature("BilanMigration"),definition=function(object,negative=FALSE,silent=FALSE){ 
			#bilanMigration<-bM_Arzal
			#negative=FALSE
			if (!silent){
				funout(get("msg",envir_stacomi)$BilanMigration.2)
			}
			bilanMigration<-object

				if (nrow(bilanMigration@data>0)){
#				bilanMigration@data$time.sequence=difftime(bilanMigration@data$ope_date_fin,
#						bilanMigration@data$ope_date_debut,
#						units="days")
				debut=bilanMigration@pasDeTemps@dateDebut
				fin=DateFin(bilanMigration@pasDeTemps)
				time.sequence<-seq.POSIXt(from=debut,to=fin,
						by=as.numeric(bilanMigration@pasDeTemps@stepDuration))
				bilanMigration@time.sequence<-time.sequence
				lestableaux<-list()			
				datasub<-bilanMigration@data	
				dic<-unique(bilanMigration@data$ope_dic_identifiant)
				stopifnot(length(dic)==1)
				if (any(datasub$time.sequence>(bilanMigration@pasDeTemps@stepDuration/86400))){				
					#----------------------
					# bilans avec overlaps
					#----------------------
					data<-fun_bilanMigrationMult_Overlaps(time.sequence = time.sequence, datasub = datasub,negative=negative)
					# pour compatibilite avec les bilanMigration
					data$taux_d_echappement=-1					
					lestableaux[[stringr::str_c("dc_",dic)]][["data"]]<-data
					lestableaux[[stringr::str_c("dc_",dic)]][["method"]]<-"overlaps"
					contient_poids<-"poids"%in%datasub$type_de_quantite
					lestableaux[[stringr::str_c("dc_",dic)]][["contient_poids"]]<-contient_poids
					lestableaux[[stringr::str_c("dc_",dic)]][["negative"]]<-negative
					if (contient_poids){
						coe<-bilanMigration@coef_conversion[,c("coe_date_debut","coe_valeur_coefficient")]
						data$coe_date_debut<-as.Date(data$debut_pas)
						data<-merge(data,coe,by="coe_date_debut")
						data<-data[,-1] # removing coe_date_debut
						data <-fun_weight_conversion(tableau=data,time.sequence=bilanMigration@time.sequence,silent)
					}
					
					lestableaux[[stringr::str_c("dc_",dic)]][["data"]]<-data
					
				} else {
					#----------------------
					#bilan simple
					#----------------------
					data<-fun_bilanMigrationMult(time.sequence = time.sequence,datasub=datasub,negative=negative)
					data$taux_d_echappement=-1
					data$coe_valeur_coefficient=NA
					contient_poids<-"poids"%in%datasub$type_de_quantite
					if (contient_poids){
						coe<-bilanMigration@coef_conversion[,c("coe_date_debut","coe_valeur_coefficient")]
						data$coe_date_debut<-as.Date(data$debut_pas)
						data<-merge(data,coe,by="coe_date_debut")
						data<-data[,-1] # removing coe_date_debut
						data <-fun_weight_conversion(tableau=data,time.sequence=bilanMigration@time.sequence,silent)
					}
					lestableaux[[stringr::str_c("dc_",dic)]][["data"]]<-data
					lestableaux[[stringr::str_c("dc_",dic)]][["method"]]<-"sum"
					lestableaux[[stringr::str_c("dc_",dic)]][["contient_poids"]]<-contient_poids
					lestableaux[[stringr::str_c("dc_",dic)]][["negative"]]<-negative
				}
				# TODO developper une methode pour sumneg 
				bilanMigration@calcdata<-lestableaux
				assign("bilanMigration",bilanMigration,envir_stacomi)
				if (!silent){
					funout(get("msg",envir_stacomi)$BilanMigration.3)
					funout(get("msg",envir_stacomi)$BilanMigration.4)
				}
				return(bilanMigration)
				
				
			} else {
				# no fish...
				funout(get("msg",envir_stacomi)$BilanMigration.10)
			}
		})

		
		
#' handler to print the command line
#' @param h a handler
#' @param ... Additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
		houtBilanMigration=function(h=null,...) {
			if (exists("refStades",envir_stacomi)) 	{
				bilanMigration<-get("bilanMigration",envir_stacomi)
				print(bilanMigration)
			} 
			else 
			{      
				funout(get("msg",envir_stacomi)$BilanMigrationMult.2,arret=TRUE)
			}
		}
		
#' Method to print the command line of the object
#' @param x An object of class BilanMigrationMult
#' @param ... Additional parameters passed to print
#' @return NULL
#' @author cedric.briand
#' @export
setMethod("print",signature=signature("BilanMigration"),definition=function(x,...){ 
			sortie1<-"bilanMigration=new(bilanMigration)\n"
			sortie2<-stringr::str_c("bilanMigration=choice_c(bilanMigration,",
					"dc=c(",stringr::str_c(x@dc@dc_selectionne,collapse=","),"),",
					"taxons=c(",stringr::str_c(shQuote(x@taxons@data$tax_nom_latin),collapse=","),"),",
					"stades=c(",stringr::str_c(shQuote(x@stades@data$std_code),collapse=","),"),",			
					"datedebut=",shQuote(strftime(x@pasDeTemps@dateDebut,format="%d/%m/%Y")),
					",datefin=",shQuote(strftime(DateFin(x@pasDeTemps),format="%d/%m/%Y")),")")
			# removing backslashes
			funout(stringr::str_c(sortie1,sortie2),...)
			return(invisible(NULL))
		})




#' Plots of various type for BilanMigration, and performs writing to the database of daily values.
#' 
#' \itemize{
#' 		\item{plot.type="standard"}{calls \code{\link{fungraph}} and \code{\link{fungraph_civelle}} functions to plot as many "bilanmigration"
#' 			as needed, the function will test for the existence of data for one dc, one taxa, and one stage}
#' 		\item{plot.type="step"}{creates Cumulated graphs for BilanMigrationMult.  Data are summed per day for different dc taxa and stages}
#' 		\item{plot.type="multiple"}{Method to overlay graphs for BilanMigrationMult (multiple dc/taxa/stage in the same plot)}
#' }
#' @note When plotting the "standard" plot, the user will be prompted to "write" the daily migration and monthly migration in the database.
#' these entries are necessary to run the Interannual Migration class. If the stacomi has been launched with database_expected=FALSE,
#' then no entry will be written to the database
#' @param x An object of class BilanMigrationMult
#' @param y From the formals but missing
#' @param plot.type One of "standard","step". Defaut to \code{standard} the standard BilanMigration with dc and operation displayed, can also be \code{step} or 
#' \code{multiple} 
#' @param silent Stops displaying the messages.
#' @param ... Additional arguments, see \code{plot}, \code{plot.default} and \code{par}
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("plot",signature(x = "BilanMigration", y = "ANY"),definition=function(x, y,plot.type="standard",silent=FALSE,...){ 
			#bilanMigration<-bM_Arzal
			bilanMigration<-x
			if (exists("bilanMigration",envir_stacomi)) {
				bilanMigration<-get("bilanMigration",envir_stacomi)
			} else {      
				funout(get("msg",envir_stacomi)$BilanMigration.5,arret=TRUE)
			}
			#§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
			#                 standard plot
			#§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
			if (plot.type=="standard"){
				if (!silent) print("plot type standard")
				if (!silent) funout(get("msg",envir_stacomi)$BilanMigration.9)				
				taxon=bilanMigration@taxons@data[1,"tax_nom_latin"]
				stade=bilanMigration@stades@data[1,"std_libelle"]
				dc=as.numeric(bilanMigration@dc@dc_selectionne)[1]
				# preparation du jeu de donnees pour la fonction fungraph_civ
				#developpee pour la classe BilanMigration
				data<-bilanMigration@calcdata[[stringr::str_c("dc_",dc)]][["data"]]
				if (!is.null(data)){
					if	(nrow(data)>0){						
						if (!silent) {
							funout(paste("dc=",dc,
											"taxon"=taxon,
											"stade"=stade,"\n"))
							funout("---------------------\n")
						}
						if (any(duplicated(data$No.pas))) stop("duplicated values in No.pas")
						data_without_hole<-merge(
								data.frame(No.pas=as.numeric(strftime(bilanMigration@time.sequence,format="%j"))-1,
										debut_pas=bilanMigration@time.sequence),
								data,
								by=c("No.pas","debut_pas"),
								all.x=TRUE
						)
						data_without_hole$CALCULE[is.na(data_without_hole$CALCULE)]<-0
						data_without_hole$MESURE[is.na(data_without_hole$MESURE)]<-0
						data_without_hole$EXPERT[is.na(data_without_hole$EXPERT)]<-0
						data_without_hole$PONCTUEL[is.na(data_without_hole$PONCTUEL)]<-0
						if (bilanMigration@calcdata[[stringr::str_c("dc_",dc)]][["contient_poids"]]&
								taxon=="Anguilla anguilla"&
								(stade=="civelle"|stade=="Anguilla jaune")) {							
							#----------------------------------
							# bilan migration avec poids (civelles
							#-----------------------------------------
							grDevices::X11()
							fungraph_civelle(bilanMigration=bilanMigration,
									table=data_without_hole,
									time.sequence=bilanMigration@time.sequence,
									taxon=taxon,
									stade=stade,
									dc=dc,
									silent,
									...)
						}	else {
							
							#----------------------------------
							# bilan migration standard
							#-----------------------------------------
							grDevices::X11()
							#silent=TRUE
							fungraph(bilanMigration=bilanMigration,
									tableau=data_without_hole,
									time.sequence=bilanMigration@time.sequence,
									taxon,
									stade,
									dc,
									silent)
						}
					} # end nrow(data)>0	
					###########################################""
					# Writes the daily bilan in the database
					#########################################
					database_expected<-get("database_expected",envir=envir_stacomi)
					if (database_expected) fn_EcritBilanJournalier(bilanMigration,silent)
				} # end is.null(data)
				
				#§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
				#                 step plot
				#§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
			} else if (plot.type=="step"){
				taxon= as.character(bilanMigration@taxons@data$tax_nom_latin)
				stade= as.character(bilanMigration@stades@data$std_libelle)
				dc=as.numeric(bilanMigration@dc@dc_selectionne)	
				if (bilanMigration@pasDeTemps@stepDuration==86400 & bilanMigration@pasDeTemps@stepDuration==86400) {
					grdata<-bilanMigration@calcdata[[stringr::str_c("dc_",dc)]][["data"]]
					grdata<-funtraitementdate(grdata,
							nom_coldt="debut_pas",
							annee=FALSE,
							mois=TRUE,
							quinzaine=TRUE,
							semaine=TRUE,
							jour_an=TRUE,
							jour_mois=FALSE,
							heure=FALSE)
					grdata$Cumsum=cumsum(grdata$Effectif_total)
					# pour sauvegarder sous excel
					annee=unique(strftime(as.POSIXlt(bilanMigration@time.sequence),"%Y"))
					dis_commentaire=  as.character(bilanMigration@dc@data$dis_commentaires[bilanMigration@dc@data$dc%in%bilanMigration@dc@dc_selectionne]) 
					update_geom_defaults("step", aes(size = 3))
					
					p<-ggplot(grdata)+
							geom_step(aes(x=debut_pas,y=Cumsum,colour=mois))+
							ylab(get("msg",envir_stacomi)$BilanMigration.6)+
							ggtitle(paste(get("msg",envir_stacomi)$BilanMigration.7," ",dis_commentaire,", ",taxon,", ",stade,", ",annee,sep="")) + 
							theme(plot.title = element_text(size=10,colour="navy"))+
							scale_colour_manual(values=c("01"="#092360",
											"02"="#1369A2",
											"03"="#0099A9",
											"04"="#009780",
											"05"="#67B784",
											"06"="#CBDF7C",
											"07"="#FFE200",
											"08"="#DB9815",
											"09"="#E57B25",
											"10"="#F0522D",
											"11"="#912E0F",
											"12"="#33004B"
									))
					print(p)	
				} else {
					funout(get("msg",envir_stacomi)$BilanMigration.8)
				}
			} else {
				stop("unrecognised plot.type argument, plot.type should either be standard or step")
			}
		})




hbilanMigrationgraph = function(h,...) {
	if (exists("bilanMigration",envir_stacomi)) {
		bilanMigration<-get("bilanMigration",envir_stacomi)
	} else {      
		funout(get("msg",envir_stacomi)$BilanMigration.5,arret=TRUE)
	}
	
	plot(bilanMigration,plot.type="standard")
	# ecriture du bilan journalier, ecrit aussi le bilan mensuel
	fn_EcritBilanJournalier(bilanMigration)
	
}

#' handler for calcul hBilanMigrationgraph2
#' 
#' Step plot over time
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
hbilanMigrationgraph2 = function(h,...) {
	if (exists("bilanMigration",envir_stacomi)) {
		bilanMigration<-get("bilanMigration",envir_stacomi)
	} else {      
		funout(get("msg",envir_stacomi)$BilanMigration.5,arret=TRUE)
	}
	plot(bilanMigration,plot.type="step")
}

#' handler for summary function, internal use
#' calls functions funstat and funtable to build summary tables in html and
#' csv files
#' @param h Handler
#' @param ... Additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
hTableBilanMigration=function(h,...) {
	hTableBilanMigrationMult=function(h=null,...) {
		if (exists("bilanMigration",envir_stacomi)) 
		{
			bilanMigration<-get("bilanMigration",envir_stacomi)
		} 
		else 
		{      
			funout(get("msg",envir_stacomi)$BilanMigration.5,arret=TRUE)
		}
		summary(bilanMigration)
	}
}

#' summary for bilanMigration 
#' calls functions funstat and funtable to create migration overviews
#' and generate csv and html output in the user data directory
#' @param object An object of class \code{\link{BilanMigration-class}}
#' @param silent Should the program stay silent or display messages, default FALSE
#' @param ... Additional parameters (not used there)
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("summary",signature=signature(object="BilanMigration"),definition=function(object,silent=FALSE,...){
			bilanMigrationMult<-as(object,"BilanMigrationMult")
			summary(bilanMigrationMult,silent=silent)			
		})





#' handler hBilanMigrationwrite
#' Allows the saving of daily and monthly counts in the database, this method is also called from hbilanMigrationgraph
#' @param h a handler
#' @param ... Additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
hbilanMigrationwrite = function(h,...) {
	if (exists("bilanMigration",envir_stacomi)) {
		bilanMigration<-get("bilanMigration",envir_stacomi)
	} else {      
		funout(get("msg",envir_stacomi)$BilanMigration.5,arret=TRUE)
	}
	# ecriture du bilan journalier, ecrit aussi le bilan mensuel
	fn_EcritBilanJournalier(bilanMigration)
}