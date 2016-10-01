#' Class "BilanFonctionnementDF" Report fishway work
#' 
#' The DF (Dispositif de Franchissement) is a fishway. It may be automated and
#' be operated only during certain periods. This report allows to see the detail of its work.
#' In the database four types of operation are set,  "1"=normal operation,
#' "2"=Device stopped in nomral operation (ie lift ascending, high tide...),
#' "3"="Stopped for maintenance or other problem",
#' "4"="Works but not fully operational, ie flow problem, flood, clogged with debris...",
#' "5"="Not known")
#' 
#' @include RefDF.r
#' @section Objects from the Class: Objects can be created by calls of the form
#' \code{new("BilanFonctionnementDF")}.
#' @slot data A data frame 
#' @slot df An object of class \code{RefDF-class}
#' @slot horodatedebut An object of class \code{RefHorodate-class}
#' @slot horodatefin An object of class \code{RefHorodate-class}
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @seealso Other Bilan Class \code{\linkS4class{Bilan_carlot}}
#' \code{\linkS4class{Bilan_poids_moyen}}
#' \code{\linkS4class{Bilan_stades_pigm}} 
#' \code{\linkS4class{Bilan_taille}}
#' \code{\linkS4class{BilanConditionEnv}} 
#' \code{\linkS4class{BilanEspeces}}
#' \code{\linkS4class{BilanFonctionnementDC}}
#' \code{\linkS4class{BilanFonctionnementDF}}
#' \code{\linkS4class{BilanMigration}}
#' \code{\linkS4class{BilanMigrationConditionEnv}}
#' \code{\linkS4class{BilanMigrationInterAnnuelle}}
#' \code{\linkS4class{BilanMigrationPar}}
#' @concept Bilan Object 
#' @example inst/examples/bilanFonctionnementDF_example.R
#' @export 
setClass(Class="BilanFonctionnementDF",
		representation= representation(data="data.frame",
				df="RefDF",
				horodatedebut="RefHorodate",
				horodatefin="RefHorodate"
				),
		prototype=prototype(data=data.frame(),df=new("RefDF"),
				horodatedebut=new("RefHorodate"),
				horodatefin=new("RefHorodate")				
		)
)


#' connect method for BilanFonctionnementDF
#' 
#' @param object An object of class \link{BilanFonctionnementDF-class}
#' loads the working periods and type of arrest or disfunction of the DF
#' @param silent Boolean, TRUE removes messages.
#' @return  An object of class \code{BilanFonctionnementDF}
#' 
#' @author cedric.briand
setMethod("connect",signature=signature("BilanFonctionnementDF"),definition=function(object,silent=FALSE) {
#  construit une requete ODBCwheredate
			req<-new("RequeteODBCwheredate")
			req@baseODBC<-get("baseODBC",envir=envir_stacomi)
			req@select= paste("SELECT",
					" per_dis_identifiant,",
					" per_date_debut,",
					" per_date_fin,",
					" per_commentaires,",
					" per_etat_fonctionnement,",
					" per_tar_code,",
					" tar_libelle AS libelle",
					" FROM  ",get("sch",envir=envir_stacomi),"t_periodefonctdispositif_per per",
					" INNER JOIN ref.tr_typearretdisp_tar tar ON tar.tar_code=per.per_tar_code",sep="")
			req@colonnedebut="per_date_debut"
			req@colonnefin="per_date_fin"
			req@order_by="ORDER BY per_date_debut"
			req@datedebut<-object@horodatedebut@horodate
			req@datefin<-object@horodatefin@horodate
			req@and=paste("AND per_dis_identifiant in",vector_to_listsql(object@df@df_selectionne))
#req@where=#defini dans la methode ODBCwheredate
			req<-stacomirtools::connect(req) # appel de la methode connect de l'object ODBCWHEREDATE
			object@data<-req@query
			if (!silent) funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.1)
			return(object)
		})


