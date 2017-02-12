
#' Class "Bilan_poids_moyen"
#' 
#' Bilan_poids_moyen class The objective is to calculate mean weight of glass
#' eel which are counted from weight measurements and to reintegrate weight to
#' number coefficients
#' @include RefCoe.r
#' @note We have also tools available to import glass eel measurement from
#' experimental fishing in the estuary For the charge method dates for the
#' request are from august to august (a glass eel season)
#' @slot data A \code{"data.frame"} data for bilan lot
#' @slot calcdata  A list containing two processed data frames, data and coe
#' @slot dc Object of class \code{\link{RefDC-class}}, the counting device
#' @slot anneedebut Object of class \code{\link{RefAnnee-class}}. RefAnnee allows to choose the year of beginning
#' @slot anneefin Object of class \code{\link{RefAnnee-class}}
#' refAnnee allows to choose last year of the Bilan
#' @slot coe Object of class \code{\link{RefCoe-class}} class loading coefficient
#' of conversion between quantity (weights or volumes of glass eel) and numbers
#' @slot liste Object of class \code{\link{RefListe-class}} RefListe referential
#' class choose within a list, here the choice is wether subsamples or not. Subsamples
#' in the stacomi database are samples with a non null value for parent sample. Migration
#' counts are never made on subsamples but those can be integrated to calculate mean weights.
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @family Bilan Objects
#' @keywords classes
#' @example inst/examples/bilan_poids_moyen_example.R
#' @export 
setClass(Class="Bilan_poids_moyen",        
		representation= representation(data="data.frame",
				calcdata="list",
				dc="RefDC",
				anneedebut="RefAnnee",
				anneefin="RefAnnee",
				coe="RefCoe",
				liste="RefListe"),
		prototype=prototype(data=data.frame(),
				calcdata=list(),
				dc=new("RefDC"),
				anneedebut=new("RefAnnee"),
				anneefin=new("RefAnnee"),
				coe=new("RefCoe"),
				liste=new("RefListe")))

#' connect method for Bilan_Poids_moyen
#' @param object An object of class \link{Bilan_poids_moyen-class}
#' @return Bilan_Poids_Moyen request corresponding to user choices, mean weight
#'  w is calculated as car_valeur_quantitatif/lot_effectif. These coefficients are stored in the database,
#' and the connect method loads them from the table using the \link{RefCoe-class}
#' @note dates for the request are from august to august (a glass eel season)
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export

setMethod("connect",signature=signature("Bilan_poids_moyen"),definition=function(object) {
			#object<-bilPM
			# loading mean weights
			requete=new("RequeteODBCwheredate")
			requete@baseODBC=get("baseODBC",envir=envir_stacomi)
			requete@datedebut=strptime(paste(object@anneedebut@annee_selectionnee-1,"-08-01",sep=""),format="%Y-%m-%d")
			requete@datefin=strptime(paste(object@anneefin@annee_selectionnee,"-08-01",sep=""),format="%Y-%m-%d")
			requete@colonnedebut="ope_date_debut"
			requete@colonnefin="ope_date_fin"
			requete@select= paste("SELECT lot_identifiant,ope_date_debut,ope_date_fin,lot_effectif,car_valeur_quantitatif as poids,",
					" (car_valeur_quantitatif/lot_effectif) AS w,",
					" (ope_date_fin-ope_date_debut)/2 AS duree,",
					" ope_date_debut+(ope_date_fin-ope_date_debut)/2 as datemoy,",
					" date_part('year', ope_date_debut) as annee,",
					" date_part('month',ope_date_debut) as mois",
					" FROM ",get("sch",envir=envir_stacomi),"vue_lot_ope_car_qan",sep="")
			requete@and=paste(" AND ope_dic_identifiant=",object@dc@dc_selectionne,
					" AND std_libelle='civelle'",
					ifelse(object@liste@selectedvalue=="tous", "",paste(" AND  lot_effectif", object@liste@selectedvalue)),
					" AND upper(car_methode_obtention::text) = 'MESURE'::text",
					" AND car_par_code='A111'",sep="")
			requete<-stacomirtools::connect(requete)			
			object@data<-requete@query			
			#loading conversion coefficients
			object@coe@datedebut=requete@datedebut
			object@coe@datefin=requete@datefin
			object@coe<-charge(object@coe)
			funout(gettext("The query to load the coefficients of conversion is finished\n",domain="R-stacomiR"))
			funout(gettextf("%1.0f lines found for the conversion coefficients\n",nrow(object@coe),domain="R-stacomiR"))	
			assign(x="bilan_poids_moyen",value=object,envir=envir_stacomi)
			return(object)
		})


