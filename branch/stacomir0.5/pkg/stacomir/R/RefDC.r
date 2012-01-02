# Nom fichier :        RefDC   (classe)

#' @title RefDC referential class 
#' @note Class to load DC
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @slot dc_selectionne="integer"
#' @slot ouvrage="integer"
#' @slot data="data.frame"
#' @example objet=new("RefDC")
setClass(Class="RefDC",representation=
				representation(dc_selectionne="integer",ouvrage="integer",data="data.frame") ,
		prototype=prototype(dc_selectionne=integer(),ouvrage=integer(),data=data.frame()),package="stacomi")


#' Referential class RefDC loads the counting devices of the control station
#' @returnType Object of class RefDC
#' @return Object of class RefDC
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
setMethod("charge",signature=signature("RefDC"),definition=function(objet) {
			requete=new("RequeteODBC")
			requete@baseODBC=baseODBC
			requete@sql=  paste("select dis_identifiant as DC,",
					" dis_date_creation,",
					" dis_date_suppression,",
					" dif_dis_identifiant as DF,",
					" dis_commentaires,",
					" dif_ouv_identifiant,",
					" ouv_libelle,",
					" dif_code as DF_code,",
					" dif_localisation,",
					" dif_orientation,",
					" tdf_libelle as type_DF,",
					" tdc_libelle as type_DC",
					" FROM ",sch,"tg_dispositif_dis",
					" JOIN ",sch,"t_dispositifcomptage_dic ON dic_dis_identifiant =dis_identifiant",
					" JOIN ",sch,"t_dispositiffranchissement_dif ON dif_dis_identifiant=dic_dif_identifiant",
					" JOIN ",sch,"tj_dfesttype_dft ON dif_dis_identifiant=dft_df_identifiant",
					" JOIN ",sch,"t_ouvrage_ouv on dif_ouv_identifiant=ouv_identifiant", 
					" JOIN ref.tr_typedf_tdf ON tdf_code=dft_tdf_code",
					" JOIN ref.tr_typedc_tdc ON dic_tdc_code=tdc_code",
					" WHERE  dft_rang=1",
					" ORDER BY dis_identifiant;",sep="")
			requete<-connect(requete) 
			#funout("La requete est effectuee pour charger les Dispositifs de comptage \n")
			objet@data<-requete@query
			return(objet)
		})
#' choice method for RefDC
#' @note la methode choix � pour arguments un objet Bilan car le RefDC est appelle depuis un objet Bilan(ex Bilan_lot) 
#' par defaut la valeur est nulle, mais si il existe la methode appelle le widget suivant (taxon) et le charge en fonction du choix fait pour RefDC
#' a l'aide de la methode charge_sans_fitre de l'objet RefStade_filtre qui herite de RefStades
#' @param objetBilan un objet bilan
#' @param is.enabled a boolean indincating # see if deprecated...
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @example
#' win=gwindow()
#' group=ggroup(container=win,horizontal=FALSE)
#'objet=new("RefDC")
#'objet<-charge(objet)
#'objetBilan=new("BilanMigration")
#' choix(objet=objet,objetBilan=objetBilan)
setMethod("choix",signature=signature("RefDC"),definition=function(objet,objetBilan=NULL,is.enabled=TRUE) {
			if (nrow(objet@data) > 0){
				hDC=function(h,...){
					objet@dc_selectionne<-svalue(choix)
					objet@ouvrage= objet@data$dif_ouv_identifiant[objet@data$dc%in%objet@dc_selectionne]
					assign("refDC",objet,envir_stacomi)
					funout(get("msg",envir=envir_stacomi)$RefDC.1)
					# si il existe un objet fils; supprimer
					# referentiel fils, celui charge par la methode charge_avec_filtre
					# ici comme on fait appel � un autre objet il faut appeller le conteneur qui contient l'objet
					if (!is.null(objetBilan)) {
						# ci dessous pas d'appel de charge_avec_filtre pour les bilanEspeces (tous les taxons)
						if("RefTaxon"%in%as.character(getSlots(class(objetBilan)))){
							objetBilan@taxons<<-charge_avec_filtre(objet=objetBilan@taxons,dc_selectionne=get("refDC",objet,envir_stacomi)@dc_selectionne)
							if (exists("frame_tax")) delete(group,frame_tax)
							if (exists("frame_std")) delete(group,frame_std)
							if (exists("frame_par")) delete(group,frame_par)
							if (exists("frame_parquan")) delete(group,frame_parquan)
							if (exists("frame_parqual")) delete(group,frame_parqual)
							choix(objetBilan@taxons,objetBilan,is.enabled=TRUE)
							funout(get("msg",envir=envir_stacomi)$RefDC.2)	
						}
					}
					#dispose(winst)
				} 
				# Handler d'affichage du tableau
				hDCi=function(h,...){
					w=gwindow(get("msg",envir=envir_stacomi)$RefDC.3,width=400)
					wg=ggroup(horizontal=FALSE,cont=w)
					tab=gtable(objet@data[,c(1,4,7,8,11,12)],chosencol=1,multiple=FALSE,expand=TRUE, container=wg)
					bg<-ggroup(cont=wg)
					addSpring(bg)
					gbutton(get("msg",envir=envir_stacomi)$RefDC.4, cont=bg, handler = function(h,...) dispose(w))
				}
				frame_DC<<-gframe(get("msg",envir=envir_stacomi)$RefDC.5)
				add(group,frame_DC)
				DC_identifiant=objet@data$dc
				choix=gdroplist(DC_identifiant,container=frame_DC,handler=hDC)
				gbutton(get("msg",envir=envir_stacomi)$RefDC.6, container=frame_DC,handler=hDCi) 
				enabled(frame_DC)<-is.enabled
				gbutton("OK", container=frame_DC,handler=hDC)
			} else {
				funout(get("msg",envir=envir_stacomi)$RefDC.7,arret=TRUE)
			}
		})
