context("ConnectionDB")

test_that("Test that ConnectionDB returns a pool object and closes ", {
        skip_on_cran()
				object<-new("ConnectionDB")
				object@dbname <- "bd_contmig_nat"
				object@host <- 		"localhost"
				object@port <-		"5432"
				object@user <-		"postgres"
				object@password <-		"postgres"
				object <- connect(object)
				expect_true(pool::dbGetInfo(object@connection)$valid)
 				pool::poolClose(object@connection)
				expect_error(pool::dbGetInfo(object@connection)$valid)				
    })

test_that("Test that ConnectionDB returns error when dbname length >1 ", {
			skip_on_cran()
			object <- new("ConnectionDB")
			object@dbname <- c("bd_contmig_nat","test")
			object@host <- 		"localhost"
			object@port <-		"5432"
			object@user <-		"postgres"
			object@password <-		"postgres"	
			expect_error(connect(object))				
		})

test_that("Test that RequeteDB returns a pool object", {
			skip_on_cran()
			# this requires an odbc link to be setup for test here a database bd_contmig_nat used for stacomir
			# the odbc link is bd_contmig_nat and points to database bd_contmig_nat
			object<-new("ConnectionDB")
			object@dbname <- "bd_contmig_nat"
			object@host <- 		"localhost"
			object@port <-		"5432"
			object@user <-		"postgres"
			object@password <-		"postgres"	
			object <- connect(object)
			expect_that(object@connection,is_a("Pool"))
			pool::poolClose(object@connection)
		})

test_that("Test that RequeteDB works when a base is passed to connect", {
			skip_on_cran()
			# this requires an odbc link to be setup for test here a database bd_contmig_nat used for stacomir
			# the odbc link is bd_contmig_nat and points to database bd_contmig_nat
			object<-new("ConnectionDB")
			base <- c("bd_contmig_nat","localhost","5432","postgres","postgres")
			object <- connect(object,base)
			expect_that(object@connection,is_a("Pool"))
			pool::poolClose(object@connection)
		})