#' charge method for Bilan_poids_moyen class
#' @param object An object of class \link{Bilan_poids_moyen-class}
#' @return Bilan_poids_moyen with slots filled with user choice
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("charge",signature=signature("Bilan_poids_moyen"),definition=function(object) {
			if (exists("refliste",envir_stacomi)) {      
				object@liste<-get("refliste",envir_stacomi)      
			} else {      
				funout(gettext("You need to choose a size class\n",domain="R-stacomiR"),arret=TRUE)             
			} 
			if (exists("refDC",envir_stacomi)) {      
				object@dc<-get("refDC",envir_stacomi)      
			} else {      
				funout(gettext("You need to choose a counting device, clic on validate\n",domain="R-stacomiR"),arret=TRUE)          
			}            
			if (exists("refAnneeDebut",envir_stacomi)) {      
				object@anneedebut<-get("refAnneeDebut",envir_stacomi)      
			} else {      
				funout(gettext("You need to choose the starting year\n",domain="R-stacomiR"),arret=TRUE)             
			}
			if (exists("refAnneeFin",envir_stacomi)) {      
				object@anneefin<-get("refAnneeFin",envir_stacomi)      
			} else {      
				funout(gettext("You need to choose the ending year\n",domain="R-stacomiR"),arret=TRUE)       
			}                    
			assign("bilan_poids_moyen",object,envir=envir_stacomi)
			return(object) 
		})



#' command line interface for \link{Bilan_poids_moyen-class}
#' @param object An object of class \link{Bilan_poids_moyen-class}
#' @param dc A numeric or integer, the code of the dc, coerced to integer,see \link{choice_c,RefDC-method}
#' @param anneedebut The starting the first year, passed as charcter or integer
#' @param anneefin the finishing year
#' @param selectedvalue A character to select and object in the \link{RefListe-class}
#' @param silent Boolean, if TRUE, information messages are not displayed
#' @return An object of class \link{Bilan_poids_moyen-class}
#' The choice_c method fills in the data slot for classes \link{RefDC-class} \link{RefAnnee-class}
#' \link{RefCoe-class} \link{RefListe-class}
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("choice_c",signature=signature("Bilan_poids_moyen"),definition=function(object,
				dc,				
				anneedebut,
				anneefin,
				selectedvalue,
				silent=FALSE){
			# code for debug using example
			#dc=c(5,6);anneedebut="2015";anneefin="2016";selectedvalue=">1";silent=FALSE
			if (length(selectedvalue)!=1) stop ("selectedvalue must be of length one")
			bilPM<-object
			bilPM@dc=charge(bilPM@dc)
			# loads and verifies the dc
			# this will set dc_selectionne slot
			bilPM@dc<-choice_c(object=bilPM@dc,dc)
			# only taxa present in the bilanMigration are use
			bilPM@anneedebut<-charge(object=bilPM@anneedebut,
					objectBilan="Bilan_poids_moyen")
			bilPM@anneedebut<-choice_c(object=bilPM@anneedebut,
					nomassign="anneeDebut",
					annee=anneedebut, 
					silent=silent)
			bilPM@anneefin@data<-bilPM@anneedebut@data
			bilPM@anneefin<-choice_c(object=bilPM@anneefin,
					nomassign="anneeFin",
					annee=anneefin, 
					silent=silent)
			bilPM@liste=charge(object=bilPM@liste,listechoice=c("=1",">1","tous"),label=gettext("choice of number in sample (one, several,all)",domain="R-stacomiR"))# choix de la categorie d'effectif)
			bilPM@liste<-choice_c(bilPM@liste,selectedvalue=selectedvalue)
			assign("bilan_poids_moyen",bilPM,envir=envir_stacomi)
			return(bilPM)
		})




