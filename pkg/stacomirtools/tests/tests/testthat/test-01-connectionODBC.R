
context("ConnectionODBC")

test_that("Test that ConnectionODBC returns the sql string when envir_stacomi and showmerequest ", {
      skip_on_cran()
      envir_stacomi <- new.env()
      assign("showmerequest",1,envir_stacomi)
      object <- new("ConnectionODBC")
			object@baseODBC <- c("bd_contmig_nat","postgres","postgres")  
			object <- connect(object)
			expect_that(object@connection,is_a("RODBC"))
			odbcClose(object@connection)
    })