#' charge method for BilanFonctionnementDF
#' 
#' 
#' used by the graphical interface to retrieve the objects of Referential classes
#' assigned to envir_stacomi
#' @note Fishways (DF) are of various nature, from very simple eel ladders fed by water discharged from the river,
#' to more complex fishways with levels adjusted by the opening of various gates and regulators. 
#' The objective of this class is to provide an assessment of the working status of a fishway throughout the year.
#' A number of fishes ascending a fishway has meaning only if we know that the fishway is operational, and that the counting 
#' orerated on the fishway has remained operational.
#' In the database the operation of the fishway (DF) and counting device (DC) is agregated in one table (t_periodefonctdispositif_per).
#' The column  per_etat_fonctionnement indicates whether the fishway is operational (with a boolean) and the column per_tar_code indicates
#' the status of either the fishway or DC. 
#' @param object An object of class \link{BilanFonctionnementDF-class}
#' @param silent Keeps program silent
#' @return  An object of class \link{BilanFonctionnementDF-class}
#' 
#' @author cedric.briand
setMethod("charge",signature=signature("BilanFonctionnementDF"),definition=function(object,silent=FALSE) {
			# object<-BfDF
			if (exists("refDF",envir=envir_stacomi)) {
				object@df<-get("refDF",envir=envir_stacomi)
			} else {
				funout(get("msg",envir=envir_stacomi)$ref.12,arret=TRUE)
			}     
			
			if (exists("bilanFonctionnementDF_date_debut",envir=envir_stacomi)) {
				object@horodatedebut@horodate<-get("bilanFonctionnementDF_date_debut",envir=envir_stacomi)
			} else {
				funout(get("msg",envir=envir_stacomi)$ref.5,arret=TRUE)
			}
			
			if (exists("bilanFonctionnementDF_date_fin",envir=envir_stacomi)) {
				object@horodatefin@horodate<-get("bilanFonctionnementDF_date_fin",envir=envir_stacomi)
			} else {
				funout(get("msg",envir=envir_stacomi)$ref.6,arret=TRUE)
			}			
			assign("bilanFonctionnementDF",object,envir=envir_stacomi)  
			return(object)
		})

#' command line interface for BilanFonctionnementDF class
#' 
#' The choice_c method fills in the data slot for RefDC, and then 
#' uses the choice_c methods of these object to "select" the data.
#' @param object An object of class \link{RefDC-class}
#' @param df The df to set
#' @param horodatedebut A POSIXt or Date or character to fix the date of beginning of the Bilan
#' @param horodatefin A POSIXt or Date or character to fix the last date of the Bilan
#' @param silent Should program be silent or display messages
#' @return An object of class \link{RefDC-class} with slots filled
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("choice_c",signature=signature("BilanFonctionnementDF"),definition=function(object,df,horodatedebut,horodatefin,silent=FALSE){
			# bilanFonctionnementDF<-bfDF;df=2;horodatedebut="2013-01-01";horodatefin="2013-12-31";silent=TRUE
			bilanFonctionnementDF<-object
			assign("bilanFonctionnementDF",bilanFonctionnementDF,envir=envir_stacomi)    
			if (!silent) funout(get("msg",envir=envir_stacomi)$interface_BilanFonctionnementDC.1)
			bilanFonctionnementDF@df<-charge(bilanFonctionnementDF@df)    
			bilanFonctionnementDF@df<-choice_c(bilanFonctionnementDF@df,df)
			# assigns the parameter (horodatedebut) of the method to the object using choice_c method for RefDC
			bilanFonctionnementDF@horodatedebut<-choice_c(object=bilanFonctionnementDF@horodatedebut,
					nomassign="bilanFonctionnementDF_date_debut",
					funoutlabel=get("msg",envir=envir_stacomi)$interface_Bilan_lot.5,
					horodate=horodatedebut, silent=silent)
			bilanFonctionnementDF@horodatefin<-choice_c(bilanFonctionnementDF@horodatefin,
					nomassign="bilanFonctionnementDF_date_fin",
					funoutlabel=get("msg",envir=envir_stacomi)$interface_Bilan_lot.6,
					horodate=horodatefin,silent=silent)
			assign("bilanFonctionnementDF",bilanFonctionnementDF,envir=envir_stacomi)  
			return(bilanFonctionnementDF)
		})

