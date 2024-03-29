# launching stacomi without database for demo
stacomi(database_expected=FALSE)
# the following piece of script will load the Arzal dataset and connected to iav postgres schema
# it requires a working database
# prompt for user and password but you can set appropriate options for host, port and dbname
\dontrun{
	stacomi(database_expected=TRUE, sch='iav')
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
  r_ann<-new("report_annual")
  r_ann<-choice_c(r_ann,
	  dc=c(5,6,12),
	  taxa=c("Anguilla anguilla"),
	  stage=c("AGJ","AGG"),
	  start_year="1996",
	  end_year="2015",
	  silent=FALSE)
  r_ann<-connect(r_ann)	
}
# the following dataset has been generated by the previous code
data(r_ann)
xtr_ann<-stacomiR::xtable(r_ann,
	dc_name=c("Passe bassins","Piege anguille RG","Piege anguille RD"),
	tax_name="Anguille",
	std_name=c("Arg.","Jaun."))
# below not run but one can create a file as following
\dontrun{
  path=file.path(path.expand(get("datawd",envir=envir_stacomi)),
	  paste(paste(r_ann@dc@dc_selected,collapse="+"),"_",
		  paste(r_ann@taxa@taxa_selected,collapse="+"),"_",
		  paste(r_ann@stage@stage_selected,collapse="+"),"_",
		  r_ann@start_year@year_selected,":",
		  r_ann@end_year@year_selected,".html",sep=""),fsep ="/")
# here you can add an argument file=path
  print(xtr_ann,type="html")
  
# the following uses the "addtorow" argument which creates nice column headings,
# format.args creates a thousand separator
# again this will need to be saved in a file using the file argument
  print(xtr_ann,
	  add.to.row=get("addtorow",envir_stacomi),
	  include.rownames = TRUE,
	  include.colnames = FALSE,
	  format.args = list(big.mark = " ", decimal.mark = ",")
  )
# barplot transforms the data, further arguments can be passed as to barplot
  barplot(r_ann)
  barplot(r_ann,
	  args.legend=list(x="topleft",bty = "n"),
	  col=c("#CA003E","#1A9266","#E10168","#005327","#FF9194"))
  
# An example with custom arguments for legend.text (overriding plot defauts)
  data(r_ann_adour)
  if (requireNamespace("RColorBrewer", quietly = TRUE)){
	lesdc<-r_ann_adour@dc@data$dc_code[r_ann_adour@dc@data$dc%in%r_ann_adour@dc@dc_selected]
    barplot(r_ann_adour,
		legend.text=lesdc,
		args.legend=list(x="topleft",bty = "n"),
		col=RColorBrewer::brewer.pal(9,"Spectral"),
		beside=TRUE)
  }
  plot(r_ann_adour)
}
