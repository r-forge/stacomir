context("report_sea_age")
if (interactive()){
	if (!exists("user")){
		user <- readline(prompt="Enter user: ")
		password <- readline(prompt="Enter password: ")	
	}	
}

test_that("test creating an instance of report_sea_age with data loaded (logrami required)",
          {
            skip_on_cran()
            stacomi(database_expected = TRUE, sch ="logrami")
            r_seaa <- new("report_sea_age")
						o <- options()
						options(					
								stacomiR.dbname = "bd_contmig_nat",
								stacomiR.host ="localhost",
								stacomiR.port = "5432",
								stacomiR.user = user,
								stacomiR.user = password						
						)	
            r_seaa <- suppressWarnings(
              choice_c(
                r_seaa,
                dc = c(107, 108, 101),
                horodatedebut = "2012-01-01",
                horodatefin = "2012-12-31",
                limit1hm = 675,
                limit2hm = 875,
                silent = TRUE
              )
            )
            # warnings No data for par 1786No data for par 1785
             expect_error( r_seaa <- connect(r_seaa, silent = TRUE), NA)
            rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
						options(o)
          })

test_that("test that loading bad limits fails", {
  skip_on_cran()
  stacomi(database_expected = FALSE, sch= "logrami")
	o <- options()
	options(					
			stacomiR.dbname = "bd_contmig_nat",
			stacomiR.host ="localhost",
			stacomiR.port = "5432",
			stacomiR.user = user,
			stacomiR.user = password						
	)	
  r_seaa <- new("report_sea_age")
  
  expect_error(
    r_seaa <- choice_c(
      r_seaa,
      dc = c(107, 108, 101),
      horodatedebut = "2012-01-01",
      horodatefin = "2012-12-31",
      limit1hm = 675,
      limit2hm = "strawberry",
      silent = FALSE
    )
  )
  rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
})