#' Different plots for BilanFonctionnementDF
#' 
#' \itemize{
#'      \item{plot.type=1}{A barplot of the operation time per month}
#' 		\item{plot.type=2}{Barchat giving the time per type of operation }
#' 		\item{plot.type=2}{Rectangle plots drawn along a line}
#'      \item{plot.type=4}{Plots per day drawn over the period to show the operation of a df, days in x, hours in y} 
#' 	}	
#' 
#' @note The program cuts periods which overlap between two month. The splitting of different periods into month is 
#' assigned to the \code{envir_stacomi} environment
#' @param x An object of class \link{BilanFonctionnementDF-class}
#' @param y From the formals but missing
#' @param plot.type One of \code{barchart},\code{box}. Defaut to \code{barchart} showing a summary of the df operation per month, can also be \code{box}, 
#' a plot with adjacent rectangles.
#' @param silent Stops displaying the messages.
#' @param title The title of the graph, if NULL a default title will be plotted with the number of the DF
#' @return Nothing but prints the different plots
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("plot",signature(x = "BilanFonctionnementDF", y = "ANY"),definition=function(x, y,plot.type=1,silent=FALSE,title=NULL){ 
			#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			#           PLOT OF TYPE BARCHART (plot.type=1 (true/false) or plot.type=2)
			#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			#bilanFonctionnementDF<-bfDF; require(RGtk2); require(lubridate);require(ggplot2);title=NULL;silent=FALSE;plot.type="1"
			bilanFonctionnementDF<-x
			plot.type<-as.character(plot.type)# to pass also characters
			if (!plot.type%in%c("1","2","3","4")) stop('plot.type must be 1,2,3 or 4')
			if (plot.type=="1"|plot.type=="2"){
				if (!silent) funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.3)
				t_periodefonctdispositif_per=bilanFonctionnementDF@data # on recupere le data.frame   
				# l'objectif du programme ci dessous est de calculer la time.sequence mensuelle de fonctionnement du dispositif.
				tempsdebut<-t_periodefonctdispositif_per$per_date_debut
				tempsfin<-t_periodefonctdispositif_per$per_date_fin
				# test la premiere horodate peut etre avant le choix de temps de debut, remplacer cette date par requete@datedebut
				tempsdebut[tempsdebut<bilanFonctionnementDF@horodatedebut@horodate]<-bilanFonctionnementDF@horodatedebut@horodate
				# id pour fin
				tempsfin[tempsfin>bilanFonctionnementDF@horodatefin@horodate]<-bilanFonctionnementDF@horodatefin@horodate
				t_periodefonctdispositif_per=cbind(t_periodefonctdispositif_per,tempsdebut,tempsfin)
				seqmois=seq(from=tempsdebut[1],to=tempsfin[nrow(t_periodefonctdispositif_per)],by="month",tz = "GMT")
				seqmois=as.POSIXlt(round_date(seqmois,unit="month"))
				# adding one month at the end to get a complete coverage of the final month
				seqmois<-c(seqmois,
						seqmois[length(seqmois)]%m+%months(1))
				
				#seqmois<-c(seqmois,seqmois[length(seqmois)]+months(1))
				t_periodefonctdispositif_per_mois=t_periodefonctdispositif_per[1,]
				############################
				#progress bar
				###########################
				mygtkProgressBar(
						title=get("msg",envir=envir_stacomi)$BilanFonctionnementDF.4,
						progress_text=get("msg",envir=envir_stacomi)$BilanFonctionnementDF.5)
				# this function assigns
				z=0 # compteur tableau t_periodefonctdispositif_per_mois
				for(j in 1:nrow(t_periodefonctdispositif_per)){
					#cat( j 
					progress_bar$setFraction(j/nrow(t_periodefonctdispositif_per)) 
					progress_bar$setText(sprintf("%d%% progression",round(100*j/nrow(t_periodefonctdispositif_per))))
					RGtk2::gtkMainIterationDo(FALSE)
					if (j>1) t_periodefonctdispositif_per_mois=rbind(t_periodefonctdispositif_per_mois, t_periodefonctdispositif_per[j,])
					lemoissuivant=seqmois[seqmois>tempsdebut[j]][1] # le premier mois superieur a tempsdebut
					while (tempsfin[j]>lemoissuivant){    # on est a cheval sur deux periodes    
						
						#if (z>0) stop("erreur")
						z=z+1
						t_periodefonctdispositif_per_mois=rbind(t_periodefonctdispositif_per_mois, t_periodefonctdispositif_per[j,])
						t_periodefonctdispositif_per_mois[j+z,"tempsdebut"]=as.POSIXct(lemoissuivant)
						t_periodefonctdispositif_per_mois[j+z-1,"tempsfin"]=as.POSIXct(lemoissuivant)
						lemoissuivant=seqmois[match(as.character(lemoissuivant),as.character(seqmois))+1] # on decale de 1 mois avant de rerentrer dans la boucle
						#if (is.na(lemoissuivant) ) break
					}  
					#if (is.na(lemoissuivant)) break
				}
				t_periodefonctdispositif_per_mois$sumduree<-as.numeric(difftime(t_periodefonctdispositif_per_mois$tempsfin, t_periodefonctdispositif_per_mois$tempsdebut,units = "hours"))
				t_periodefonctdispositif_per_mois$mois1= strftime(as.POSIXlt(t_periodefonctdispositif_per_mois$tempsdebut),"%b")
				t_periodefonctdispositif_per_mois$mois=strftime(as.POSIXlt(t_periodefonctdispositif_per_mois$tempsdebut),"%m")
				t_periodefonctdispositif_per_mois$annee=strftime(as.POSIXlt(t_periodefonctdispositif_per_mois$tempsdebut),"%Y")
				progress_bar$setText("All done.")
				progress_bar$setFraction(1) 
				if (is.null(title)) title<-paste(get("msg",envir_stacomi)$BilanFonctionnementDF.7,bilanFonctionnementDF@df@df_selectionne)
				# graphic
				t_periodefonctdispositif_per_mois<-stacomirtools::chnames(t_periodefonctdispositif_per_mois, 
						old_variable_name=c("sumduree","per_tar_code","per_etat_fonctionnement"),
						new_variable_name=get("msg",envir_stacomi)$BilanFonctionnementDF.6)
				#modification of the order
				
				t_periodefonctdispositif_per_mois=t_periodefonctdispositif_per_mois[order(t_periodefonctdispositif_per_mois$type_fonct., decreasing = TRUE),]
				g<- ggplot(t_periodefonctdispositif_per_mois,
								aes(x=mois,y=duree,fill=libelle))+
						facet_grid(annee~.)+
						ggtitle(title)+
						geom_bar(stat='identity')+
						scale_fill_manual(values = c("#E41A1C","#E6AB02", "#9E0142","#1B9E77","#999999"))
				
				t_periodefonctdispositif_per_mois=t_periodefonctdispositif_per_mois[order(t_periodefonctdispositif_per_mois$fonctionnement),]
				t_periodefonctdispositif_per_mois$fonctionnement=as.factor(	t_periodefonctdispositif_per_mois$fonctionnement)
				g1<- ggplot(t_periodefonctdispositif_per_mois,aes(x=mois,y=duree))+facet_grid(annee~.)+
						ggtitle(title)+
						geom_bar(stat='identity',aes(fill=fonctionnement))+
						scale_fill_manual(values = c("#E41A1C","#4DAF4A")) 
				
				if (plot.type=="1")
					print(g)
				if (plot.type=="2")
					print(g1)		
				assign("periodeDF",t_periodefonctdispositif_per_mois,envir_stacomi)
				if (!silent) funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.8)
				# the progress bar has been assigned in envir_stacomi, we destroy it
				gtkWidgetDestroy(get("progres",envir=envir_stacomi))
				#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				#           PLOT OF TYPE BOX (plot.type=3)
				#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			} else if (plot.type=="3"){
				#bilanFonctionnementDF<-bfDF; require(RGtk2); require(lubridate);require(ggplot2);title=NULL;silent=FALSE;plot.type="3"
				if (!silent) funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.3)	
				t_periodefonctdispositif_per=bilanFonctionnementDF@data
				graphdate<-function(vectordate){
					vectordate<-as.POSIXct(vectordate)
					attributes(vectordate)<-NULL
					unclass(vectordate)
					return(vectordate)
				}
				time.sequence=seq.POSIXt(from=bilanFonctionnementDF@horodatedebut@horodate,to=bilanFonctionnementDF@horodatefin@horodate,by="day")
				debut=graphdate(time.sequence[1])
				fin=graphdate(time.sequence[length(time.sequence)])
				mypalette<-RColorBrewer::brewer.pal(12,"Paired")
				#display.brewer.all()
				mypalette1<-c("#1B9E77","#AE017E","orange", RColorBrewer::brewer.pal(12,"Paired"))
				# creation d'un graphique vide
				if (is.null(title)) title<-""
				plot(graphdate(time.sequence),
						seq(0,1,length.out=length(time.sequence)),
						xlim=c(debut,fin), 
						type= "n", 
						xlab="",
						xaxt="n",
						yaxt="n", 
						ylab=get("msg",envir=envir_stacomi)$BilanFonctionnementDF.9,
						main=title,
						#bty="n",
						cex=0.8)
				r <- round(range(time.sequence), "day")
				graphics::axis(1, at=graphdate(seq(r[1], r[2], by="weeks")),labels=strftime(as.POSIXlt(seq(r[1], r[2], by="weeks")),format="%d-%b"))
				if (dim(t_periodefonctdispositif_per)[1]==0 ) {
					rect(      xleft=debut, 
							ybottom=0.6,
							xright=fin,
							ytop=0.9, 
							col = mypalette[4],
							border = NA, 
							lwd = 1)                     
					rect(      xleft=debut, 
							ybottom=0.1,
							xright=fin,
							ytop=0.4, 
							col = mypalette[1],
							border = NA, 
							lwd = 1)
					legend(  x= "bottom",
							legend= get("msg",envir=envir_stacomi)$BilanFonctionnementDC.10,
							pch=c(16,16),
							col=c(mypalette[4],mypalette[6],mypalette[1]),
							#horiz=TRUE,
							ncol=5,
							bty="n")
				} else {
					
					if (sum(t_periodefonctdispositif_per$per_etat_fonctionnement==1)>0){ 
						rect(   xleft =graphdate(t_periodefonctdispositif_per$per_date_debut[t_periodefonctdispositif_per$per_etat_fonctionnement==1]), 
								ybottom=0.6,
								xright=graphdate(t_periodefonctdispositif_per$per_date_fin[t_periodefonctdispositif_per$per_etat_fonctionnement==1]),
								ytop=0.9, 
								col = mypalette[4],
								border = NA, 
								lwd = 1) }
					if (sum(t_periodefonctdispositif_per$per_etat_fonctionnement==0)>0)                           { 
						rect(   xleft =graphdate(t_periodefonctdispositif_per$per_date_debut[t_periodefonctdispositif_per$per_etat_fonctionnement==0]), 
								ybottom=0.6,
								xright=graphdate(t_periodefonctdispositif_per$per_date_fin[t_periodefonctdispositif_per$per_etat_fonctionnement==0]),
								ytop=0.9, 
								col = mypalette[6],
								border = NA, 
								lwd = 1) }
					listeperiode<-
							fn_table_per_dis(typeperiode=t_periodefonctdispositif_per$per_tar_code,
									tempsdebut= t_periodefonctdispositif_per$per_date_debut,
									tempsfin=t_periodefonctdispositif_per$per_date_fin,
									libelle=t_periodefonctdispositif_per$libelle,
									date=FALSE)
					nomperiode<-vector()
					
					for (j in 1 : length(listeperiode)){
						nomperiode[j]<-substr(listeperiode[[j]]$nom,1,17)   
						rect(   xleft=graphdate(listeperiode[[j]]$debut), 
								ybottom=0.1,
								xright=graphdate(listeperiode[[j]]$fin),
								ytop=0.4, 
								col = mypalette1[j],
								border = NA, 
								lwd = 1)        
					}
					legend  (x= debut,
							y=0.6,
							legend= get("msg",envir=envir_stacomi)$BilanFonctionnementDC.11,
							pch=c(15,15),
							col=c(mypalette[4],mypalette[6]),
							bty="n",
							horiz=TRUE,
							text.width=(fin-debut)/6 ,
							cex=0.8
					)                                               
					legend  (x= debut,
							y=0.1,
							legend= c(nomperiode),
							pch=c(15,15),
							col=c(mypalette1[1:length(listeperiode)]),
							bty="n",
							horiz=TRUE,
							text.width=(fin-debut)/8,
							cex=0.7
					)
					text(x=debut,y=0.95, label=get("msg",envir=envir_stacomi)$BilanFonctionnementDF.7,font=4,pos=4) 
					text(x=debut,y=0.45, label=get("msg",envir=envir_stacomi)$BilanFonctionnementDF.10, font=4,pos=4)
				}
				#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				#           PLOT OF TYPE BOX (plot.type=4)
				#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			} else if (plot.type=="4"){
				if (is.null(title)) title<-paste(get("msg",envir_stacomi)$BilanFonctionnementDF.7,bilanFonctionnementDF@df@df_selectionne)
				
				#bilanFonctionnementDF<-bfDF; require(RGtk2); require(lubridate);require(ggplot2);title=NULL;silent=FALSE;plot.type="4"
				t_periodefonctdispositif_per=bilanFonctionnementDF@data
				tpp<-split_per_day(t_periodefonctdispositif_per,horodatedebut="per_date_debut",horodatefin="per_date_fin")
				
				g<-ggplot(tpp)+
						geom_rect(aes(xmin=xmin,xmax=xmax,ymin=Hdeb,ymax=Hfin,col=factor(per_tar_code),fill=factor(per_tar_code)),alpha=0.5)+
						scale_fill_manual("type",values=c("1"="#40CA2C","2"="#C8B22D","3"="#AB3B26","4"="#B46BED","5"="#B8B8B8"),
										labels = get("msg",envir=envir_stacomi)$BilanFonctionnementDF.11)+
					   scale_colour_manual("type",values=c("1"="#40CA2C","2"="#C8B22D","3"="#AB3B26","4"="#B46BED","5"="#B8B8B8"),
										labels = get("msg",envir=envir_stacomi)$BilanFonctionnementDF.11)+		
						ylab("Heure")+theme(
								plot.background = element_rect(fill ="black"),
								panel.background = element_rect(fill="black"),
								legend.background=element_rect(fill="black"),
								panel.grid.major = element_blank(), 
								panel.grid.minor = element_blank(),
								text=element_text(colour="white"),								
								line = element_line(colour = "grey50"),
								legend.key=element_rect(fill="black",colour="black"),
								axis.text=element_text(colour="white")
								)
								
				print(g)
				
			}
			return(invisible(NULL))
		})


