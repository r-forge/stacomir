context("RequeteODBCwheredate")
if (interactive()){
	if (!exists("user")){
		host <- readline(prompt="Enter host: ")
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}
test_that("Test that RequeteODBCwheredate returns rows", {
			skip_on_cran()
			# this requires an odbc link to be setup for test here a database bd_contmig_nat used for stacomir
			# the odbc link is bd_contmig_nat and points to database bd_contmig_nat
			# userlocal and passwordlocal are generated from Rprofile.site
			object <-new("RequeteODBCwheredate")
			object@datedebut <- strptime("2012-01-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
			object@datefin <-  strptime("2013-01-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
			object@colonnedebut="ope_date_debut" 
			object@colonnefin="ope_date_fin"			
			object@select<- "select * from iav.t_operation_ope"
			object@where <- "WHERE ope_dic_identifiant=5"
			object@order_by<-"limit 10"
			object@baseODBC=c("bd_contmig_nat",user,password)
			object <- connect(object)
			expect_gt(nrow(object@query),0)
		})
