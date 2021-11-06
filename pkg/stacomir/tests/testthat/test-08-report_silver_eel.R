context("report_silver_eel")
if (interactive()){
	if (!exists("user")){
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}

test_that(
		"test creating an instance of report_silver_eel with data loaded (fd80 schema required)",
		{
			skip_on_cran()
			stacomi(database_expected = TRUE, sch ='fd80')
			o <- options()
			options(					
					stacomiR.dbname = "bd_contmig_nat",
					stacomiR.host ="localhost",
					stacomiR.port = "5432",
					stacomiR.user = user,
					stacomiR.password = password						
			)	
			r_silver <- new("report_silver_eel")
			r_silver <- choice_c(
					r_silver,
					dc = c(2, 6),
					horodatedebut = "2010-09-01",
					horodatefin = "2016-10-04",
					silent = TRUE
			)
			r_silver <- connect(r_silver, silent = TRUE)
			# warnings No data for par 1786No data for par 1785
			r_silver <- suppressWarnings(calcule(r_silver, silent = TRUE))
			expect_error({
						plot(r_silver, plot.type = 1)
						plot(r_silver, plot.type = 2)
						suppressWarnings(plot(r_silver, plot.type = 3))
						plot(r_silver, plot.type = 4)
						# print a summary statistic, and save the output in a list for later use
						stats <- summary(r_silver, silent = TRUE)
					},NA)
			rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
			options(o)
		}
)