#' Handler for barchart for BilanFonctionnementDF class from the graphical interface
#' 
#' @note The program cuts periods which overlap between two month
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
funbarchartDF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi)  
	bilanFonctionnementDF=charge(bilanFonctionnementDF)	
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	if( nrow(bilanFonctionnementDF@data)==0 ) {
		funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.2, arret=TRUE)
	}		
	plot(bilanFonctionnementDF,plot.type=1,silent=FALSE)
}   


#' Handler for barchart for BilanFonctionnementDF class from the graphical interface
#' 
#' @note The program cuts periods which overlap between two month
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
funbarchart1DF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi)  
	bilanFonctionnementDF=charge(bilanFonctionnementDF)	
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	if( nrow(bilanFonctionnementDF@data)==0 ) {
		funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.2, arret=TRUE)
	}		
	plot(bilanFonctionnementDF,plot.type=2,silent=FALSE)
}   
#' Internal use, rectangles to describe the DF work for BilanFonctionnementDF class, 
#' graphical interface handler
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
funboxDF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi) 
	bilanFonctionnementDF=charge(bilanFonctionnementDF)
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	
	if( nrow(bilanFonctionnementDF@data)==0 ) {
		funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.2, arret=TRUE)
	}
	plot(bilanFonctionnementDF,plot.type=3,silent=FALSE)
	
}   

