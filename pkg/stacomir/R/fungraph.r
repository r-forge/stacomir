#' Function for BilanMigration graphes including numbers DF DC operations
#' 
#' This graph is for species other than glass eel
#' 
#' 
#' @param bilanMigration An object of class \code{\linkS4class{BilanMigration}}
#' @param tableau A data frame with the with the following columns : No.pas,debut_pas,fin_pas,              
#' ope_dic_identifiant,lot_tax_code,lot_std_code,type_de_quantite,MESURE,CALCULE,               
#' EXPERT,PONCTUEL,Effectif_total,taux_d_echappement,coe_valeur_coefficient
#' @note this function is intended to be called from the plot method in BilanMigrationMult and BilanMigration
#' @param time.sequence A vector POSIXt
#' @param taxon The species
#' @param stade The stage
#' @param dc The DC
#' @param silent Message displayed or not
#' @param color Default NULL, a vector of color in the following order, working, stopped, 1...5 types of operation
#' for the fishway or DC, measured, calculated, expert, direct observation. If null will be set to brewer.pal(12,"Paired")[c(8,10,4,6,1,2,3,5,7)]
#' @param color_ope Default NULL, a vector of color for the operations. Default to brewer.pal(4,"Paired")
#' @param ... additional parameters passed to matplot, main, ylab, ylim, lty, pch, bty, cex.main,
#' it is currenly not a good idea to change xlim (numbers are wrong, the month plot covers all month, and legend placement is wrong
#' @author Cedric Briand \email{cedric.briand"at"eptb-vilaine.fr}
fungraph=function(bilanMigration,tableau,time.sequence,taxon,stade,dc=NULL,silent,color=NULL,color_ope=NULL,...){
#mat <- matrix(1:6,3,2)
#layout(mat)
	#browser() 
	#cat("fungraph")
	# color=null
	# color calculation
	
	
	if (is.null(color)) {
		tp<-RColorBrewer::brewer.pal(12,"Paired")
		mypalette=c(
				"working"=tp[4],
				"stopped"=tp[6],
				"listeperiode1"=tp[1],
				"listeperiode2"=tp[2],
				"listeperiode3"=tp[3],
				"listeperiode4"=tp[5],
				"listeperiode5"=tp[7],
				"ponctuel"="indianred",
				"expert"="chartreuse2",
				"calcule"="deepskyblue",
				"mesure"="black"
		)
	} else {
		if(length(color)!=11) stop("The length of color must be 11")
		mypalette=c(
				"working"=		color[1], 
				"stopped"=		color[2], 
				"listeperiode1"=color[3], 
				"listeperiode2"=color[4], 
				"listeperiode3"=color[5], 
				"listeperiode4"=color[6], 
				"listeperiode5"=color[7],
				"mesure"=		color[8],
				"calcule"=		color[9],
				"expert"=		color[10],
				"ponctuel"=		color[11]
		)
	}
	
	if (is.null(color_ope)) {
		if(stacomirtools::is.odd(dc)) brew="Paired" else brew="Accent"
		color_ope=RColorBrewer::brewer.pal(8,brew)
	}
	
	if (is.null(dc)) dc=bilanMigration@dc@dc_selectionne[1]
	annee=unique(strftime(as.POSIXlt(time.sequence),"%Y"))[1]
	mois= months(time.sequence)
	jour= strftime(as.POSIXlt(time.sequence),"%j")
	jmois=strftime(as.POSIXlt(time.sequence),"%d")
	mois=unique(mois)
	mois=paste("15",substr(as.character(mois),1,3))
	index=as.vector(tableau$No.pas[jmois==15])
	x=1:nrow(tableau)
	debut=unclass(as.POSIXct((min(time.sequence))))[[1]] # attention arrondit e un jour de moins
	fin=unclass(as.POSIXct(max(time.sequence)))[[1]]
	dis_commentaire=  as.character(bilanMigration@dc@data$dis_commentaires[bilanMigration@dc@data$dc%in%dc]) # commentaires sur le DC
	###################################
	# Definition du layout
	####################################
	vec<-c(rep(1,15),rep(2,2),rep(3,2),4,rep(5,6))
	mat <- matrix(vec,length(vec),1)
	layout(mat)
	
	#par("bg"=grDevices::gray(0.8))
	graphics::par("mar"=c(3, 4, 3, 2) + 0.1)
	###################################
	# Graph annuel couvrant sequence >0
	####################################
	dots<-list(...)
	if (!"main"%in%names(dots)) main=gettextf("Glass eels graph %s, %s, %s, %s",dis_commentaire,taxon,stade,annee,domain="R-stacomiR")
	else main=dots[["main"]]
	if (!"ylab"%in%names(dots)) ylab=gettext("Number of glass eels (x1000)",domain="R-stacomiR")
	else ylab=dots[["ylab"]]
	if (!"cex.main"%in%names(dots)) cex.main=1
	else cex.main=dots[["cex.main"]]
	if (!"font.main"%in%names(dots)) font.main=1
	else font.main=dots[["font.main"]]
	if (!"type"%in%names(dots)) type="h"
	else type=dots[["type"]]
	if (!"xlim"%in%names(dots)) xlim=c(debut,fin)
	else xlim=c(debut,fin)#dots[["xlim"]] # currently this argument is ignored
	if (!"ylim"%in%names(dots)) ylim=NULL
	else ylim=dots[["ylim"]]
	if (!"cex"%in%names(dots)) cex=1
	else cex=dots[["cex"]]
	if (!"lty"%in%names(dots)) lty=1
	else lty=dots[["lty"]]
	if (!"pch"%in%names(dots)) pch=16
	else pch=dots[["pch"]]	
	if (!"bty"%in%names(dots)) bty="l"
	else bty=dots[["bty"]]
	matplot(time.sequence,cbind(tableau$MESURE+tableau$CALCULE+tableau$EXPERT+tableau$PONCTUEL,
					tableau$MESURE+tableau$CALCULE+tableau$EXPERT,
					tableau$MESURE+tableau$CALCULE,
					tableau$MESURE),
			col=mypalette[c("ponctuel","expert","calcule","mesure")],
			type=type,
			pch=pch,
			lty=lty,
			xaxt="n",
			bty=bty,
			ylab=ylab,
			xlab=NULL,
			main=main,
			xlim=c(debut,fin),
			cex.main=cex.main,
			font.main=font.main)
	if(bilanMigration@pasDeTemps@stepDuration=="86400"){ # pas de temps journalier
		index=as.vector(x[jmois==15])
		axis(side=1,at=index,tick=TRUE,labels=mois)
		#axis(side=1,at=as.vector(x[jmois==1]),tick=TRUE,labels=FALSE)
		
	} else {
		axis(side=1)
	}  	
	mtext(text=gettextf("Sum of numbers =%s",
					round(sum(tableau$MESURE,tableau$CALCULE,tableau$EXPERT,tableau$PONCTUEL,na.rm=TRUE)),domain="R-stacomiR"),
			side=3,
			col=mypalette["expert"],
			cex=0.8)
	
	legend(x=0,
			y=max(tableau$MESURE,tableau$CALCULE,tableau$EXPERT,tableau$PONCTUEL,na.rm=TRUE),
			legend=gettext("measured","calculated","expert","direct",domain="R-stacomiR"),
			pch=c(16),
			col=mypalette[c("mesure","calcule","expert","ponctuel")])
	bilanOperation<-get("bilanOperation",envir=envir_stacomi)
	t_operation_ope<-bilanOperation@data[bilanOperation@data$ope_dic_identifiant==dc,]
	dif=difftime(t_operation_ope$ope_date_fin,t_operation_ope$ope_date_debut, units ="days")
	
	if (!silent){
		funout(ngettext(nrow(t_operation_ope),"%d operation \n", "%d operations \n",domain="R-stacomiR"))
		funout(gettextf("average trapping time = %s days\n",round(mean(as.numeric(dif)),2),domain="R-stacomiR"))
		funout(gettextf("maximum term = %s",round(max(as.numeric(dif)),2),domain="R-stacomiR"))
		funout(gettextf("minimum term = %s",round(min(as.numeric(dif)),2),domain="R-stacomiR"))
	}
	
	
	df<-bilanMigration@dc@data$df[bilanMigration@dc@data$dc==dc]
	bilanFonctionnementDF<-get("bilanFonctionnementDF",envir=envir_stacomi)
	bilanFonctionnementDC<-get("bilanFonctionnementDC", envir=envir_stacomi)
	bilanFonctionnementDF@data<-bilanFonctionnementDF@data[bilanFonctionnementDF@data$per_dis_identifiant==df,]
	bilanFonctionnementDC@data<-bilanFonctionnementDC@data[bilanFonctionnementDC@data$per_dis_identifiant==dc,]
	
	
	
	graphdate<-function(vectordate){
		attributes(vectordate)<-NULL
		vectordate=unclass(vectordate)
		vectordate[vectordate<debut]<-debut
		vectordate[vectordate>fin]<-fin
		return(vectordate)
	}
	
	
	###################################         
	# creation d'un graphique vide (2)
	###################################
	graphics::par("mar"=c(0, 4, 0, 2)+ 0.1)  
	plot(   as.POSIXct(time.sequence),
			seq(0,3,length.out=nrow(tableau)),
			xlim=xlim, 
			type= "n", 
			xlab="",
			xaxt="n",
			yaxt="n", 
			ylab=gettext("Fishway",domain="R-stacomiR"),
			bty="n",
			cex=cex+0.2)
	
	###################################         
	# temps de fonctionnement du DF
	###################################
	
	if (dim(bilanFonctionnementDF@data)[1]==0 ) {
		
		rect(   xleft=debut, 
				ybottom=2.1,
				xright=fin,
				ytop=3, 
				col = "grey",
				border = NA, 
				lwd = 1)    
		rect(   xleft=debut, 
				ybottom=1.1,
				xright=fin,
				ytop=2, 
				col = "grey40",
				border = NA, 
				lwd = 1)           
		legend(  x= "bottom",
				legend= gettext("Unknown working","Unknow operation type",domain="R-stacomiR"),
				pch=c(16,16),
				col=c("grey","grey40"),
				horiz=TRUE,
				bty="n"
		)
		
		
	} else {
		
		# si il sort quelque chose
		if (sum(bilanFonctionnementDF@data$per_etat_fonctionnement==1)>0){    
			rect(   xleft =graphdate(as.POSIXct(bilanFonctionnementDF@data$per_date_debut[
											bilanFonctionnementDF@data$per_etat_fonctionnement==1])), 
					ybottom=2.1,
					xright=graphdate(as.POSIXct(bilanFonctionnementDF@data$per_date_fin[
											bilanFonctionnementDF@data$per_etat_fonctionnement==1])),
					ytop=3, 
					col = mypalette["working"],
					border = NA, 
					lwd = 1)       }
		if (sum(bilanFonctionnementDF@data$per_etat_fonctionnement==0)>0){              
			rect(   xleft =graphdate(as.POSIXct(bilanFonctionnementDF@data$per_date_debut[
											bilanFonctionnementDF@data$per_etat_fonctionnement==0])), 
					ybottom=2.1,
					xright=graphdate(as.POSIXct(bilanFonctionnementDF@data$per_date_fin[
											bilanFonctionnementDF@data$per_etat_fonctionnement==0])),
					ytop=3, 
					col = mypalette["stopped"],
					border = NA, 
					lwd = 1)  }
		#creation d'une liste par categorie d'arret contenant vecteurs dates    
		listeperiode<-
				fn_table_per_dis(typeperiode=bilanFonctionnementDF@data$per_tar_code,
						tempsdebut= bilanFonctionnementDF@data$per_date_debut,
						tempsfin=bilanFonctionnementDF@data$per_date_fin,
						libelle=bilanFonctionnementDF@data$libelle,
						date=FALSE)
		nomperiode<-vector()
		color_periodes<-vector() # a vector of colors, one per period type in listeperiode
		for (j in 1 : length(listeperiode)){
			#recuperation du vecteur de noms (dans l'ordre) e partir de la liste
			nomperiode[j]<-substr(listeperiode[[j]]$nom,1,17) 
			#ecriture pour chaque type de periode   
			color_periode=stringr::str_c("listeperiode",j)		
			rect(   xleft=graphdate(listeperiode[[j]]$debut), 
					ybottom=1.1,
					xright=graphdate(listeperiode[[j]]$fin),
					ytop=2, 
					col = mypalette[color_periode],
					border = NA, 
					lwd = 1) 
			color_periodes<-c(color_periodes,color_periode)
		}       
		
		legend  (x= debut,
				y=1.2,
				legend= c(gettext("stop",domain="R-stacomiR"),nomperiode),
				pch=c(15,15),
				col=c(mypalette["working"],mypalette["stopped"],mypalette[color_periodes]),
				bty="n",
				ncol=7,
				text.width=(fin-debut)/10)
	}
	
	###################################         
	# creation d'un graphique vide (3)
	###################################                 
	
	graphics::par("mar"=c(0, 4, 0, 2)+ 0.1)  
	plot(   as.POSIXct(time.sequence),
			seq(0,3,length.out=nrow(tableau)),
			xlim=xlim, 
			type= "n", 
			xlab="",
			xaxt="n",
			yaxt="n", 
			ylab=gettext("CD",domain="R-stacomiR"),
			bty="n",
			cex=cex+0.2
			)             
	###################################         
	# temps de fonctionnement du DC
	###################################                 
	
	
	if (dim(bilanFonctionnementDC@data)[1]==0 ) {
		
		rect(      xleft=debut, 
				ybottom=2.1,
				xright=fin,
				ytop=3, 
				col = "grey",
				border = NA, 
				lwd = 1)               
		
		rect(      xleft=debut, 
				ybottom=1.1,
				xright=fin,
				ytop=2, 
				col = "grey40",
				border = NA, 
				lwd = 1)
		legend(  x= "bottom",
				legend= gettext("Unknown working","Unknow operation type",domain="R-stacomiR"),
				pch=c(16,16),
				col=c("grey","grey40"),
				#horiz=TRUE,
				ncol=5,
				bty="n")
		
		
	} else {
		
		if (sum(bilanFonctionnementDC@data$per_etat_fonctionnement==1)>0){ 
			rect(   xleft =graphdate(as.POSIXct(bilanFonctionnementDC@data$per_date_debut[
											bilanFonctionnementDC@data$per_etat_fonctionnement==1])), 
					ybottom=2.1,
					xright=graphdate(as.POSIXct(bilanFonctionnementDC@data$per_date_fin[
											bilanFonctionnementDC@data$per_etat_fonctionnement==1])),
					ytop=3, 
					col = mypalette["working"],
					border = NA, 
					lwd = 1) }
		if (sum(bilanFonctionnementDC@data$per_etat_fonctionnement==0)>0)
		{ 
			rect(   xleft =graphdate(as.POSIXct(bilanFonctionnementDC@data$per_date_debut[
											bilanFonctionnementDC@data$per_etat_fonctionnement==0])), 
					ybottom=2.1,
					xright=graphdate(as.POSIXct(bilanFonctionnementDC@data$per_date_fin[
											bilanFonctionnementDC@data$per_etat_fonctionnement==0])),
					ytop=3, 
					col = mypalette["stopped"],
					border = NA, 
					lwd = 1) }
		listeperiode<-
				fn_table_per_dis(typeperiode=bilanFonctionnementDC@data$per_tar_code,
						tempsdebut= bilanFonctionnementDC@data$per_date_debut,
						tempsfin=bilanFonctionnementDC@data$per_date_fin,
						libelle=bilanFonctionnementDC@data$libelle,
						date=FALSE)
		nomperiode<-vector()
		color_periodes<-vector()
		for (j in 1 : length(listeperiode)){
			nomperiode[j]<-substr(listeperiode[[j]]$nom,1,17)   
			color_periode=stringr::str_c("listeperiode",j)
			rect(   xleft=graphdate(listeperiode[[j]]$debut), 
					ybottom=1.1,
					xright=graphdate(listeperiode[[j]]$fin),
					ytop=2, 
					col = mypalette[color_periode],
					border = NA, 
					lwd = 1)        
		}
		
		legend  (x= debut,
				y=1.2,
				legend= gettext("working","stopped",nomperiode,domain="R-stacomiR"),
				pch=c(15,15),
				col=c(mypalette["working"],mypalette["stopped"],mypalette[color_periodes]),
				bty="n",
				ncol=length(listeperiode)+2,
				text.width=(fin-debut)/10)
	}
	
	###################################         
	# creation d'un graphique vide (4=op)
	###################################                 
	
	
	graphics::par("mar"=c(0, 4, 0, 2)+ 0.1)  
	plot(   as.POSIXct(time.sequence),
			seq(0,1,length.out=nrow(tableau)),
			xlim=xlim, 
			type= "n", 
			xlab="",
			xaxt="n",
			yaxt="n", 
			ylab=gettext("Op",domain="R-stacomiR"),
			bty="n",
			cex=cex+0.2)             
	###################################         
	# operations
	###################################  
	
	rect(   xleft =graphdate(as.POSIXct(t_operation_ope$ope_date_debut)), 
			ybottom=0,
			xright=graphdate(as.POSIXct(t_operation_ope$ope_date_fin)),
			ytop=1, 
			col = color_ope,
			border = NA, 
			lwd = 1)
	
	
	###################################
	# Graph mensuel 
	####################################
	graphics::par("mar"=c(4, 4, 1, 2) + 0.1)
	tableau$mois=factor(months(tableau$debut_pas,abbreviate=TRUE),
			levels=unique(months(tableau$debut_pas,abbreviate=TRUE)))
	tableaum<-reshape2::melt(data=tableau[,c("MESURE","CALCULE","EXPERT","PONCTUEL","mois")],							
			id.vars=c("mois"),
			measure.vars=c("MESURE","CALCULE","EXPERT","PONCTUEL"),
			variable.name="type",
			value.name="number")
	levels(tableaum$type)<-gettext("measured","calculated","expert","direct",domain="R-stacomiR")
	superpose.polygon<-lattice::trellis.par.get("plot.polygon")
	superpose.polygon$col=  mypalette[c("mesure","calcule","expert","ponctuel")]
	superpose.polygon$border=rep("transparent",6)
	lattice::trellis.par.set("superpose.polygon",superpose.polygon)
	fontsize<-lattice::trellis.par.get("fontsize")
	fontsize$text=10
	lattice::trellis.par.set("fontsize",fontsize)
	par.main.text<-lattice::trellis.par.get("par.main.text")
	par.main.text$cex=1
	par.main.text$font=1
	lattice::trellis.par.set("par.main.text",par.main.text)
	# lattice::show.settings()
	
	par.ylab.text<-lattice::trellis.par.get("par.ylab.text")
	par.ylab.text$cex=0.8
	lattice::trellis.par.set("par.ylab.text",par.ylab.text) 
	par.xlab.text<-lattice::trellis.par.get("par.xlab.text")
	par.xlab.text$cex=0.8
	lattice::trellis.par.set("par.xlab.text",par.xlab.text)
	
	bar<-lattice::barchart(number/1000~mois,
			groups=type,
			xlab=gettext("Month",domain="R-stacomiR"),
			ylab=gettext("Number (x1000)",domain="R-stacomiR"),
			#    main=list(label=paste("Donnees mensuelles")),
			data=tableaum,
			allow.multiple=FALSE,
			strip=FALSE,
			stack=TRUE,
#			key=lattice::simpleKey(text=levels(tableaum$type),
#					rectangles = TRUE, 
#					points=FALSE, 
#					space="right", 
#					cex=0.8),
			origin=0)
	print(bar,position = c(0, 0, 1, .25),newpage = FALSE)
	
	
#	
#	
#	X11(7,4)
#	stktab=cbind(utils::stack(tableau[,c("MESURE","CALCULE","EXPERT","PONCTUEL")]),"time.sequence"=rep(time.sequence,4))
#	stktab<-funtraitementdate(stktab,
#			nom_coldt="time.sequence",
#			annee=FALSE,
#			mois=TRUE,
#			quinzaine=TRUE,
#			semaine=TRUE,
#			jour_an=TRUE,
#			jour_mois=FALSE,
#			heure=FALSE)
#	stktab$ind<-factor(stktab$ind, levels = c("MESURE","CALCULE","EXPERT","PONCTUEL"))
#	fillname<-gettext("type")
#	mypalette<-rev(c("black","deepskyblue","chartreuse2","indianred"))
#	g<-ggplot(stktab, aes(x=mois,y=values,fill=ind))+
#			geom_bar(position="dodge", stat="identity")+
#			scale_fill_manual(name=fillname,values=c("MESURE"=mypalette[4],
#							"CALCULE"=mypalette[3],
#							"EXPERT"=mypalette[2],
#							"PONCTUEL"=mypalette[1]))+
#			xlab(gettext("month")+ # mois or month+)
#			ylab(gettext("Numbers") # Nombre ou Numbers)
#	nothing<-print(g)
	# pour l'instant je ne peux pas combiner avec les autres => deux graphes
	return(invisible(NULL))
}






