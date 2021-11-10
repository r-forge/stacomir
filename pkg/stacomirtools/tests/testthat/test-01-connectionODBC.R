
context("ConnectionODBC")

if (interactive()){
	if (!exists("user")){
		host <- readline(prompt="Enter host: ")
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}
test_that("ConnectionODBC works", {
      skip_on_cran()
			options(stacomiR.printquery=TRUE)
      object <- new("ConnectionODBC")
			object@baseODBC <- c("bd_contmig_nat", user, password)  
			object <- connect(object)
			expect_that(object@connection,is_a("RODBC"))
			odbcClose(object@connection)
    })