#' Handler fonction to plot calendar like graph, internal use
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
funchartDF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi) 
	bilanFonctionnementDF=charge(bilanFonctionnementDF)
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	
	if( nrow(bilanFonctionnementDF@data)==0 ) {
		funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.2, arret=TRUE)
	}
	plot(bilanFonctionnementDF,plot.type=4,silent=FALSE)
	
}   

#' Table output for BilanFonctionnementDF class
#' @param h handler
#' @param ... additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
funtableDF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi) 
	bilanFonctionnementDF=charge(bilanFonctionnementDF)
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	
	if( nrow(bilanFonctionnementDF@data)==0 ) {
		funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.2, arret=TRUE)
	}
	summary(bilanFonctionnementDF)
}

#' handler to print the command line
#' @param h a handler
#' @param ... Additional parameters
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
houtDF = function(h,...) {
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi) 
	bilanFonctionnementDF<-charge(bilanFonctionnementDF)
	bilanFonctionnementDF<-connect(bilanFonctionnementDF)
	#the charge method will check that all objects necessary to build the formula
	# are in envir_stacomi
	print(bilanFonctionnementDF)
	
}   

#' Method to print the command line of the object
#' @param x An object of class BilanFonctionnementDF
#' @param ... Additional parameters passed to print
#' @return NULL
#' @author cedric.briand
#' @export
setMethod("print",signature=signature("BilanFonctionnementDF"),definition=function(x,...){ 
			
			sortie1<-"bilanFonctionnementDF=new('BilanFonctionnementDF')\n"
			sortie2<-stringr::str_c("bilanFonctionnementDF=choice_c(bilanFonctionnementDF,",
					"df=",x@df@df_selectionne,",",
					"horodatedebut=",shQuote(as.character(x@horodatedebut@horodate)),",",
					"horodatefin=",shQuote(as.character(x@horodatefin@horodate)),")")
			# removing backslashes
			funout(stringr::str_c(sortie1,sortie2),...)
			return(invisible(NULL))
		})


