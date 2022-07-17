context("RequeteDB")

test_that("Test that RequeteDB works on a database ", {
			skip_on_cran()
			env_set_test_stacomi()
			object <-new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object@dbname <- "bd_contmig_nat"
			object@host <- 		host
			object@port <-		"5432"
			object@user <-		user
			object@password <-		password
			object <- query(object)
			expect_that(object@connection,is_a("Pool"))
			expect_gt(nrow(object@query),0)
		})

test_that("Test that RequeteDB works when passed arguments base", {
			skip_on_cran()
			env_set_test_stacomi()
			object <-new("RequeteDB")
			base <-
					c("bd_contmig_nat", host, "5432", user, password)
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object <- query(object, base)
			expect_that(object@connection,is_a("Pool"))
			expect_gt(nrow(object@query),0)
		})

test_that("Test that RequeteDB works when using options", {
			skip_on_cran()	
			
			o <- options()
			options(					
							stacomiR.dbname = "bd_contmig_nat",
							stacomiR.host = "localhost",
							stacomiR.port = "5432",
							stacomiR.user = "postgres",
							stacomiR.password = "postgres"					
					)	
			object <-new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object <- query(object)

			expect_that(object@connection,is_a("Pool"))
			expect_gt(nrow(object@query),0)
			options(o)
		})


test_that("Test that RequeteDB does not work when using wrong options and no base", {
			skip_on_cran()
			o <- options()
			options(					
					stacomiR.dbname = "bd_contmig_nat",
					stacomiR.host = "localhost",
					stacomiR.port = "5432",
					stacomiR.user = "",
					stacomiR.password = ""					
			)	
			object <-new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			expect_error(object <- query(object))
			options(o)
		})


test_that("Test that RequeteDB returns the sql string when options(stacomiR.printquery=TRUE) ", {
			skip_on_cran()
			env_set_test_stacomi()
			o <- options()
			options(					
					stacomiR.printqueries = TRUE
			)	
			object <- new("RequeteDB")
			object@sql <- "select * from iav.t_lot_lot limit 10"
			object@dbname <- "bd_contmig_nat"
			object@host <- 		host
			object@port <-		"5432"
			object@user <-		user
			object@password <-		password 
			expect_output(object<-query(object))
			options(o)
			
		})