# pour test #choix(objet)

#' choice method for RefDC
#' @note la methode choix � pour arguments un objet Bilan car le RefDC est appelle depuis un objet Bilan(ex Bilan_lot) 
#' par defaut la valeur est nulle, mais si il existe la methode appelle le widget suivant (taxon) et le charge en fonction du choix fait pour RefDC
#' a l'aide de la methode charge_sans_fitre de l'objet RefStade_filtre qui herite de RefStades
#' @param objetBilan un objet bilan
#' @param is.enabled a boolean indincating # see if deprecated...
#' @author Cedric Briand \email{cedric.briand@@lavilaine.com}
#' @example
#' win=gwindow()
#' group=ggroup(container=win,horizontal=FALSE)
#'objet=new("RefDC")
#'objet<-charge(objet)
#'objetBilan=new("BilanMigration")
#' choixmult(objet=objet,objetBilan=objetBilan)
#' group = ggroup(horizontal=FALSE)  
#' assign("group",group,envir = .GlobalEnv)  
#' add(ggroupboutons,group)
setMethod("choixmult",signature=signature("RefDC"),definition=function(objet,objetBilan=NULL,is.enabled=TRUE) {
			if (nrow(objet@data) > 0){
				hDC=function(h,...){
					objet@dc_selectionne<-as.integer(tbdestdc[,][tbdestdc[,]!=""])
					objet@ouvrage= objet@data$dif_ouv_identifiant[objet@data$dc%in%objet@dc_selectionne]
					assign("refDC",objet,envir_stacomi)
					# TODO addmsg   "Le (s) DC (s) a (ont) ete selectionne(s) \n"
					funout(get("msg",envir=envir_stacomi)$RefDC.1)
					# si il existe un objet fils; supprimer
					# referentiel fils, celui charge par la methode charge_avec_filtre
					# ici comme on fait appel � un autre objet il faut appeller le conteneur qui contient l'objet
					if (!is.null(objetBilan)) {
						# ci dessous pas d'appel de charge_avec_filtre pour les bilanEspeces (tous les taxons)
						if("RefTaxon"%in%as.character(getSlots(class(objetBilan)))){
							objetBilan@taxons<<-charge_avec_filtre(objet=objetBilan@taxons,dc_selectionne=get("refDC",objet,envir_stacomi)@dc_selectionne)
							# suppresses all tab larger than 1 (dc)
							if (length(nb)>1){
								for (i in 2:length(nb)){
									svalue(nb) <- i							
									dispose(nb) ## dispose current tab
								}}
							choixmult(objetBilan@taxons,objetBilan,is.enabled=TRUE)
							funout(get("msg",envir=envir_stacomi)$RefDC.2)	
						}
					}
					# changing tab of nb to next tab
					if (svalue(nb)<length(nb)){
						svalue(nb)<-svalue(nb)+1	
					}
					#dispose(winst)
				} 
				# Handler d'affichage du tableau
				# below the widget structure [=> within (=> type
				# group(ggroup)[nb(notebook)[groupdc(ggroup&tab)[[frameDCsource(gframe)[tbsourcedc(gtable)],frameDCdest(gframe)[tbdcdest(gtable)]],OKbutton]]
				nb <<- gnotebook(container=group)				
				DC=objet@data[,c("dc","dis_commentaires","type_dc")]
				#TODO addmsg
				groupdc<<-ggroup(cont=nb, label="dc")   ## "add" called by constructor this is a tab of the notebook
				frameDCsource<-gframe(get("msg",envir=envir_stacomi)$RefDC.5,cont=groupdc)
				tbsourcedc  = gtable(DC,cont=frameDCsource)
				size(tbsourcedc)<-c(200,250)
				#TODO addmsg
				frameDCdest<-gframe("deposez ici",cont=groupdc)
				# need for a fixed size data.frame otherwise errors when adding new lines
				xx<-data.frame(choix=rep("",8))
				xx$choix<-as.character(xx$choix)
				tbdestdc=gtable(xx,cont=frameDCdest)
				adddropsource(tbsourcedc)
				adddroptarget(tbdestdc)				
				adddropmotion(tbdestdc,handler=function(h,...) {
							valeurs<-tbdestdc[,]
							valeurs<-valeurs[valeurs!=""]
							if (!svalue(tbsourcedc)%in%valeurs){
								tbdestdc[length(valeurs)+1,1]<-svalue(tbsourcedc)
							}
						})
				addHandlerDoubleclick(tbsourcedc,handler=function(h,...) {
							valeurs<-tbdestdc[,]
							valeurs<-valeurs[valeurs!=""]
							if (!svalue(tbsourcedc)%in%valeurs){
								tbdestdc[length(valeurs)+1,1]<-svalue(h$obj)
							}
						})
				adddropsource(tbdestdc)
				adddroptarget(tbsourcedc)
				removedc<-function(){
					valeurs<-tbdestdc[,]
					valeurs<-valeurs[valeurs!=""]
					valeurs<-valeurs[-match(svalue(tbdestdc),valeurs)]
					tbdestdc[,]<-c(valeurs,rep("",8-length(valeurs)))
				}
				adddropmotion(tbsourcedc,handler=function(h,...) {
							removedc()
						})
				addHandlerDoubleclick(tbdestdc,handler=function(h,...) {
							removedc()
						})
				gbutton("ok", cont = groupdc, handler = hDC)
			} else {
				funout(get("msg",envir=envir_stacomi)$RefDC.7,arret=TRUE)
			}
		})