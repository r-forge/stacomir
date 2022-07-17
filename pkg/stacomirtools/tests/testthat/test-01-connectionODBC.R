
context("ConnectionODBC")


test_that("ConnectionODBC works", {
      skip_on_cran()
			env_set_test_stacomi()
			options(stacomiR.printquery=TRUE)
      object <- new("ConnectionODBC")
			object@baseODBC <- c("bd_contmig_nat", user, password)  
			suppressWarnings(object <- connect(object))
			expect_that(object@connection,is_a("RODBC"))
			odbcClose(object@connection)
    })