#' Internal handler for calcule, class \code{\link{Bilan_poids_moyen-class}}. 
#' @param h handler
#' @param \dots additional arguments passed to the function
hcalc = function(h,...) {
	bilPM<-get("bilan_poids_moyen",envir=envir_stacomi)
	bilPM<-charge(bilPM)
	bilPM<-connect(bilPM)
	bilPM<-calcule(bilPM)

}


#' Calcule method for Bilan_poids_moyen
#' @param object An object of class \code{\link{Bilan_poids_moyen-class}}
#' @param silent Boolean, if TRUE, information messages are not displayed, only warnings and errors
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
setMethod("calcule",signature=signature("Bilan_poids_moyen"),definition=function(object,silent=FALSE) {
			bilPM<-object
			donnees				<-bilPM@data 
			coeff				<-bilPM@coe@data
			coeff$w	<-1/coeff$coe_valeur_coefficient
			coeff$date			<-as.POSIXct(coeff$coe_date_debut)
			if (!silent) funout(gettext("To obtain the table, type : bilan_poids_moyen=get('bilan_poids_moyen',envir_stacomi)@data\n",domain="R-stacomiR"))
			# changement des noms
			donnees<-stacomirtools::chnames(donnees,c("lot_identifiant","ope_date_debut","ope_date_fin",
							"lot_effectif","poids","w",
							"duree","datemoy"),
					c("lot","date","date_fin","effectif","poids","w","time.sequence","date"))
			# correction de manques d'effectifs dans la base
			if (sum(is.na(donnees$effectif))>0) warnings(gettextf("size is missing, lots %s",paste(unique(donnees$lot[is.na(donnees$effectif)]),collapse=" "),domain="R-stacomiR"))
			bilPM@calcdata[["data"]]<-donnees[,c(8,6,4,1)]
			bilPM@calcdata[["coe"]]<-coeff[order(coeff$date),c(10,9)]
			assign("bilan_poids_moyen",bilPM,envir=envir_stacomi)
			return(bilPM)
		})

hplot=function(h,...){
	
	bilPM<-get("bilan_poids_moyen",envir=envir_stacomi)
	if (h$action==1) {
		plot(bilPM,plot.type=1)
	} else if (h$action==2){
		plot(bilPM,plot.type=2)
	} else if (h$action==3){
		plot(bilPM,plot.type=3)
	}
	
}

