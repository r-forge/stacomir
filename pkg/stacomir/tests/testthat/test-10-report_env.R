context("report_env")

if (interactive()){
	if (!exists("user")){
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}
test_that("test creating an instance of report_env", {
			skip_on_cran()
			stacomi(database_expected = TRUE)
			o <- options()
			options(					
					stacomiR.dbname = "bd_contmig_nat",
					stacomiR.host ="localhost",
					stacomiR.port = "5432",
					stacomiR.user = user,
					stacomiR.user = password					
			)	
			r_env <- new("report_env")
			r_env <- choice_c(
					r_env,
					stationMesure = c("temp_gabion", "coef_maree"),
					datedebut = "2008-01-01",
					datefin = "2008-12-31",
					silent = TRUE
			)
			r_env <- connect(r_env, silent = TRUE)
			expect_true(nrow(r_env@data) > 0,
					"The is a problem when loading data in the data slot")
			options(o)
			rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
		})

test_that("test plot method", {
			skip_on_cran()
			stacomi(database_expected = TRUE)
			o <- options()
			options(					
					stacomiR.dbname = "bd_contmig_nat",
					stacomiR.host ="localhost",
					stacomiR.port = "5432",
					stacomiR.user = user,
					stacomiR.user = password					
			)	
			r_env <- new("report_env")
			r_env <- choice_c(
					r_env,
					stationMesure = c("temp_gabion", "coef_maree"),
					datedebut = "2008-01-01",
					datefin = "2008-12-31",
					silent = TRUE
			)
			r_env <- connect(r_env, silent = TRUE)
			expect_error(r_env <- plot(r_env), NA)
			rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
			options(o)
		})
