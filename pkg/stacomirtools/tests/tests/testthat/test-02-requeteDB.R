context("RequeteDB")
test_that("Test that RequeteDB works on a database ", {
			skip_on_cran()
			object <-new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object@dbname <- "bd_contmig_nat"
			object@host <- 		"localhost"
			object@port <-		"5432"
			object@user <-		"postgres"
			object@password <-		"postgres"
			object <- query(object)
			expect_that(object@connection,is_a("Pool"))
			expect_gt(nrow(object@query),0)
		})


test_that("Test that RequeteDB returns the sql string when envir_stacomi and showmerequest ", {
			skip_on_cran()
			skip_if_not_installed ("stacomiR")
			envir_stacomi <- new.env(parent=asNamespace("stacomiR"))
			assign("showmerequest",1,envir_stacomi)
			object <- new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object@dbname <- "bd_contmig_nat"
			object@host <- 		"localhost"
			object@port <-		"5432"
			object@user <-		"postgres"
			object@password <-		"postgres" 
			#object@silent <- FALSE
			expect_output(object<-query(object))
			
			
		})