#' summary for BilanFonctionnementDF, write csv and html output, and prints summary statistics
#' @param object An object of class \code{\link{BilanFonctionnementDF-class}}
#' @param silent Should the program stay silent or display messages, default FALSE
#' @param ... Additional parameters (not used there)
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("summary",signature=signature(object="BilanFonctionnementDF"),definition=function(object,silent=FALSE,...){
			#bilanFonctionnementDF<-bfDF;
			t_periodefonctdispositif_per=bilanFonctionnementDF@data # on recupere le data.frame
			t_periodefonctdispositif_per$per_date_debut=as.character(t_periodefonctdispositif_per$per_date_debut)
			t_periodefonctdispositif_per$per_date_fin=as.character(t_periodefonctdispositif_per$per_date_fin)
			#gdf(t_periodefonctdispositif_per, container=TRUE)
			annee=paste(unique(strftime(as.POSIXlt(t_periodefonctdispositif_per$per_date_debut),"%Y")),collapse="+")
			path1=file.path(path.expand(get("datawd",envir=envir_stacomi)),paste("t_periodefonctdispositif_per_DF_",bilanFonctionnementDF@df@df_selectionne,"_",annee,".csv",sep=""),fsep ="\\")
			write.table(t_periodefonctdispositif_per,file=path1,row.names=FALSE,col.names=TRUE,sep=";")
			if(!silent) funout(paste(get("msg",envir=envir_stacomi)$FonctionnementDC.14,path1,"\n"))
			path1html=file.path(path.expand(get("datawd",envir=envir_stacomi)),paste("t_periodefonctdispositif_per_DF_",bilanFonctionnementDF@df@df_selectionne,"_",annee,".html",sep=""),fsep ="\\")
			if(!silent) funout(paste(get("msg",envir=envir_stacomi)$FonctionnementDC.14,path1html,get("msg",envir=envir_stacomi)$BilanFonctionnementDF.15))
			funhtml(t_periodefonctdispositif_per,
					caption=paste("t_periodefonctdispositif_per_DF_",bilanFonctionnementDF@df@df_selectionne,"_",annee,sep=""),
					top=TRUE,
					outfile=path1html,
					clipboard=FALSE,
					append=FALSE,
					digits=2
			)
			t_periodefonctdispositif_per=bilanFonctionnementDF@data
			print(paste("summary statistics for DF=",bilanFonctionnementDF@df@df_selectionne))
			print(paste("df_code=",bilanFonctionnementDF@df@data[bilanFonctionnementDF@df@data$df==bilanFonctionnementDF@df@df_selectionne,"df_code"]))
			duree<-difftime(t_periodefonctdispositif_per$per_date_fin,t_periodefonctdispositif_per$per_date_debut,units="day")
			sommes<-tapply(duree,t_periodefonctdispositif_per$per_tar_code,sum)
			perc<-round(100*sommes/as.numeric(sum(duree)))
			sommes<-round(sommes,2)
			funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.12)
			funout(paste(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.11,
							" :",
							sommes,"(",perc,"%)",sep=""))
			sommes<-tapply(duree,t_periodefonctdispositif_per$per_etat_fonctionnement,sum)
			perc<-round(100*sommes/as.numeric(sum(duree)))
			sommes<-round(sommes,2)
			funout(get("msg",envir=envir_stacomi)$BilanFonctionnementDF.13)
			funout(paste(rev(get("msg",envir=envir_stacomi)$BilanFonctionnementDC.11),
							" :",
							sommes,"(",perc,"%)",sep=""))
			
		})		
