context("ConnectionDB")
if (interactive()){
	if (!exists("user")){
		host <- readline(prompt="Enter host: ")
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}
test_that("Test that ConnectionDB returns a pool object and closes ", {
        skip_on_cran()
				object<-new("ConnectionDB")
				object@dbname <- "bd_contmig_nat"
				object@host <- 		host
				object@port <-		"5432"
				object@user <-		user
				object@password <-		password
				object <- connect(object)
				expect_true(pool::dbGetInfo(object@connection)$valid)
 				pool::poolClose(object@connection)
				expect_error(pool::dbGetInfo(object@connection)$valid)				
    })

test_that("Test that ConnectionDB returns error when dbname length >1 ", {
			skip_on_cran()
			object <- new("ConnectionDB")
			object@dbname <- c("bd_contmig_nat","test")
			object@host <- 		host
			object@port <-		"5432"
			object@user <-		user
			object@password <-		password	
			expect_error(connect(object))				
		})

test_that("Test that ConnectionDB returns a pool object", {
			skip_on_cran()
			object<-new("ConnectionDB")
			object@dbname <- "bd_contmig_nat"
			object@host <- 		host
			object@port <-		"5432"
			object@user <-		user
			object@password <-		password
			object <- connect(object)
			expect_that(object@connection,is_a("Pool"))
			pool::poolClose(object@connection)
		})

test_that("Test that ConnectionDB works when a base is passed to connect", {
			skip_on_cran()
			object<-new("ConnectionDB")
			base <- c("bd_contmig_nat",host,"5432",user,password)
			object <- connect(object,base)
			expect_that(object@connection,is_a("Pool"))
			pool::poolClose(object@connection)
		})

test_that("Test that ConnectionDB works when using options", {
			skip_on_cran()
			o <- options()
			options(					
					stacomiR.dbname = "bd_contmig_nat",
					stacomiR.host = host,
					stacomiR.port = "5432",
					stacomiR.user = user,
					stacomiR.password = password					
			)	
			object <-new("ConnectionDB")
			object <- connect(object)
			expect_that(object@connection,is_a("Pool"))
			pool::poolClose(object@connection)
			options(o)
		})