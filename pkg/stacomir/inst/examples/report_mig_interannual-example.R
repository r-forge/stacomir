require(stacomiR)
# launching stacomi without selecting the scheme or interface
stacomi(
	database_expected=FALSE, sch='pmp')
# If you have connection to the database with the pmp scheme 
# prompt for user and password but you can set appropriate options for host, port and dbname
\dontrun{
	stacomi(database_expected=TRUE, sch="pmp")	
	if (interactive()){
		if (!exists("user")){
			user <- readline(prompt="Enter user: ")
			password <- readline(prompt="Enter password: ")	
		}	
	}
	options(					
			stacomiR.dbname = "bd_contmig_nat",
			stacomiR.host ="localhost",
			stacomiR.port = "5432",
			stacomiR.user = user,
			stacomiR.user = password						
	)	

  # (longest historical dataset available
  # in France for eel ...) this suppose you have access to the pmp schema...
  # a glimpse of the dataset is still available in the r_mig_interannual dataset 
  # loaded in the package...
  r_mig_interannual <- new("report_mig_interannual")
  r_mig_interannual <- choice_c(r_mig_interannual,
	  dc=c(16),
	  taxa=c("Anguilla anguilla"),
	  stage=c("PANG"),
	  start_year="1990",
	  end_year="2015",
    year_choice=NULL,
	  silent=TRUE)
  r_mig_interannual <- charge(r_mig_interannual)
  r_mig_interannual <- connect(r_mig_interannual, check=TRUE)	
  r_mig_interannual <- calcule(r_mig_interannual, silent=TRUE)	
}	
#############otherwise use this ######################
# load the dataset generated by previous lines
data("r_mig_interannual")

#######################################################
# the first plot is of little interest, it allows to see what data 
# are available... simple lines
# For irregular operations like those reported at the enfrenaux eel ladder....
plot(r_mig_interannual,plot.type="line", year_choice=2015, silent=TRUE)

