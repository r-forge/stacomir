context("RequeteODBC")
if (interactive()){
	if (!exists("user")){
		host <- readline(prompt="Enter host: ")
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}
test_that("Test that RequeteODBC works on a database ", {
			skip_on_cran()
			# this requires an odbc link to be setup for test here a database bd_contmig_nat used for stacomir
			# the odbc link is bd_contmig_nat and points to database bd_contmig_nat
			object <-new("RequeteODBC")
			object@baseODBC=c("bd_contmig_nat",user,password)
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object <- connect(object)
			expect_that(object@connection,is_a("RODBC"))
		})



test_that("Test that RequeteDB returns the sql string when options(stacomiR.printqueries=TRUE) ", {
      skip_on_cran()
			o <- options()
			options(
					stacomiR.printqueries = TRUE
			)
      req<-new("RequeteODBC")
      req@sql<-"select * from iav.t_lot_lot limit 10"
      req@baseODBC <- c("bd_contmig_nat",user,password)   
      expect_output(req<- connect(req))
			options(o)
    })