#' Plot method for Bilan_poids_moyen' 
#' @note the model method provides plots for the fitted models
#' @param x An object of class \link{Bilan_poids_moyen-class}
#' @param plot.type Default "1". "1" plot of mean weight of glass eel against the mean date of operation (halfway between start,
#' and end of operation). The ggplot "p" can be accessed from envir_stacomi using \code{get("p",envir_stacomi)}. "2" standard plot of current coefficent.
#' "3" same as "1" but with size according to number.
#' @param silent Stops displaying the messages.
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @aliases plot.Bilan_poids_moyen plot.bilPM
#' @export
setMethod("plot",signature(x = "Bilan_poids_moyen", y = "missing"),definition=function(x, 
				plot.type="point",
				silent=FALSE)	{
			#plot.type="1";silent=FALSE
			#bilPM=get('bilan_poids_moyen',envir_stacomi)
			bilPM<-x			
			don<-bilPM@calcdata$data
			coe<-bilPM@calcdata$coe
			####################"
			# ggplot
			##################
			if (plot.type==1) {
				p<-ggplot2::qplot(x=date,y=w,data=don) 
				print(p)
				assign("p",p,envir=envir_stacomi)
				if (!silent) funout(gettext("ggplot object p assigned to envir_stacomi",domain="R-stacomiR"))
				####################"
				# standard plot
				##################
			} else if (plot.type==2){	
				if (length(bilPM@liste@selectedvalue)==0) stop("Internal error, the value has not been selected before launching plot")
				type_poids= switch (bilPM@liste@selectedvalue,
						">1"=gettext("wet weights",domain="R-stacomiR"),
						"=1"=gettext("dry weights",domain="R-stacomiR"),
						"tous"=gettext("wet and dry weights",domain="R-stacomiR"))  
				plot(x=don$date,y=don$w,
						xlab=gettext("date",domain="R-stacomiR"),
						ylab=gettext("mean weights",domain="R-stacomiR"),
						col="red",
						main=gettextf("Seasonal trend of %s, from %s to %s",
								type_poids,
								bilPM@anneedebut@annee_selectionnee,
								bilPM@anneefin@annee_selectionnee,domain="R-stacomiR"),
						sub="Trend of wet weights")
				coe<-coe[order(coe$date),]
				points(coe$date,coe$w,type="l",col="black",lty=2)
				#legend("topright",c("Obs.", "Coeff base"), col=c("black","cyan"),pch="o",cex = 0.8)
				
				####################"
				# geom_point + size
				##################
			} else if (plot.type==3){
				p<-ggplot2::qplot(x=date,y=w,data=don) 
				print(p+aes(size=effectif))
				assign("p",p,envir=envir_stacomi)
				if (!silent) funout(gettext("object p assigned to envir_stacomi",domain="R-stacomiR"))
			}
		})
		
		
#' Internal handler for reg, class \code{\link{Bilan_poids_moyen-class}}. 
#' @param h handler
#' @param \dots additional arguments passed to the function
		hreg = function(h,...) {			
			bilPM<-get("bilan_poids_moyen",envir=envir_stacomi)
			model(bilPM,model.type=h$action)			
		}
		