# a plot to show the seasonality, this graph may be misleading if the
# migration is not monitored all year round. Note the y unit is not very informative
# you need to have the viridis package loaded to run this example
plot(r_mig_interannual,plot.type="density",year_choice=2015, silent=TRUE)
\dontrun{
  if (requireNamespace("ggplot2", quietly = TRUE)&
	  requireNamespace("viridis", quietly = TRUE)){
	g<-get("g",envir=envir_stacomi)	
	g+
		ggplot2::scale_fill_manual(values=viridis::viridis(22))+
		ggplot2::ggtitle("Saisonnalite de la migration aux Enfrenaux")
  }
  #############################################
# the standard plot is showing daily values
  ###########################################
  plot(r_mig_interannual,plot.type="standard",year_choice=2015,silent=TRUE)
# Manual edition of the graph produced
  if (requireNamespace("ggplot2", quietly = TRUE)){
    g1<-get("g1",envir=envir_stacomi)
    g1<-g1+ggplot2::ggtitle("Les Enfrenaux")+
		ggplot2::scale_fill_manual(name="Source", 
			values=c("purple","#0A0C01"),
			labels = c("historical set","2015 values"))+
		ggplot2::scale_colour_manual(name="Source", values="#B8EA00",
			labels = c("historical mean"))	+
		ggplot2::ylab("Nombre d'anguilles")
    print(g1)
  }
  #########################################################
# Another graph to show a "manual" processing of the data
# and their extraction from the data slot
  #########################################################	
  if (requireNamespace("ggplot2", quietly = TRUE)&
	      requireNamespace("viridis", quietly = TRUE)){
    dat<-fun_date_extraction(r_mig_interannual@data, # data to import
		"bjo_jour", # name of the column where dates are found
		annee=FALSE,
		mois=TRUE,
		semaine =TRUE,
		jour_mois=FALSE)
# sum per month
    res<-dplyr::select(dat,bjo_valeur,bjo_annee,semaine)
    res<-dplyr::group_by(res,bjo_annee,semaine)
    res<-dplyr::summarize(res,effectif=sum(bjo_valeur))
    ggplot2::ggplot(res, ggplot2::aes(x = semaine, y = bjo_annee,fill=effectif)) +
	        ggplot2::geom_tile(colour="black") + ggplot2::coord_fixed() +
	        viridis::scale_fill_viridis(begin=0,option="D") + ggplot2::theme_bw()+
	        ggplot2::theme(panel.background= ggplot2::element_rect(fill = "#9360A9"),
			panel.grid.major=ggplot2::element_line(colour="#C1DB39"),
			panel.grid.minor=ggplot2::element_line(colour="#7DD632"))+
	        ggplot2::ylab("year")+ggplot2::xlab("week")+
	        ggplot2::ggtitle("Historical trend at Les Enfrenaux Eel trap")
	
  }
  ###############################################
# barchart with different splitting periods
# the migration is displayed against seasonal data
# extacted from all other years loaded in the report
  ################################################
# available arguments for timesplit are "quinzaine" and "mois" and "semaine"
# with the silent=TRUE argument, it's always the latest year that is selected,
# otherwise the user is prompted with a choice, to select the year he wants
# to compare will all others...
  plot(r_mig_interannual,plot.type="barchart",timesplit="quinzaine",year_choice=2015,silent=TRUE)
# Comparison with historical values. Each year and 2 weeks values 
# is a point on the graph...
  plot(r_mig_interannual,plot.type="pointrange",timesplit="mois",year_choice=2015,silent=TRUE)
  ###############################################
# Step plot
# different years shown in the graph
# the current year (or the selected year if silent=FALSE)
# is displayed with a dotted line
  ################################################
  plot(r_mig_interannual,plot.type="step",year_choice=2015,silent=TRUE)
  if (requireNamespace("ggplot2", quietly = TRUE)&
	  requireNamespace("viridis", quietly = TRUE)){
	g<-get("g",envir=envir_stacomi)	+ ggplot2::theme_minimal()
	g+viridis::scale_color_viridis(discrete=TRUE)+
		ggplot2::ggtitle("Cumulated migration step plot 
				at les Enfrenaux eel trap")
	
  }
  ###############################################
# Plots for seasonality of the salmon migration
# using a Loire river dataset (Vichy fishway)
  ################################################
  data("r_mig_interannual_vichy")
# the following show how data are processed to get
# statistics for seaonal migration, daily values
  r_mig_interannual_vichy<-calcule(r_mig_interannual_vichy,
      timesplit="jour",year_choice=2012,silent=TRUE)
#r_mig_interannual_vichy@calcdata #check this to see the results
# statistics for seaonal migration, weekly values
  r_mig_interannual_vichy<-calcule(r_mig_interannual_vichy,timesplit="semaine"
                                   ,year_choice=2012,silent=TRUE)
#r_mig_interannual_vichy@calcdata 
  
# the plot method also runs the calcule method
  plot(r_mig_interannual_vichy,plot.type="seasonal",
      timesplit="semaine", year_choice=2012, silent=TRUE)
  plot(r_mig_interannual_vichy,plot.type="seasonal",
      timesplit="mois", year_choice=2012, silent=TRUE)
  plot(r_mig_interannual_vichy,plot.type="seasonal",
      timesplit="jour",year_choice=2012, silent=TRUE)
  
  
  ###############################################
# Plots for seasonality using another Loire river dataset
# with the migration of Lampreys (Petromyzon marinus) 
# recorded at the the Descarte DF (Vienne)
  ################################################
# run this only if you are connected to the logrami dataset
stacomi(database_expected = TRUE, sch = 'logrami')
  bmi_des<-new("report_mig_interannual")
  bmi_des<-choice_c(bmi_des,
	  dc=c(23),
	  taxa=c("Petromyzon marinus"),
	  stage=c("5"),
	  start_year="2007",
	  end_year="2014",
	  silent=TRUE)
  bmi_des<-connect(bmi_des)	
  bmi_des<-calcule(bmi_des,timesplit="semaine")
  plot(bmi_des,plot.type="seasonal",timesplit="semaine",year_choice=2014)
  plot(bmi_des,plot.type="seasonal",timesplit="jour",year_choice=2014)
  plot(bmi_des,plot.type="seasonal",timesplit="mois",year_choice=2014)
}	