#' model method for Bilan_poids_moyen' 
#' this method uses samples collected over the season to model the variation in weight of
#' glass eel or yellow eels.
#' @param object An object of class \link{Bilan_pois_moyen-class}
#' @param model.type default "seasonal", "seasonal1","seasonal2","manual". 
#' \itemize{
#' 		\item{model.type="seasonal". The simplest model uses a seasonal variation, it is
#' 				fitted with a sine wave curve allowing a cyclic variation 
#' 				w ~ a*cos(2*pi*(doy-T)/365)+b with a period T. The julian time d0 used is this model is set
#' 				at zero 1st of November d = d + d0; d0 = 305.}
#' 		\item{model.type="seasonal1". A time component is introduced in the model, which allows
#' 			for a long term variation along with the seasonal variation. This long term variation is
#' 			is fitted with a gam, the time variable is set at zero at the beginning of the first day of observed values.
#' 			The seasonal variation is modeled on the same modified julian time as model.type="seasonal"
#' 			but here we use a cyclic cubic spline cc, which allows to return at the value of d0=0 at d=365.
#' 			This model was considered as the best to model size variations by Diaz & Briand in prep. but using a large set of values
#' 			over years.}
#' 		\item{model.type="seasonal2". The seasonal trend in the previous model is now modelled with a sine
#' 			curve similar to the sine curve used in seasonal.  The formula for this is \eqn{sin(\omega vt) + cos(\omega vt)}{{sin(omega vt) + cos(omega vt)}, 
#'			where vt is the time index variable \eqn{\omega}{omega} is a constant that describes how the index variable relates to the full period
#' 			(here, \eqn{2\pi/365=0.0172}{2pi/365=0.0172}). The model is written as following w~cos(0.0172*doy)+sin(0.0172*doy)+s(time).}
#' 		\item{model.type="manual", The dataset don (the raw data), coe (the coefficients already present in the
#' 			database, and newcoe the dataset to make the predictions from, are written to the environment envir_stacomi. 
#' 			please see example for further description on how to fit your own model, build the table of coefficients,
#' 			and write it to the database.}
#' }
#' @usage model(object,model.type=c("seasonal","seasonal1","seasonal2","manual"),silent=FALSE)
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @aliases model.Bilan_poids_moyen model.bilPM
#' @export
setMethod("model",signature(object = "Bilan_poids_moyen"),definition=function(object, 
				model.type="seasonal",
				silent=FALSE){
			#bilPM=get('bilan_poids_moyen',envir_stacomi);silent=TRUE;require(ggplot2)
			bilPM<-object
			don<-bilPM@calcdata$data
			coe<-bilPM@calcdata$coe
			seq=seq(as.Date(bilPM@coe@datedebut),as.Date(bilPM@coe@datefin),by="day")
			origine<-as.POSIXct(trunc(min(don$date),"day"))			
			# season starting in november
			fndate<-function(data){
				if (!"date"%in%colnames(data)) stop ("date should be in colnames(data)")
				if (!class(data$date)[1]=="POSIXct") stop("date should be POSIXct")
				data$year<-lubridate::year(data$date)
				data$yday=lubridate::yday(data$date)
				data$doy=data$yday-305 # year begins in november				
				data$season<-stringr::str_c(lubridate::year(data$date)-1,"-",lubridate::year(data$date)) # year-1-year
				data$season[data$doy>0]<-stringr::str_c(lubridate::year(data$date),"-",lubridate::year(data$date)+1)[data$doy>0] # for november and december it's year - year+1
				data$yearbis<-data$year # same as season but with a numeric
				data$yearbis[data$doy>0]<-data$yearbis[data$doy>0]+1 # same as season but a numeric
				data$doy[data$doy<0]<-data$doy[data$doy<0]+365
				data$time=as.numeric(data$date-origine)
				return(data)
			}
			don<-fndate(don)
			newcoe=data.frame("date"=seq,"mean_weight"=NA,"number"=NA,"lot"=NA,"yday"=lubridate::yday(seq))
			newcoe$date=as.POSIXct(newcoe$date)
			newcoe=fndate(newcoe)
			if (model.type=="seasonal"){
				result<-data.frame("season"=unique(don$season),year=unique(don$yearbis),a=NA,T=NA,b=NA)
				for (seas in unique(don$season)){
					#seas<-unique(don$season)[1]
					print(seas)
					print("___________")
					# regression one per season, taking T as adjusted previously
					year=result[result$season==seas,"year"]
					g0 <- nls(formula=w ~ a*cos(2*pi*(doy-T)/365)+b ,data=don[don$season==seas,],start=list(a=0.08,T=73.7,b=0.29))
					# getting the results into a table result
					result[result$season==seas,c("a","T","b")]<-coef(g0)
					print(summary(g0))
					print("AIC:")
					print(AIC(g0))
					# what is the size in december ? I'm just using the formula from Guerault and Desaunay
					#result[result$season==seas,"pred_weight"]<-coef(g0)["a"]*cos(2*pi*(50-T)/365)+coef(g0)["b"]
					# dataframe  for prediction, I will bind them to get a final dataframe (predatafull) for the graph below
					predatay<-newcoe[newcoe$season==seas,]
					predatay$pred_weight<-predict(g0, newdata=predatay)
					if (seas==unique(don$season)[1]){
						predata<-predatay
					} else predata<-rbind(predata,predatay)
				}
				print(result)
				p<-ggplot(don)+ geom_jitter(aes(x=doy,y=w),col="aquamarine4")+facet_wrap(~season )+
						geom_line(aes(x=doy,y=pred_weight),data=predata)+
						#geom_line(aes(x=doy,y=pred_weight),color="green",size=1,data=predatafull[predatafull$doy==50,])+
						theme_minimal()+
						theme(panel.border = element_blank(),
								axis.line = element_line())+
						xlab("Jour dans la saison, debut au 1er novembre")#,
				#plot.background=element_rect(fill="darkseagreen"))#,
				#panel.background = element_rect(fill = "grey90", colour = NA))
				
				print(p)
				assign("p", p,envir=envir_stacomi)	
				if (!silent) funout(gettext("ggplot object p assigned to envir_stacomi",domain="R-stacomiR"))
				
				
				#fm <- stats::nls(formula=w ~ a*cos(2*pi*(doy-T)/365)+b ,data=don,start=list(a=0.1,T=73,b=0.3))
				#pred<-stats::predict(fm, newdata=newcoe)
				#com=gettextf("sinusoidal model, a.cos(2.pi.(jour-T)/365)+b a=%s t=%s b=%s",round(coef(fm),2)[1],round(coef(fm),2)[2],round(coef(fm),2)[3])
				#plot(bilPM,plot.type=2)
				#points(as.POSIXct(newcoe$date),pred, col="magenta")
				#legend("topright",c("Obs.", "Coeff base","Mod"), col=c("black","cyan","magenta"),pch="o",cex = 0.8)
				#mtext(com,side=3,line=0.5) 
				result
                result_to_text<-stringr::str_c(sapply(t(result[,c(1,3,4,5)]),as.character),collapse=" ")
						
				# setting text for comment (lines inserted into the database)
				com=stringr::str_c("w ~ a*cos(2*pi*(doy-T)/365)+b with a period T.",
						" The julian time d0 used is this model is set at zero 1st of November doy = d + d0; d0 = 305.",
						" Coefficients for the model (one line per season): season, a, T, b =",
				result_to_text)
			} else if (model.type=="seasonal1"){
				g1 = mgcv::gam(w~s(yday,bs="cc")+s(time),data=don, knots = list(yday = c(1, 365)))
				# the knots=list(yday=c(1,365) is necessary for a smooth construction of the model
				summary(g1)
				plot(g1,pages=1)
				predata<-newcoe
				pred<-predict(g1, newdata=predata,se.fit=TRUE)
				predata$pred_weight<-pred$fit
				predata$pred_weight_lwr<-pred$fit-1.96*pred$se.fit
				predata$pred_weight_upr<-pred$fit+1.96*pred$se.fit				
				p<-ggplot(don)+ geom_jitter(aes(x=date,y=w),col="aquamarine4")+
						geom_line(aes(x=date,y=pred_weight),data=predata)+
						geom_ribbon(data=predata,aes(x=date,ymin=pred_weight_lwr,ymax=pred_weight_upr),alpha=0.3,fill="saddlebrown")+
						scale_x_datetime(date_breaks="years",date_minor_breaks="month")+
						theme_minimal()+
						theme(panel.border = element_blank(),
								axis.line = element_line())+
						xlab("Date")
				print(p)
				assign("p", p,envir=envir_stacomi)	
				assign("g1",g1,envir=envir_stacomi)
				if (!silent) funout(gettext("ggplot object p assigned to envir_stacomi",domain="R-stacomiR"))
				if (!silent) funout(gettext("gam model g1 assigned to envir_stacomi",domain="R-stacomiR"))
				com="model seasonal1 = gam(w~s(yday,bs='cc')+s(time), knots = list(yday = c(1, 365)))"
			} else 	if (model.type=="seasonal2"){
				#########################################################
				# seasonal effects with a continuous sine-cosine wave,.  The formula for this is ‘sin(omegavt) + cos(omegavt)’, where vt is the time index variable 
				#	omega is a constant that describes how the index variable relates to the full period (here, 2pi/365=0.0172).
				############################################################
				g2 = mgcv::gam(w~cos(0.0172*doy)+sin(0.0172*doy)+s(time),data=don)
				print(gettext("One model per year, doy starts in november",domain="R-stacomiR"))
				summary(g2)
				plot(g2,pages=1)
				predata<-newcoe
				pred<-predict(g2, newdata=predata,se.fit=TRUE)
				predata$pred_weight<-pred$fit
				predata$pred_weight_lwr<-pred$fit-1.96*pred$se.fit
				predata$pred_weight_upr<-pred$fit+1.96*pred$se.fit	
				p<-ggplot(don)+ geom_jitter(aes(x=date,y=w),col="aquamarine4")+
						geom_line(aes(x=date,y=pred_weight),data=predata)+
						geom_ribbon(data=predata,aes(x=date,ymin=pred_weight_lwr,ymax=pred_weight_upr),alpha=0.3,fill="wheat")+
						scale_x_datetime(date_breaks="years",date_minor_breaks="month")+
						theme_minimal()+
						theme(panel.border = element_blank(),
								axis.line = element_line())+
						xlab("Date")
				print(p)
				assign("p", p,envir=envir_stacomi)	
				assign("g2",g2,envir=envir_stacomi)
				if (!silent) funout(gettext("ggplot object p assigned to envir_stacomi",domain="R-stacomiR"))
				if (!silent) funout(gettext("gam model g2 assigned to envir_stacomi",domain="R-stacomiR"))
					
				###################################################################
				# comparison with Guerault and Desaunay (summary table in latex)
				######################################################################
				gamma=as.numeric(sqrt(g2$coefficients["cos(0.0172 * doy)"]^2+g2$coefficients["sin(0.0172 * doy)"]^2)) #0.386
				#compared with 0.111
				phi=round(as.numeric(atan2(g2$coefficients["sin(0.0172 * doy)"],g2$coefficients["cos(0.0172 * doy)"])-pi/2))# -0.82
				# time is centered on zero
				s0=as.numeric(g2$coefficients["(Intercept)"]) #7.04 (compared with 6.981)
				summary_harmonic<-data.frame("source"=c("Vilaine 1991-1993, Guerault et Desaunay","This model"),"$\\gamma$"=c(0.0375,gamma),"$s_0$"=c(0.263,s0),"$\\phi$"=c(319,305-phi))
				# need to repass colnames
				colnames(summary_harmonic)=c("source","$\\gamma$","$s_0(cm)$","$\\phi$")
				xt_summary_harmonic<-xtable( summary_harmonic,
						caption=gettext("Comparison of the coefficients obtained by \\citet{desaunay_seasonal_1997} and in the present modelling
								of estuarine samples.",domain="R-stacomiR"),
						label=gettext("summary_harmonic",domain="R-stacomiR"),
						digits=c(0,0,3,3,0))
				tabname<-stringr::str_c(get("datawd",envir=envir_stacomi),"/summary_harmonic.tex")
				o<-print(xt_summary_harmonic, file = tabname, 
						table.placement = "htbp",
						caption.placement = "top",
						NA.string = "",
						include.rownames=FALSE,
						tabular.environment="tabularx",
						width="0.6\\textwidth",
						sanitize.colnames.function=function(x){x})
				
				funout(gettextf("summary coefficients written in %s",tabname,domain="R-stacomiR"))					
				com=stringr::str_c("model seasonal2 = gam(w~cos(0.0172*doy)+sin(0.0172*doy)+s(time), knots = list(yday = c(1, 365))),Desaunay's gamma=",
						round(gamma,3),", phi=",phi,", s0=",round(s0,3))
				
				
			} else if (model.type=="manual"){
				if (!silent) funout(gettext("Table for predictions newcoe assigned to envir_stacomi",domain="R-stacomiR"))
				assign("newcoe",newcoe,envir=envir_stacomi)
				if (!silent) funout(gettext("Table of data don assigned to envir_stacomi",domain="R-stacomiR"))
				assign("don",don,envir=envir_stacomi)
				if (!silent) funout(gettext("Table of current coefficients coe assigned to envir_stacomi",domain="R-stacomiR"))
				assign("coe",coe,envir=envir_stacomi)
			}
			
		
			import_coe=data.frame(
					"coe_tax_code"='2038',
					"coe_std_code"='CIV',
					"coe_qte_code"=1,
					"coe_date_debut"=Hmisc::round.POSIXt(predata$date,units="days"),
					"coe_date_fin"=Hmisc::round.POSIXt(predata$date,units="days")+as.difftime(1,units="days"),
					"coe_valeur_coefficient"=1/predata$pred_weight,
					"coe_commentaires"=com)
			fileout= paste("C:/base/","import_coe",bilPM@anneedebut@annee_selectionnee,bilPM@anneefin@annee_selectionnee,".csv",sep="")
			#attention ecrit dans C:/base....
			utils::write.table(import_coe,file=fileout, row.names = FALSE,sep=";")
			assign("import_coe",import_coe,envir=envir_stacomi)
			funout(gettext("To obtain the table, type : import_coe=get(import_coe\",envir_stacomi",domain="R-stacomiR"))
			funout(paste(gettextf("data directory :%s",fileout,domain="R-stacomiR")))
			bilPM@calcdata[["import_coe"]]<-import_coe			
		})


hexp=function(h,...){
	# export d'un tableau que l'on peut ecrire dans la base
	gWidgets::gconfirm(gettext("Do you want to write data in the database ?",domain="R-stacomiR"),
			title=gettext("Warning!",domain="R-stacomiR"),
			handler=hreg,action="export")
	bilPM<-get("bilan_poids_moyen",envir=envir_stacomi)
	write_database(bilPM)
}



#
funtableBilan_poids_moyen = function(h,...) {
	bilPM<-get("bilan_poids_moyen",envir=envir_stacomi)
	bilPM=charge(bilPM)  
	donnees=bilPM@data # on recupere le data.frame  
	assign("bilan_poids_moyen",bilPM,envir_stacomi)
	funout(gettext("To obtain the table, type : bilan_poids_moyen=get('bilan_poids_moyen',envir_stacomi)@data\n",domain="R-stacomiR"))  
	donnees[is.na(donnees)]<-""  
	donnees$ope_date_debut=as.character(donnees$ope_date_debut)  
	donnees$ope_date_fin=as.character(donnees$ope_date_fin)   
	donnees$datemoy=as.character(donnees$datemoy)    
	gdf(donnees, container=TRUE)    
}   

#' Function to write data to the stacomi database for \link{Bilan_poids_moyen-class}
#' 
#' Data will be written in tj_coefficientconversion_coe table, if the class retrieves some data
#' from the database, those will be deleted first.
#' @param object An object of class \link{Bilan_poids_moyen-class}
#' @param silent Boolean, if TRUE, information messages are not displayed
#' @return An object of class \link{Bilan_poids_moyen-class}
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
#' @export
setMethod("write_database",signature=signature("Bilan_poids_moyen"),definition=function(object,silent=FALSE,dbname="bd_contmig_nat",host="localhost",port=5432){
			#silent=FALSE;dbname="bd_contmig_nat";host="localhost";port=5432
			bilPM<-object
			if (!"import_coe"%in% names(bilPM@calcdata)) funout(gettext("Attention, you must fit a model before trying to write the predictions in the database",domain="R-stacomiR"),arret=TRUE)
			# first delete existing data from the database
			supprime(bilPM@coe,tax=2038,std="CIV")
			import_coe<-bilPM@calcdata$import_coe
			baseODBC<-get("baseODBC",envir=envir_stacomi)
			sql<-stringr::str_c("INSERT INTO ",get("sch",envir=envir_stacomi),"tj_coefficientconversion_coe (",			
					"coe_tax_code,coe_std_code,coe_qte_code,coe_date_debut,coe_date_fin,coe_valeur_coefficient,
							coe_commentaires)",
					" SELECT * FROM import_coe;")
			invisible(utils::capture.output(
							sqldf::sqldf(x=sql,
									drv="PostgreSQL",
									user=baseODBC["uid"],
									dbname=dbname,				
									password=baseODBC["pwd"],
									host=host,
									port=port)
					))		
		})



